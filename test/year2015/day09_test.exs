defmodule AletopeltaTest.Year2015.Day09 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2015.Day09, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 141
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 736
  end
end
