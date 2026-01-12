defmodule AletopeltaTest.Year2016.Day23 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2016.Day23, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 12_654
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 479_009_214
  end
end
