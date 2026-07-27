defmodule MovieMatchWeb.SessionLive.Match do
  use MovieMatchWeb, :live_view

  alias MovieMatch.Movies.Provider

  import MovieMatchWeb.Components.Movie.MovieCover
  import MovieMatchWeb.Components.Movie.MovieInformation

  def mount(%{"id" => _id}, _session, socket) do
    movies = Provider.discover()

    {:ok,
     socket
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
    IO.inspect(
      %{
        movie: socket.assigns.movie.title,
        vote: vote
      },
      label: "Vote"
    )

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