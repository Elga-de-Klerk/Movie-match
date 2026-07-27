defmodule MovieMatch.Sessions.MovieVote do
  use Ecto.Schema
  import Ecto.Changeset

  schema "movie_votes" do
    belongs_to :session, MovieMatch.Sessions.Session,
      type: :string

    belongs_to :participant, MovieMatch.Sessions.Participant

    field :movie_id, :integer
    field :liked, :boolean

    timestamps()
  end

  def changeset(movie_vote, attrs) do
    movie_vote
    |> cast(attrs, [:session_id, :participant_id, :movie_id, :liked])
    |> validate_required([:session_id, :participant_id, :movie_id, :liked])
  end
end