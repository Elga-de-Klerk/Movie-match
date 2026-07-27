defmodule MovieMatchWeb.HomeLive do
  use MovieMatchWeb, :live_view

  def render(assigns) do
    ~H"""
    <main class="min-h-screen bg-slate-950 text-white">
      <div class="mx-auto flex min-h-screen max-w-6xl items-center px-6">
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
            <.link
              navigate="/session/new"
              class="rounded-xl bg-violet-600 px-6 py-3 text-center font-semibold hover:bg-violet-500"
            >
              Start Session
            </.link>

            <.link
              navigate="/join"
              class="rounded-xl border border-slate-700 px-6 py-3 text-center font-semibold hover:bg-slate-900"
            >
              Join Session
            </.link>
          </div>
        </div>
      </div>
    </main>
    """
  end
end