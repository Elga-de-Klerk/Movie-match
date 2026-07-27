defmodule MovieMatchWeb.SessionLive.Create do
  use MovieMatchWeb, :live_view

  alias MovieMatch.Sessions

  import MovieMatchWeb.Components.ServiceCard

  def mount(_params, _session, socket) do
    services = [
      %{id: "netflix", name: "Netflix", logo: "/images/providers/netflix.svg"},
      %{id: "disney", name: "Disney+", logo: "/images/providers/disney-plus.svg"},
      %{id: "prime", name: "Prime Video", logo: "/images/providers/prime-video.svg"},
      %{id: "hbo", name: "HBO Max", logo: "/images/providers/hbo-max.svg"}
    ]

    {:ok,
     socket
     |> assign(:services, services)
     |> assign(:selected_services, [])
     |> assign(:name, "")}
  end

  def handle_event("update_form", %{"name" => name}, socket) do
    {:noreply, assign(socket, :name, name)}
  end

  def handle_event("toggle_service", %{"service" => service}, socket) do
    services = socket.assigns.selected_services

    updated =
      if service in services do
        List.delete(services, service)
      else
        [service | services]
      end

    {:noreply,
     assign(socket, :selected_services, updated)}
  end

  def handle_event("create_session", _params, socket) do
    {:ok, session} =
      Sessions.create_session(%{
        id: generate_session_id(),
        selected_services: socket.assigns.selected_services
      })

    {:ok, participant} =
      Sessions.add_participant(%{
        name: socket.assigns.name,
        session_id: session.id,
        host: true
      })

    {:noreply,
       push_navigate(
         socket,
         to: "/session/#{session.id}?participant_id=#{participant.id}"
       )}
  end

  defp generate_session_id do
    :crypto.strong_rand_bytes(6)
    |> Base.encode32(case: :lower)
    |> binary_part(0, 6)
  end
end