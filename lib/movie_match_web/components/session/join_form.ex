defmodule MovieMatchWeb.Components.Session.JoinForm do
  use Phoenix.Component

  attr :name, :list, required: true

  def join_form(assigns) do
    ~H"""
    <section class="mt-6 rounded-2xl bg-slate-900 p-6">
      <h2 class="text-lg font-semibold">
        Join session
      </h2>

      <form phx-submit="join_session">
        <input
          name="name"
          value={@name}
          phx-change="update_name"
          placeholder="Your name"
          class="mt-4 w-full rounded-xl bg-slate-800 px-4 py-3 text-white outline-none ring-1 ring-slate-800"
        />

        <button
          disabled={@name == ""}
          class="mt-4 w-full rounded-xl bg-violet-600 px-4 py-3 font-semibold transition disabled:bg-slate-700"
        >
          Join Session
        </button>
      </form>
    </section>
    """
  end
end