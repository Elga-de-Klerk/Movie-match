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

  def handle_event("start_matching", _params, socket) do
    {:noreply,
     push_navigate(
       socket,
       to: "/session/#{socket.assigns.session.id}/match?participant_id=#{socket.assigns.participant_id}"
     )}
  end
end