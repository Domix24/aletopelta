defmodule AletopeltaTest.Year2019.Day07 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2019.Day07, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 262_086
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 5_371_621
  end
end
