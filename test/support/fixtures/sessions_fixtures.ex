defmodule MovieMatch.SessionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `MovieMatch.Sessions` context.
  """

  @doc """
  Generate a session.
  """
  def session_fixture(attrs \\ %{}) do
    {:ok, session} =
      attrs
      |> Enum.into(%{
        \: "some \\"
      })
      |> MovieMatch.Sessions.create_session()

    session
  end

  @doc """
  Generate a participant.
  """
  def participant_fixture(attrs \\ %{}) do
    {:ok, participant} =
      attrs
      |> Enum.into(%{
        \: "some \\"
      })
      |> MovieMatch.Sessions.create_participant()

    participant
  end
end
