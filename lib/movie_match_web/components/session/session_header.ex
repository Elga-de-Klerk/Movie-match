defmodule MovieMatchWeb.Components.Session.SessionHeader do
  use MovieMatchWeb, :component

  attr :session, :map, required: true
  attr :is_host, :boolean, default: false
  attr :copied, :boolean, default: false

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

          <div class="mt-3 flex h-12 items-center justify-center gap-2">

            <span class="flex items-center text-2xl tracking-widest text-white">
              <%= @session.id %>
            </span>
            <button
                type="button"
                phx-click="copy_code"
                phx-value-code={@session.id}
                class="flex h-full items-center justify-center rounded-xl transition text-white"
              >
              <%= if @copied do %>
                <.icon name="hero-check" class="h-5 w-5" />
              <% else %>
                <.icon name="hero-clipboard-document" class="h-5 w-5" />
              <% end %>
            </button>
          </div>
        </section>
      <% end %>
    </div>
    """
  end
end