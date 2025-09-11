defmodule AletopeltaTest.Year2018.Day04 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2018.Day04, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 39_584
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 55_053
  end
end
