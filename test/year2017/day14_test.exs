defmodule AletopeltaTest.Year2017.Day14 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2017.Day14, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 8214
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 1093
  end
end
