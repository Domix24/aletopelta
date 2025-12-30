defmodule AletopeltaTest.Year2017.Day12 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2017.Day12, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 141
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 171
  end
end
