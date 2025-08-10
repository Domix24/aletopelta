defmodule AletopeltaTest.Year2019.Day17 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2019.Day17, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 6448
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 914_900
  end
end
