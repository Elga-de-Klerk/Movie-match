defmodule MovieMatchWeb.SessionLive.Lobby do
  use MovieMatchWeb, :live_view

  alias MovieMatch.Sessions

  def mount(%{"id" => id}, _session, socket) do
    session = Sessions.get_session_by_id!(id)

    {:ok,
     socket
     |> assign(:session, session)
     |> assign(:participants, Sessions.list_participants(id))}
  end

  def render(assigns) do
    ~H"""
    <main class="min-h-screen bg-slate-950 text-white">
      <div class="mx-auto flex min-h-screen max-w-xl items-center px-6 py-12">
        <div class="w-full text-center">

          <h1 class="text-4xl font-bold">
            Your movie session is ready
          </h1>

          <p class="mt-4 text-slate-400">
            Share this link with your friends:
          </p>

          <div class="mt-6 rounded-xl bg-slate-900 p-4">
            <%= @session.id %>
          </div>

          <div class="mt-10">
            <h2 class="text-xl font-bold">
              Participants
            </h2>

            <div class="mt-4 space-y-2">
              <%= for participant <- @participants do %>
                <div class="rounded-xl bg-slate-900 p-3">
                  <%= participant.name %>
                </div>
              <% end %>
            </div>
          </div>

          <button
            class="mt-10 w-full rounded-xl bg-violet-600 px-6 py-3 font-semibold transition hover:bg-violet-500"
          >
            Start Swiping
          </button>

        </div>
      </div>
    </main>
    """
  end
end