defmodule AletopeltaTest.Year2016.Day03 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2016.Day03, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 917
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 1649
  end
end
