defmodule AletopeltaTest.Year2017.Day24 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2017.Day24, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 1859
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 1799
  end
end
