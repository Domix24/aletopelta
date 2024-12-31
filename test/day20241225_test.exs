defmodule AletopeltaTest.Day20241225 do
  use ExUnit.Case
  @filename "2024/day/25/input"

  defp get_input!(), do: AletopeltaTest.get_input!(@filename)
  |> String.split("\n")

  test "part1 is loaded" do
    input = get_input!()

    assert Aletopelta.Day20241225.Part1.execute(input) == String.to_integer(Application.get_env(:aletopelta, :day20241225)[:part1])
  end

  test "part2 is loaded" do
    input = get_input!()

    assert Aletopelta.Day20241225.Part2.execute(input) == String.to_integer(Application.get_env(:aletopelta, :day20241225)[:part2])
  end
end
