defmodule MovieMatchWeb.SessionLive.Match do
  use MovieMatchWeb, :live_view

  alias MovieMatch.Sessions

  import MovieMatchWeb.Components.Movie.MovieCover
  import MovieMatchWeb.Components.Movie.MovieInformation

  def mount(%{"id" => id}, _session, socket) do
    session = Sessions.get_session_by_id!(id)

    {:ok,
     socket
     |> assign(:session, session)
     |> assign(:show_description, false)
     |> assign(:movie, fake_movie())}
  end

  def handle_event("toggle_description", _params, socket) do
    {:noreply,
     update(socket, :show_description, fn value -> !value end)}
  end

  defp fake_movie do
    %{
      title: "Interstellar",
      year: 2014,
      genres: ["Sci-Fi", "Adventure"],
      runtime: "2h 49m",
      overview: """
      A team of explorers travels through a wormhole in space in an attempt
      to ensure humanity's survival.
      """,
      poster: "https://m.media-amazon.com/images/M/MV5BYzdjMDAxZGItMjI2My00ODA1LTlkNzItOWFjMDU5ZDJlYWY3XkEyXkFqcGc@._V1_.jpg"
    }
  end
end