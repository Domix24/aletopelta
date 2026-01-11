defmodule AletopeltaTest.Year2016.Day20 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2016.Day20, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 31_053_880
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 117
  end
end
