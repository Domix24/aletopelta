defmodule AletopeltaTest.Year2023.Day14 do
  use ExUnit.Case
  alias Aletopelta.Year2023.Day14, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 110_090
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 95_254
  end
end
