defmodule AletopeltaTest.Year2016.Day09 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2016.Day09, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 102_239
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 10_780_403_063
  end
end
