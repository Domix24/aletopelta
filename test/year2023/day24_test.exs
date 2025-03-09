defmodule AletopeltaTest.Year2023.Day24 do
  use ExUnit.Case
  alias Aletopelta.Year2023.Day24, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 23_760
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 888_708_704_663_413
  end
end
