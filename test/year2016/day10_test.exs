defmodule AletopeltaTest.Year2016.Day10 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2016.Day10, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 113
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 12_803
  end
end
