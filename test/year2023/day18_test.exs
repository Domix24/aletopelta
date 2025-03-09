defmodule AletopeltaTest.Year2023.Day18 do
  use ExUnit.Case
  alias Aletopelta.Year2023.Day18, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 34_329
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 42_617_947_302_920
  end
end
