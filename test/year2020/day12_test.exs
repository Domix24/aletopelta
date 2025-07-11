defmodule AletopeltaTest.Year2020.Day12 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2020.Day12, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 1148
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 52_203
  end
end
