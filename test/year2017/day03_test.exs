defmodule AletopeltaTest.Year2017.Day03 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2017.Day03, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 475
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 279_138
  end
end
