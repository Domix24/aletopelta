defmodule AletopeltaTest.Year2015.Day21 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2015.Day21, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 78
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 148
  end
end
