defmodule MovieMatchWeb.SessionLive.Create do
  use MovieMatchWeb, :live_view

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
            class="mt-10 w-full rounded-xl bg-violet-600 px-6 py-3 font-semibold transition hover:bg-violet-500"
          >
            Create Session
          </button>
        </div>
      </div>
    </main>
    """
  end
end