defmodule AletopeltaTest.Year2019.Day24 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2019.Day24, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 28_778_811
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 2097
  end
end
