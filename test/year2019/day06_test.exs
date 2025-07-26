defmodule AletopeltaTest.Year2019.Day06 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2019.Day06, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 300_598
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 520
  end
end
