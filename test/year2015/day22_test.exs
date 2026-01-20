defmodule AletopeltaTest.Year2015.Day22 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2015.Day22, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 1269
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 1309
  end
end
