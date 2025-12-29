defmodule AletopeltaTest.Year2017.Day05 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2017.Day05, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 351_282
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 24_568_703
  end
end
