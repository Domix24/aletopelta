defmodule AletopeltaTest.Year2017.Day13 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2017.Day13, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 1840
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 3_850_260
  end
end
