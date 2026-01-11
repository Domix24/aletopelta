defmodule AletopeltaTest.Year2016.Day17 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2016.Day17, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == "RLRDRDUDDR"
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 420
  end
end
