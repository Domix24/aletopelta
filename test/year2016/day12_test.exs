defmodule AletopeltaTest.Year2016.Day12 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2016.Day12, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 318_003
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 9_227_657
  end
end
