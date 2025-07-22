defmodule AletopeltaTest.Year2020.Day22 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2020.Day22, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 31_754
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 35_436
  end
end
