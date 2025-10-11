defmodule AletopeltaTest.Year2018.Day15 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2018.Day15, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 191_216
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 48_050
  end
end
