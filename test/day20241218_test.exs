defmodule AletopeltaTest.Day20241218 do
  use ExUnit.Case
  @filename "2024/day/18/input"

  defp get_input!(), do: AletopeltaTest.get_input!(@filename)
  |> String.split("\n")

  test "part1 is loaded" do
    input = get_input!()

    assert Aletopelta.Day20241218.Part1.execute(input) == String.to_integer(Application.get_env(:aletopelta, :day20241218)[:part1])
  end

  test "part2 is loaded" do
    input = get_input!()

    assert Aletopelta.Day20241218.Part2.execute(input) == Application.get_env(:aletopelta, :day20241218)[:part2]
  end
end
