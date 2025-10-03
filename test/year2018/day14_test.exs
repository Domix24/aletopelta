defmodule AletopeltaTest.Year2018.Day14 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2018.Day14, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 1_631_191_756
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 20_219_475
  end
end
