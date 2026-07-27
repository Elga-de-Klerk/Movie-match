defmodule MovieMatch.Sessions.Session do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :string, autogenerate: false}

  schema "sessions" do
    field :selected_services, {:array, :string}, default: []

    has_many :participants, MovieMatch.Sessions.Participant

    timestamps(type: :utc_datetime)
  end

  def changeset(session, attrs) do
    session
    |> cast(attrs, [:id, :selected_services])
    |> validate_required([:id])
    |> unique_constraint(:id)
  end
end