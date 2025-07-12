defmodule AletopeltaTest.Year2020.Day14 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2020.Day14, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 14_722_016_054_794
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 3_618_217_244_644
  end
end
