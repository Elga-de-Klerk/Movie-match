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
     |> assign(:name, "")
     |> assign(:participant_id, nil)}
  end

  def handle_params(params, _uri, socket) do
    participant_id =
      if params["participant_id"] do
        String.to_integer(params["participant_id"])
      end

    participant =
      if participant_id do
        Sessions.get_participant_by_id!(participant_id)
      end

    {:noreply,
     socket
     |> assign(:participant_id, participant_id)
     |> assign(:name, participant && participant.name || "")}
  end

  def handle_event("update_name", %{"name" => name}, socket) do
    {:noreply, assign(socket, :name, name)}
  end

  def handle_event("join_session", _params, socket) do
    {:ok, participant} =
      Sessions.add_participant(%{
        name: socket.assigns.name,
        session_id: socket.assigns.session.id
      })

    {:noreply,
     socket
     |> assign(:joined, true)
     |> assign(:participant_id, participant.id)}
  end

  def handle_event("start_matching", _params, socket) do
    # participant creation logic here

    {:noreply,
     push_navigate(
       socket,
       to: "/session/#{socket.assigns.session.id}/match?participant_id=#{socket.assigns.participant_id}"
     )}
  end
end