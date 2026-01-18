defmodule AletopeltaTest.Year2015.Day20 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2015.Day20, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 665_280
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 705_600
  end
end
