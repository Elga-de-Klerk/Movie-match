defmodule MovieMatch.Movies.Movie do
  defstruct [
    :id,
    :title,
    :overview,
    :poster,
    :release_year,
    :genres,
    :runtime
  ]
end