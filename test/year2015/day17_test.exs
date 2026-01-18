defmodule AletopeltaTest.Year2015.Day17 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2015.Day17, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 4372
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 4
  end
end
