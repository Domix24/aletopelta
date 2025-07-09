defmodule AletopeltaTest.Year2020.Day05 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2020.Day05, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 801
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 597
  end
end
