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

  def render(assigns) do
      ~H"""
      <main class="min-h-screen bg-slate-950 text-white">
        <div class="mx-auto flex min-h-screen max-w-xl items-center px-6 py-12">
          <div class="w-full">

            <.session_header
              session={@session}
              is_host={@participant_id != nil}
            />

            <form phx-submit="start_matching" class="mt-10">
              <%= if @participant_id == nil do %>
                <div class="rounded-2xl bg-slate-900 p-6">
                  <h2 class="text-xl font-semibold">
                    Join this session
                  </h2>

                  <p class="mt-2 text-sm text-slate-400">
                    Enter your name so your movie preferences can be matched with the group.
                  </p>

                  <input
                    name="name"
                    value={@name}
                    phx-change="update_name"
                    placeholder="Your name"
                    class="mt-6 w-full rounded-xl bg-slate-800 px-4 py-3 text-white placeholder:text-slate-500 outline-none ring-1 ring-slate-700 focus:ring-violet-500"
                  />
                </div>
              <% else %>
                <div class="rounded-2xl bg-slate-900 p-6">
                  <h2 class="text-xl font-semibold">
                    Ready to find a movie?
                  </h2>

                  <p class="mt-2 text-sm text-slate-400">
                    Start swiping and we'll find the movies everyone agrees on.
                  </p>
                </div>
              <% end %>

              <button
                @disabled={@name == ""}
                class={[
                    "mt-6 w-full rounded-xl px-6 py-3 font-semibold transition",
                    if(@name == "",
                      do: "cursor-not-allowed bg-slate-700 text-slate-400",
                      else: "bg-violet-600 hover:bg-violet-500"
                    )
                  ]}
              >
                Start Matching
              </button>
            </form>

          </div>
        </div>
      </main>
      """
  end
end