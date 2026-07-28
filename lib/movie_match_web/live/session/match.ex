defmodule MovieMatchWeb.SessionLive.Match do
  use MovieMatchWeb, :live_view

  alias MovieMatch.Sessions
  alias MovieMatch.Movies.Provider

  import MovieMatchWeb.Components.Movie.MovieCover
  import MovieMatchWeb.Components.Movie.MovieInformation

  def mount(%{"id" => id}, _session, socket) do
    session = Sessions.get_session_by_id!(id)

    if connected?(socket) do
      Phoenix.PubSub.subscribe(MovieMatch.PubSub, "session:#{id}")
    end

    movies = Provider.discover(session.selected_services)
    current = Enum.at(movies, 0)

    {:ok,
     socket
     |> assign(:session, session)
     |> assign(:movies, movies)
     |> assign(:movie_index, 0)
     |> assign(:movie, current && Provider.enrich_with_runtime(current))
     |> assign(:next_movie, Enum.at(movies, 1))
     |> assign(:show_description, false)
     |> assign(:matched_movie, nil)}
  end

  def handle_event("toggle_description", _params, socket) do
    {:noreply,
     update(socket, :show_description, fn value -> !value end)}
  end

  def handle_event("vote", %{"vote" => vote}, socket) do
    case vote do
      "like" -> handle_vote(:like, socket)
      "dislike" -> handle_vote(:dislike, socket)
    end
  end

  def handle_event("dismiss_match", _params, socket) do
    {:noreply, assign(socket, :matched_movie, nil)}
  end

  def handle_info({:match, movie}, socket) do
    {:noreply, assign(socket, :matched_movie, movie)}
  end

  defp handle_vote(vote, socket) do
    socket =
      socket
      |> save_vote(vote)
      |> next_movie()

    {:noreply, socket}
  end

  defp save_vote(socket, vote) do
    movie = socket.assigns.movie

    Sessions.create_movie_vote(%{
      session_id: socket.assigns.session.id,
      participant_id: socket.assigns.participant_id,
      movie_id: movie.id,
      liked: vote == :like
    })

    if vote == :like and Sessions.check_for_match(socket.assigns.session.id, movie.id) do
      Phoenix.PubSub.broadcast(
        MovieMatch.PubSub,
        "session:#{socket.assigns.session.id}",
        {:match, movie}
      )
    end

    socket
  end

  defp next_movie(socket) do
    index = socket.assigns.movie_index + 1
    movie = Enum.at(socket.assigns.movies, index)

    socket
    |> assign(:movie_index, index)
    |> assign(:movie, movie && Provider.enrich_with_runtime(movie))
    |> assign(:next_movie, Enum.at(socket.assigns.movies, index + 1))
    |> assign(:show_description, false)
  end
end