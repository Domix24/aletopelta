defmodule AletopeltaTest.Year2018.Day08 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2018.Day08, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 45_210
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 22_793
  end
end
