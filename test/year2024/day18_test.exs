defmodule AletopeltaTest.Year2024.Day18 do
  use ExUnit.Case
  alias Aletopelta.Year2024.Day18, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 296
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == "28,44"
  end
end
