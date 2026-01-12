defmodule AletopeltaTest.Year2016.Day22 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2016.Day22, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 993
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 202
  end
end
