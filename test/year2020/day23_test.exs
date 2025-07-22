defmodule AletopeltaTest.Year2020.Day23 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2020.Day23, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 98_752_463
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 2_000_455_861
  end
end
