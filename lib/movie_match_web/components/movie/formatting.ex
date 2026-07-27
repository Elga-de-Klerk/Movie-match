defmodule MovieMatchWeb.Components.Movie.Formatting do
  def format_runtime(nil), do: nil

  def format_runtime(minutes) when is_integer(minutes) do
    hours = div(minutes, 60)
    mins = rem(minutes, 60)

    case {hours, mins} do
      {0, m} -> "#{m}m"
      {h, 0} -> "#{h}h"
      {h, m} -> "#{h}h #{m}m"
    end
  end
end