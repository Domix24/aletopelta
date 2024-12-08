defmodule AletopeltaTest.Day20241205 do
  use ExUnit.Case
  @filename "2024/day/5/input"

  defp get_input!(), do: AletopeltaTest.get_input!(@filename)
  |> String.split("\n")

  test "part1 is loaded" do
    input = get_input!()

    assert Aletopelta.Day20241205.Part1.execute(input) == String.to_integer(Application.get_env(:aletopelta, :day20241205)[:part1])
  end

  test "part2 is loaded" do
    input = get_input!()

    assert Aletopelta.Day20241205.Part2.execute(input) == String.to_integer(Application.get_env(:aletopelta, :day20241205)[:part2])
  end
end
