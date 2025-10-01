defmodule AletopeltaTest.Year2018.Day13 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2018.Day13, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1, trim: false) == "14,42"
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2, trim: false) == "8,7"
  end
end
