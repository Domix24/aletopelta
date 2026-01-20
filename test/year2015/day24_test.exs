defmodule AletopeltaTest.Year2015.Day24 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2015.Day24, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 10_723_906_903
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 74_850_409
  end
end
