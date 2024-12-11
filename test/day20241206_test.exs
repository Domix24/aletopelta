defmodule AletopeltaTest.Day20241206 do
  use ExUnit.Case
  @filename "2024/day/6/input"

  defp get_input!(), do: AletopeltaTest.get_input!(@filename)
  |> String.split("\n")

  test "part1 is loaded" do
    input = get_input!()

    assert Aletopelta.Day20241206.Part1.execute(input) == String.to_integer(Application.get_env(:aletopelta, :day20241206)[:part1])
  end

  @tag timeout: :infinity
  test "part2 is loaded" do
    input = get_input!()

    assert Aletopelta.Day20241206.Part2.execute(input) == String.to_integer(Application.get_env(:aletopelta, :day20241206)[:part2])
  end
end
