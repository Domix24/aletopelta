defmodule AletopeltaTest.Year2015.Day04 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2015.Day04, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 254_575
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 1_038_736
  end
end
