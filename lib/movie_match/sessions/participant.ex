defmodule MovieMatch.Sessions.Participant do
  use Ecto.Schema
  import Ecto.Changeset

  schema "participants" do
    field :name, :string

    belongs_to :session, MovieMatch.Sessions.Session,
      foreign_key: :session_id,
      references: :id,
      type: :string

    timestamps(type: :utc_datetime)
  end

  def changeset(participant, attrs) do
    participant
    |> cast(attrs, [:name, :session_id])
    |> validate_required([:name, :session_id])
  end
end