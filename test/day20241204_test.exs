defmodule AletopeltaTest.Day20241204 do
  use ExUnit.Case
  
  @filename "2024/day/4/input"

  defp get_input() do
    result = elem(Tesla.get(AletopeltaTest.create_client(), @filename), 1).body

    result |> String.split("\n")
  end

  test "part1 is loaded" do
    input = get_input()

    assert Aletopelta.Day20241204.Part1.execute(input) == String.to_integer(Application.get_env(:aletopelta, :day20241204)[:part1])
  end

  test "part2 is loaded" do
    input = get_input()

    assert Aletopelta.Day20241204.Part2.execute(input) == String.to_integer(Application.get_env(:aletopelta, :day20241204)[:part2])
  end
end
