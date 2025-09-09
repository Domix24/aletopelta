defmodule AletopeltaTest.Year2019.Day19 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2019.Day19, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 154
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 9_791_328
  end
end
