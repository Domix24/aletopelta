defmodule AletopeltaTest.Year2019.Day13 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2019.Day13, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 309
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 15_410
  end
end
