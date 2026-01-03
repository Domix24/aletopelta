defmodule AletopeltaTest.Year2017.Day22 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2017.Day22, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 5223
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 2_511_456
  end
end
