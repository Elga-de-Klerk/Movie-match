defmodule MovieMatchWeb.Components.Session.ParticipantList do
  use Phoenix.Component

  attr :participants, :list, required: true

  def participant_list(assigns) do
    ~H"""
    <section class="mt-6 rounded-2xl bg-slate-900 p-6">
      <h2 class="text-lg font-semibold">
        Participants
      </h2>

      <div class="mt-4 space-y-3">
        <%= for participant <- @participants do %>
          <div class="flex items-center gap-3 rounded-xl bg-slate-800 px-4 py-3">
            <span>
              <%= participant.name %>
            </span>
          </div>
        <% end %>
      </div>
    </section>
    """
  end
end