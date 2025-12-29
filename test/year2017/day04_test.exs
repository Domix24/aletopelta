defmodule AletopeltaTest.Year2017.Day04 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2017.Day04, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 386
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 208
  end
end
