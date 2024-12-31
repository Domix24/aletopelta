defmodule AletopeltaTest.Day20241223 do
  use ExUnit.Case
  @filename "2024/day/23/input"

  defp get_input!(), do: AletopeltaTest.get_input!(@filename)
  |> String.split("\n")

  test "part1 is loaded" do
    input = get_input!()

    assert Aletopelta.Day20241223.Part1.execute(input) == String.to_integer(Application.get_env(:aletopelta, :day20241223)[:part1])
  end

  test "part2 is loaded" do
    input = get_input!()

    assert Aletopelta.Day20241223.Part2.execute(input) == Application.get_env(:aletopelta, :day20241223)[:part2]
  end
end
