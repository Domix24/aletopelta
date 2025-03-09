defmodule AletopeltaTest.Year2024.Day10 do
  use ExUnit.Case
  alias Aletopelta.Year2024.Day10, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 482
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 1094
  end
end
