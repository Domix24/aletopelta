defmodule AletopeltaTest.Year2024.Day12 do
  use ExUnit.Case
  alias Aletopelta.Year2024.Day12, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 1_533_024
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 910_066
  end
end
