defmodule MovieMatchWeb.Components.Session.ParticipantList do
  use Phoenix.Component

  attr :participants, :list, required: true
  attr :current_participant_id, :string, default: nil

  def participant_list(assigns) do
    ~H"""
    <section class="mt-6 rounded-2xl bg-slate-900 p-6">
      <h2 class="text-lg font-semibold">
        Participants
      </h2>

      <div class="mt-4 space-y-3">
        <%= for participant <- @participants do %>
          <div class="flex items-center justify-between rounded-xl bg-slate-800 px-4 py-3">
            <div class="flex items-center gap-3">
              <span>
                <%= participant.name %>
              </span>

              <%= if participant.id == @current_participant_id do %>
                <span class="text-sm text-slate-400">
                  You
                </span>
              <% end %>
            </div>

            <%= if participant.host do %>
              <span class="text-sm text-violet-400">
                Host
              </span>
            <% end %>
          </div>
        <% end %>
      </div>
    </section>
    """
  end
end