defmodule AletopeltaTest.Year2024.Day14 do
  use ExUnit.Case
  alias Aletopelta.Year2024.Day14, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 231_221_760
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 6771
  end
end
