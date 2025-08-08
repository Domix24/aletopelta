defmodule AletopeltaTest.Year2019.Day15 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2019.Day15, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 336
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 360
  end
end
