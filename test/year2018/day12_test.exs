defmodule AletopeltaTest.Year2018.Day12 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2018.Day12, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 3241
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 2_749_999_999_911
  end
end
