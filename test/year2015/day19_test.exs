defmodule AletopeltaTest.Year2015.Day19 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2015.Day19, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 518
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 200
  end
end
