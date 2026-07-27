defmodule MovieMatch.Sessions.Participant do
  use Ecto.Schema
  import Ecto.Changeset

  schema "participants" do
    field :name, :string
    field :ready, :boolean, default: false
    field :host, :boolean, default: false

    has_many :movie_votes, MovieMatch.Sessions.MovieVote

    belongs_to :session, MovieMatch.Sessions.Session,
      foreign_key: :session_id,
      references: :id,
      type: :string

    timestamps(type: :utc_datetime)
  end

  def changeset(participant, attrs) do
    participant
    |> cast(attrs, [:name, :session_id, :ready, :host])
    |> validate_required([:name, :session_id])
  end
end