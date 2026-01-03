defmodule AletopeltaTest.Year2017.Day21 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2017.Day21, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 123
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 1_984_683
  end
end
