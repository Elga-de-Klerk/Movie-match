defmodule MovieMatch.Sessions do
  import Ecto.Query, warn: false

  alias MovieMatch.Repo
  alias MovieMatch.Sessions.Session

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

  def get_participant_by_id!(id) do
    Repo.get!(Participant, id)
  end

  alias MovieMatch.Sessions.MovieVote

  def create_movie_vote(attrs) do
    %MovieVote{}
    |> MovieVote.changeset(attrs)
    |> Repo.insert()
  end
end
