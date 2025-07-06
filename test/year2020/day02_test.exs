defmodule AletopeltaTest.Year2020.Day02 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2020.Day02, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 439
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 584
  end
end
