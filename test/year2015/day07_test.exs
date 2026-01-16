defmodule AletopeltaTest.Year2015.Day07 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2015.Day07, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 46_065
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 14_134
  end
end
