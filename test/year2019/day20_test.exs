defmodule AletopeltaTest.Year2019.Day20 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2019.Day20, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1, trim: false) == 632
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2, trim: false) == 7162
  end
end
