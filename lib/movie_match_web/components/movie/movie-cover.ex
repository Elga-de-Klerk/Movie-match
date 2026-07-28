defmodule MovieMatchWeb.Components.Movie.MovieCover do
  use MovieMatchWeb, :component

  import MovieMatchWeb.Components.Movie.MovieDetails

  attr :movie, :map, required: true

  def movie_cover(assigns) do
    ~H"""
    <div class="flex h-full flex-col bg-slate-900">

      <div class="flex h-[30rem] items-center justify-center p-6">
        <img
          src={@movie.poster}
          alt={@movie.title}
          class="h-[28rem] rounded-2xl object-cover shadow-lg"
          loading="eager"
          fetchpriority="high"
        />
      </div>

      <div class="flex-1 px-6 pb-6">
        <.heading class="line-clamp-1">
          <%= @movie.title %>
        </.heading>

        <.movie_details movie={@movie}/>

        <.caption>Click for description</.caption>
      </div>

    </div>
    """
  end
end