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
     |> assign(:movie, hd(movies))
     |> assign(:show_description, false)}
  end

  def handle_event("toggle_description", _params, socket) do
    {:noreply,
     update(socket, :show_description, fn value -> !value end)}
  end
end