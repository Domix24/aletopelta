defmodule AletopeltaTest.Year2023.Day05 do
  use ExUnit.Case
  alias Aletopelta.Year2023.Day05, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 650_599_855
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 1_240_035
  end
end
