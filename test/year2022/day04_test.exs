defmodule AletopeltaTest.Year2022.Day04 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2022.Day04, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 483
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 874
  end
end
