defmodule MovieMatchWeb.Components.Session.SessionHeader do
  use Phoenix.Component

  attr :session, :map, required: true
  attr :is_host, :boolean, default: false

  def session_header(assigns) do
    ~H"""
    <div class="text-center">
      <h1 class="text-4xl font-bold">
        MovieMatch Session
      </h1>

      <%= if @is_host do %>
        <p class="mt-3 text-slate-400">
          Invite your friends and find something to watch together.
        </p>

        <section class="mt-8 rounded-2xl bg-slate-900 p-6">
          <p class="text-sm text-slate-400">
            Session code
          </p>

          <p class="mt-2 text-2xl font-semibold tracking-widest">
            <%= @session.id %>
          </p>
        </section>
        <% end %>
    </div>
    """
  end
end