defmodule MovieMatch.Movies.Provider do
  alias MovieMatch.Movies.Movie
  alias MovieMatch.Movies.Cache
  alias MovieMatch.Movies.TMDB

  def discover(selected_services, filters \\ %{}) do
    genre_lookup = Cache.genres()
    provider_ids = TMDB.provider_ids_for(selected_services)
    genre_ids = genre_ids_for(filters[:genres] || [], genre_lookup)
    genre_mode = filters[:genre_mode] || :or

    movies =
      case {provider_ids, genre_ids} do
        {[], []} -> Cache.popular_movies()
        _ -> Cache.movies_for_filters(provider_ids, genre_ids, genre_mode)
      end

    Enum.map(movies, &convert_movie(&1, genre_lookup))
  end

  defp genre_ids_for(genre_names, genre_lookup) do
    name_to_id = Map.new(genre_lookup, fn {id, name} -> {name, id} end)

    genre_names
    |> Enum.map(&Map.get(name_to_id, &1))
    |> Enum.reject(&is_nil/1)
  end

  def available_genres do
    Cache.genres()
    |> Map.values()
    |> Enum.sort()
  end

  def enrich_with_runtime(%Movie{id: id} = movie) do
      %{movie | runtime: Cache.movie_details(id)["runtime"]}
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