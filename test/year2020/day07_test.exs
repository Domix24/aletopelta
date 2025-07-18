defmodule AletopeltaTest.Year2020.Day07 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2020.Day07, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 172
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 39_645
  end
end
