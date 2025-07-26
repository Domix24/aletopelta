defmodule AletopeltaTest.Year2019.Day09 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2019.Day09, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 2_775_723_069
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 49_115
  end
end
