defmodule AletopeltaTest.Year2022.Day11 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2022.Day11, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 54_752
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 13_606_755_504
  end
end
