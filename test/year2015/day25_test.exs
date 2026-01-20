defmodule AletopeltaTest.Year2015.Day25 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2015.Day25, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 9_132_360
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 0
  end
end
