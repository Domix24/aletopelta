defmodule AletopeltaTest.Year2020.Day18 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2020.Day18, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 209_335_026_987
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 33_331_817_392_479
  end
end
