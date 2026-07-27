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
     |> assign(:selected_services, [])}
  end

  def handle_event("toggle_service", %{"service" => service}, socket) do
    selected_services = socket.assigns.selected_services

    selected_services =
      if service in selected_services do
        List.delete(selected_services, service)
      else
        [service | selected_services]
      end

    {:noreply, assign(socket, :selected_services, selected_services)}
  end

  def handle_event("create_session", _params, socket) do
    {:ok, session} =
      Sessions.create_session(%{
        id: generate_session_id(),
        selected_services: socket.assigns.selected_services
      })

    {:noreply,
     push_navigate(socket,
       to: "/session/#{session.id}"
     )}
  end

  defp generate_session_id do
    :crypto.strong_rand_bytes(6)
    |> Base.encode32(case: :lower)
    |> binary_part(0, 6)
  end

  def render(assigns) do
    ~H"""
    <main class="min-h-screen bg-slate-950 text-white">
      <div class="mx-auto flex min-h-screen max-w-4xl items-center px-6 py-12">
        <div class="w-full">
          <h1 class="text-4xl font-bold">
            Create a movie session
          </h1>

          <p class="mt-3 text-slate-400">
            Select the streaming services you want to search.
          </p>

          <div class="mt-8 grid grid-cols-2 gap-4 sm:grid-cols-4">
            <%= for service <- @services do %>
              <.service_card
                service={service}
                selected={service.id in @selected_services}
              />
            <% end %>
          </div>

          <button
            phx-click="create_session"
            disabled={@selected_services == []}
            class={[
                "mt-10 w-full rounded-xl px-6 py-3 font-semibold transition",
                if(@selected_services == [],
                  do: "cursor-not-allowed bg-slate-700 text-slate-400",
                  else: "bg-violet-600 hover:bg-violet-500"
                )
              ]}
          >
            Create Session
          </button>
        </div>
      </div>
    </main>
    """
  end
end