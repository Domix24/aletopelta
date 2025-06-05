defmodule AletopeltaTest.Year2021.Day07 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2021.Day07, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 336_131
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 92_676_646
  end
end
