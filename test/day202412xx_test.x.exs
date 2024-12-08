defmodule AletopeltaTest.Day202412xx do
  use ExUnit.Case
  @filename "2024/day/xx/input"

  defp get_input!(), do: AletopeltaTest.get_input!(@filename)
  |> String.split("\n")

  test "part1 is loaded" do
    input = get_input!()

    assert Aletopelta.Day202412xx.Part1.execute(input) == String.to_integer(Application.get_env(:aletopelta, :day202412xx)[:part1])
  end

  test "part2 is loaded" do
    input = get_input!()

    assert Aletopelta.Day202412xx.Part2.execute(input) == String.to_integer(Application.get_env(:aletopelta, :day202412xx)[:part2])
  end
end
