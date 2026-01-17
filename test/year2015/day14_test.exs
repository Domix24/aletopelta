defmodule AletopeltaTest.Year2015.Day14 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2015.Day14, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 2640
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 1102
  end
end
