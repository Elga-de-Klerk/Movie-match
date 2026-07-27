defmodule MovieMatch.Movies.Provider do
  alias MovieMatch.Movies.Movie
  alias MovieMatch.Movies.Cache

  def discover do
    genre_lookup = Cache.genres()

    Cache.popular_movies()
    |> Enum.map(&convert_movie(&1, genre_lookup))
  end

  defp convert_movie(movie, genre_lookup) do
    genre_names =
      movie["genre_ids"]
      |> Enum.map(&genre_lookup[&1])
      |> Enum.reject(&is_nil/1)

    %Movie{
      id: movie["id"],
      title: movie["title"],
      overview: movie["overview"],
      poster: "https://image.tmdb.org/t/p/w342#{movie["poster_path"]}",
      release_year: movie["release_date"] |> String.slice(0, 4),
      genres: genre_names,
      runtime: nil
    }
  end
end