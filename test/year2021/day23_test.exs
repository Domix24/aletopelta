defmodule AletopeltaTest.Year2021.Day23 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2021.Day23, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 13_520
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 48_708
  end
end
