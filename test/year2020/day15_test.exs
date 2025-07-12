defmodule AletopeltaTest.Year2020.Day15 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2020.Day15, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 260
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 950
  end
end
