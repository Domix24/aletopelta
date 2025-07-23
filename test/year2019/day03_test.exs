defmodule AletopeltaTest.Year2019.Day03 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2019.Day03, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 2193
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 63_526
  end
end
