defmodule AletopeltaTest.Year2017.Day02 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2017.Day02, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 44_216
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 320
  end
end
