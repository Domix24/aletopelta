defmodule AletopeltaTest.Year2016.Day14 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2016.Day14, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 15_168
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 20_864
  end
end
