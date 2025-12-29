defmodule AletopeltaTest.Year2017.Day09 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2017.Day09, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 21_037
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 9495
  end
end
