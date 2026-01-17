defmodule AletopeltaTest.Year2015.Day11 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2015.Day11, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == "hepxxyzz"
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == "heqaabcc"
  end
end
