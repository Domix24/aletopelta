defmodule AletopeltaTest.Day20241216 do
  use ExUnit.Case
  @filename "2024/day/16/input"

  defp get_input!(), do: AletopeltaTest.get_input!(@filename)
  |> String.split("\n")

  test "part1 is loaded" do
    input = get_input!()

    assert Aletopelta.Day20241216.Part1.execute(input) == String.to_integer(Application.get_env(:aletopelta, :day20241216)[:part1])
  end

  test "part2 is loaded" do
    input = get_input!()

    assert Aletopelta.Day20241216.Part2.execute(input) == String.to_integer(Application.get_env(:aletopelta, :day20241216)[:part2])
  end
end
