defmodule MovieMatch.Movies.TMDB do
  @base_url "https://api.themoviedb.org/3"

  @provider_ids %{
    "netflix" => 8,
    "disney" => 337,
    "prime" => 119,
    "hbo" => 1899
  }

  def provider_ids_for(services) do
    services
    |> Enum.map(&Map.get(@provider_ids, &1))
    |> Enum.reject(&is_nil/1)
  end

  def discover_by_providers(provider_ids, region \\ "NL") do
    Req.get!(
      "#{@base_url}/discover/movie",
      params: [
        api_key: api_key(),
        language: "en-US",
        watch_region: region,
        with_watch_providers: Enum.join(provider_ids, "|"),
        sort_by: "popularity.desc"
      ]
    ).body["results"]
  end

  def popular_movies do
    Req.get!(
      "#{@base_url}/movie/popular",
      params: [api_key: api_key(), language: "en-US"]
    ).body["results"]
  end

  def genres do
    Req.get!(
      "#{@base_url}/genre/movie/list",
      params: [api_key: api_key(), language: "en-US"]
    ).body["genres"]
    |> Map.new(fn %{"id" => id, "name" => name} -> {id, name} end)
  end

  def movie_details(id) do
    Req.get!(
      "#{@base_url}/movie/#{id}",
      params: [api_key: api_key(), language: "en-US"]
    ).body
  end

  defp api_key do
    Application.fetch_env!(:movie_match, :tmdb_api_key)
  end
end