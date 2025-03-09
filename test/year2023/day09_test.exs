defmodule AletopeltaTest.Year2023.Day09 do
  use ExUnit.Case
  alias Aletopelta.Year2023.Day09, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 1_819_125_966
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 1140
  end
end
