defmodule AletopeltaTest.Year2021.Day24 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2021.Day24, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 89_913_949_293_989
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 12_911_816_171_712
  end
end
