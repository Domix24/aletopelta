defmodule AletopeltaTest.Year2015.Day15 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2015.Day15, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 21_367_368
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 1_766_400
  end
end
