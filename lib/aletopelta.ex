defmodule Aletopelta do
  use Application
  @moduledoc """
  Documentation for `Aletopelta`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Aletopelta.hello()
      :world

  """
  def hello do
    :world
  end

  def start(_type, _args) do
    args = System.argv()

    children = Enum.map(args, &(case &1 do
      "01-1" -> Aletopelta.Day20241201.Part1
      "01-2" -> Aletopelta.Day20241201.Part2
      _ -> 0
    end)) |> Enum.filter(&(&1 != 0))

    Supervisor.start_link(children, [strategy: :one_for_one, name: Aletopelta.Supervisor])
  end
end
