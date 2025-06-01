defmodule AletopeltaTest.Year2021.Day04 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2021.Day04, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 54_275
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 0
  end
end
