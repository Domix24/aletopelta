defmodule AletopeltaTest.Year2022.Day09 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2022.Day09, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 5960
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 2327
  end
end
