defmodule AletopeltaTest.Year2021.Day06 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2021.Day06, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 362_639
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 1_639_854_996_917
  end
end
