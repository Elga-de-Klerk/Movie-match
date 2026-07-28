defmodule MovieMatchWeb.SessionLive.Lobby do
  use MovieMatchWeb, :live_view

  alias MovieMatch.Sessions

  import MovieMatchWeb.Components.Session.SessionHeader
  import MovieMatchWeb.Components.Session.MoviePreferences

  def mount(%{"id" => id}, _session, socket) do
    session = Sessions.get_session_by_id!(id)

    if connected?(socket) do
      Phoenix.PubSub.subscribe(
        MovieMatch.PubSub,
        "session:#{id}"
      )
    end

    {:ok,
     socket
     |> assign(:session, session)
     |> assign(:movie_preferences, %{genres: socket.assigns.available_genres})
     |> assign(:genre_mode, :or)
     |> assign(:selected_genres, [])
     |> assign_new(:name, fn ->
       if socket.assigns[:participant] do
         socket.assigns.participant.name
       else
         ""
       end
     end)
     |> assign(:copied, false)}
  end

  def handle_event("copy_code", %{"code" => code}, socket) do
    {:noreply,
     socket
     |> assign(:copied, true)
     |> push_event("copy_to_clipboard", %{text: code})}
  end

  def handle_event("update_name", %{"name" => name}, socket) do
    {:noreply, assign(socket, :name, name)}
  end

  def handle_event("toggle_genre_mode", _params, socket) do
    mode = if socket.assigns.genre_mode == :or, do: :and, else: :or
    {:noreply, assign(socket, :genre_mode, mode)}
  end

  def handle_event("toggle_genre", %{"genre" => genre}, socket) do
    selected =
      if genre in socket.assigns.selected_genres do
        List.delete(socket.assigns.selected_genres, genre)
      else
        [genre | socket.assigns.selected_genres]
      end

    {:noreply,
     assign(socket, :selected_genres, selected)}
  end

  def handle_event("start_matching", %{"name" => name}, socket) do
    case socket.assigns.participant_id do
      nil ->
        {:ok, participant} =
          Sessions.add_participant(%{
            name: name,
            session_id: socket.assigns.session.id,
            host: false
          })

        {:noreply,
         push_navigate(
           socket,
           to: match_url(socket, participant.id)
         )}

      participant_id ->
        {:noreply,
         push_navigate(
           socket,
           to: match_url(socket, participant_id)
         )}
    end
  end

  def handle_event("start_matching", _params, socket) do
    {:noreply,
     push_navigate(
       socket,
       to: match_url(socket, socket.assigns.participant_id)
     )}
  end

  defp match_url(socket, participant_id) do
    genres = Enum.join(socket.assigns.selected_genres, ",")

    "/session/#{socket.assigns.session.id}/match?participant_id=#{participant_id}&genres=#{URI.encode_www_form(genres)}&genre_mode=#{socket.assigns.genre_mode}"
  end
end