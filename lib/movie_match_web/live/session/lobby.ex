defmodule MovieMatchWeb.SessionLive.Lobby do
  use MovieMatchWeb, :live_view

  alias MovieMatch.Sessions

  import MovieMatchWeb.Components.Session.SessionHeader

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
     |> assign_new(:name, fn ->
       if socket.assigns[:participant] do
         socket.assigns.participant.name
       else
         ""
       end
     end)}
  end

  def handle_event("update_name", %{"name" => name}, socket) do
    {:noreply, assign(socket, :name, name)}
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
           to: "/session/#{socket.assigns.session.id}/match?participant_id=#{participant.id}"
         )}

      participant_id ->
        {:noreply,
         push_navigate(
           socket,
           to: "/session/#{socket.assigns.session.id}/match?participant_id=#{participant_id}"
         )}
    end
  end
end