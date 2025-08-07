defmodule AletopeltaTest.Year2019.Day12 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2019.Day12, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 12_490
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 392_733_896_255_168
  end
end
