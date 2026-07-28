defmodule MovieMatchWeb.Components.Session.SessionHeader do
  use MovieMatchWeb, :component

  attr :session, :map, required: true
  attr :is_host, :boolean, default: false

  def session_header(assigns) do
    ~H"""
    <div class="text-center">
      <.heading>MovieMatch Session</.heading>

      <%= if @is_host do %>
        <.subtext class="mt-3">
          Invite your friends and find something to watch together.
        </.subtext>

        <section class="mt-8 rounded-2xl bg-slate-900 p-6">
          <.subtext>Session code</.subtext>

          <p class="mt-2 text-2xl font-semibold tracking-widest">
            <%= @session.id %>
          </p>
        </section>
      <% end %>
    </div>
    """
  end
end