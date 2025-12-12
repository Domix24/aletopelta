defmodule AletopeltaTest.Year2025.Day12 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2025.Day12, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 587
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 0
  end
end
