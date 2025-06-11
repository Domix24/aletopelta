defmodule AletopeltaTest.Year2021.Day11 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2021.Day11, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 1741
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 440
  end
end
