defmodule AletopeltaTest.Year2015.Day05 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2015.Day05, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 238
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 69
  end
end
