defmodule AletopeltaTest.Year2024.Day03 do
  use ExUnit.Case
  alias Aletopelta.Year2024.Day03, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 165_225_049
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 108_830_766
  end
end
