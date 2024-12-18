defmodule AletopeltaTest.Day20241214 do
  use ExUnit.Case
  @filename "2024/day/14/input"

  defp get_input!(), do: AletopeltaTest.get_input!(@filename)
  |> String.split("\n")

  test "part1 is loaded" do
    input = get_input!()

    assert Aletopelta.Day20241214.Part1.execute(input) == String.to_integer(Application.get_env(:aletopelta, :day20241214)[:part1])
#    assert FromCopilot.Part1.execute(input) == String.to_integer(Application.get_env(:aletopelta, :day20241214)[:part1])
  end

  test "part2 is loaded" do
    input = get_input!()

    assert Aletopelta.Day20241214.Part2.execute(input) == String.to_integer(Application.get_env(:aletopelta, :day20241214)[:part2])
#    assert FromCopilot.Part2.execute(input) == String.to_integer(Application.get_env(:aletopelta, :day20241214)[:part2])
  end
end
