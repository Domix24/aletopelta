defmodule AletopeltaTest.Year2018.Day22 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2018.Day22, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 5400
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 1048
  end
end
