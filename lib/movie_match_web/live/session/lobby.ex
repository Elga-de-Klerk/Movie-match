defmodule MovieMatchWeb.SessionLive.Lobby do
  use MovieMatchWeb, :live_view

  alias MovieMatch.Sessions

  import MovieMatchWeb.Components.Session.SessionHeader
  import MovieMatchWeb.Components.Session.JoinForm
  import MovieMatchWeb.Components.Session.ParticipantList

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
     |> assign(:participants, Sessions.list_participants(id))
     |> assign(:joined, false)
     |> assign(:name, "")
     |> assign(:participant_id, nil)}
  end


  def handle_params(params, _uri, socket) do
    participant_id =
      case params["participant_id"] do
        nil -> nil
        id -> String.to_integer(id)
      end

    {:noreply,
     socket
     |> assign(:joined, participant_id != nil)
     |> assign(:participant_id, participant_id)}
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

    Phoenix.PubSub.broadcast(
      MovieMatch.PubSub,
      "session:#{socket.assigns.session.id}",
      {:participant_joined, participant}
    )

    {:noreply,
     socket
     |> assign(:participants, Sessions.list_participants(socket.assigns.session.id))
     |> assign(:joined, true)}
  end

  def handle_event("toggle_ready", _params, socket) do
    # temporary placeholder
    {:noreply, socket}
  end

  def handle_info({:participant_joined, _participant}, socket) do
    participants =
      Sessions.list_participants(socket.assigns.session.id)

    {:noreply,
     assign(socket, :participants, participants)}
  end

  def render(assigns) do
    ~H"""
    <main class="min-h-screen bg-slate-950 text-white">
      <div class="mx-auto flex min-h-screen max-w-xl items-center px-6 py-12">
        <div class="w-full">

          <.session_header session={@session}/>

          <%= unless @joined do %>
            <.join_form name={@name}/>
          <% end %>

          <.participant_list
            participants={@participants}
            current_participant_id={@participant_id}
          />

          <button
            class="mt-6 w-full rounded-xl bg-violet-600 px-6 py-3 font-semibold transition hover:bg-violet-500"
          >
            Start Swiping
          </button>

        </div>
      </div>
    </main>
    """
  end
end