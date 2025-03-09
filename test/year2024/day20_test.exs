defmodule AletopeltaTest.Year2024.Day20 do
  use ExUnit.Case
  alias Aletopelta.Year2024.Day20, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 1459
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 1_016_066
  end
end
