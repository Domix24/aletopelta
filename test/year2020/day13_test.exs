defmodule AletopeltaTest.Year2020.Day13 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2020.Day13, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 6568
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 554_865_447_501_099
  end
end
