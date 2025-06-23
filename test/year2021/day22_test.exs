defmodule AletopeltaTest.Year2021.Day22 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2021.Day22, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 568_000
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 1_177_411_289_280_259
  end
end
