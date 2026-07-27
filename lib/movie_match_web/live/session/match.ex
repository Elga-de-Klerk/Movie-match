defmodule MovieMatchWeb.SessionLive.Match do
  use MovieMatchWeb, :live_view

  alias MovieMatch.Sessions
  alias MovieMatch.Movies.Provider

  import MovieMatchWeb.Components.Movie.MovieCover
  import MovieMatchWeb.Components.Movie.MovieInformation

  def mount(%{"id" => id}, _session, socket) do
    session = Sessions.get_session_by_id!(id)
    movies = Provider.discover()

    {:ok,
     socket
     |> assign(:session, session)
     |> assign(:movies, movies)
     |> assign(:movie_index, 0)
     |> assign(:movie, Enum.at(movies, 0))
     |> assign(:next_movie, Enum.at(movies, 1))
     |> assign(:show_description, false)}
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

  defp handle_vote(vote, socket) do
    socket =
      socket
      |> save_vote(vote)
      |> next_movie()

    {:noreply, socket}
  end

  defp save_vote(socket, vote) do
    Sessions.create_movie_vote(%{
      session_id: socket.assigns.session.id,
      participant_id: socket.assigns.participant_id,
      movie_id: socket.assigns.movie.id,
      liked: vote == :like
    })

    socket
  end

  defp next_movie(socket) do
    index = socket.assigns.movie_index + 1
    movie = Enum.at(socket.assigns.movies, index)

    socket
    |> assign(:movie_index, index)
    |> assign(:movie, movie)
    |> assign(:next_movie, Enum.at(socket.assigns.movies, index + 1))
    |> assign(:show_description, false)
  end
end