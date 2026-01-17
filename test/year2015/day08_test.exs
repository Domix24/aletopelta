defmodule AletopeltaTest.Year2015.Day08 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2015.Day08, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 1333
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 2046
  end
end
