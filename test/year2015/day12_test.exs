defmodule AletopeltaTest.Year2015.Day12 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2015.Day12, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 156_366
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 96_852
  end
end
