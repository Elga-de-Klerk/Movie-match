defmodule MovieMatchWeb.HomeLive do
  use MovieMatchWeb, :live_view

  def render(assigns) do
    ~H"""
    <.page max_width="6xl">
      <div class="max-w-xl">
        <p class="text-sm font-semibold uppercase tracking-widest text-violet-400">
          MovieMatch
        </p>

        <h1 class="mt-6 text-5xl font-bold leading-tight sm:text-6xl">
          Find a movie
          <span class="text-violet-400">everyone</span>
          wants to watch.
        </h1>

        <p class="mt-6 text-lg text-slate-300">
          Create a session, invite your friends, and swipe together
          until you find your next movie night.
        </p>

        <div class="mt-10 flex flex-col gap-4 sm:flex-row">
          <.action_button navigate="/session/new">
            Start Session
          </.action_button>

          <.action_button navigate="/session/join" variant="secondary">
            Join Session
          </.action_button>
        </div>
      </div>
    </.page>
    """
  end
end