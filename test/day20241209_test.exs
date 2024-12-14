defmodule AletopeltaTest.Day20241209 do
  use ExUnit.Case
  @filename "2024/day/9/input"

  defp get_input!(), do: AletopeltaTest.get_input!(@filename)
  |> String.split("\n")

  test "part1 is loaded" do
    input = get_input!()

    assert Aletopelta.Day20241209.Part1.execute(input) == String.to_integer(Application.get_env(:aletopelta, :day20241209)[:part1])
  end

  test "part2 is loaded" do
    input = get_input!()

    assert Aletopelta.Day20241209.Part2.execute(input) == String.to_integer(Application.get_env(:aletopelta, :day20241209)[:part2])
  end
end
