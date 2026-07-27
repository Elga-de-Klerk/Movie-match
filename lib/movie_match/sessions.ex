defmodule MovieMatch.Sessions do
  import Ecto.Query, warn: false

  alias MovieMatch.Repo
  alias MovieMatch.Sessions.Session
  alias MovieMatch.Sessions.Participant

  def create_session(attrs \\ %{}) do
    %Session{}
    |> Session.changeset(attrs)
    |> Repo.insert()
  end

  def get_session_by_id!(id) do
    Repo.get_by!(Session, id: id)
  end

  alias MovieMatch.Sessions.Participant

  def add_participant(attrs) do
    %Participant{}
    |> Participant.changeset(attrs)
    |> Repo.insert()
  end

  def list_participants(session_id) do
    from(p in Participant,
      where: p.session_id == ^session_id
    )
    |> Repo.all()
  end
end
