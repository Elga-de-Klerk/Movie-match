defmodule MovieMatch.Movies.Cache do
  use GenServer

  alias MovieMatch.Movies.TMDB

  @table :movie_cache
  @popular_ttl_ms :timer.minutes(5)

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def genres do
    case :ets.lookup(@table, :genres) do
      [{:genres, genres}] -> genres
      [] -> GenServer.call(__MODULE__, :load_genres, 15_000)
    end
  end

  def popular_movies do
    case :ets.lookup(@table, :popular_movies) do
      [{:popular_movies, movies, expires_at}] ->
        if System.monotonic_time(:millisecond) < expires_at do
          movies
        else
          GenServer.call(__MODULE__, :load_popular_movies, 15_000)
        end

      [] ->
        GenServer.call(__MODULE__, :load_popular_movies, 15_000)
    end
  end

  def movies_for_providers(provider_ids) do
    key = {:movies, Enum.sort(provider_ids)}

    case :ets.lookup(@table, key) do
      [{^key, movies, expires_at}] ->
        if System.monotonic_time(:millisecond) < expires_at do
          movies
        else
          GenServer.call(__MODULE__, {:load_movies, provider_ids, key}, 15_000)
        end

      [] ->
        GenServer.call(__MODULE__, {:load_movies, provider_ids, key}, 15_000)
    end
  end

  def movies_for_filters(provider_ids, genre_ids) do
    key = {:movies, Enum.sort(provider_ids), Enum.sort(genre_ids)}

    case :ets.lookup(@table, key) do
      [{^key, movies, expires_at}] ->
        if System.monotonic_time(:millisecond) < expires_at do
          movies
        else
          GenServer.call(__MODULE__, {:load_filtered_movies, provider_ids, genre_ids, key}, 15_000)
        end

      [] ->
        GenServer.call(__MODULE__, {:load_filtered_movies, provider_ids, genre_ids, key}, 15_000)
    end
  end

  @impl true
  def handle_call({:load_filtered_movies, provider_ids, genre_ids, key}, _from, state) do
    movies = TMDB.discover_by_providers(provider_ids, genre_ids)
    expires_at = System.monotonic_time(:millisecond) + @popular_ttl_ms
    :ets.insert(@table, {key, movies, expires_at})
    {:reply, movies, state}
  end

  def movie_details(id) do
    key = {:movie_details, id}

    case :ets.lookup(@table, key) do
      [{^key, details}] -> details
      [] -> GenServer.call(__MODULE__, {:load_movie_details, id}, 15_000)
    end
  end

  @impl true
  def init(_), do: {:ok, %{}} |> tap(fn _ -> :ets.new(@table, [:named_table, :public, read_concurrency: true]) end)

  @impl true
  def handle_call(:load_genres, _from, state) do
    genres = TMDB.genres()
    :ets.insert(@table, {:genres, genres})
    {:reply, genres, state}
  end

  @impl true
  def handle_call(:load_popular_movies, _from, state) do
    movies = TMDB.popular_movies()
    expires_at = System.monotonic_time(:millisecond) + @popular_ttl_ms
    :ets.insert(@table, {:popular_movies, movies, expires_at})
    {:reply, movies, state}
  end

  @impl true
  def handle_call({:load_movie_details, id}, _from, state) do
    details = TMDB.movie_details(id)
    :ets.insert(@table, {{:movie_details, id}, details})
    {:reply, details, state}
  end

  @impl true
  def handle_call({:load_movies, provider_ids, key}, _from, state) do
    movies = TMDB.discover_by_providers(provider_ids)
    expires_at = System.monotonic_time(:millisecond) + @popular_ttl_ms
    :ets.insert(@table, {key, movies, expires_at})
    {:reply, movies, state}
  end
end