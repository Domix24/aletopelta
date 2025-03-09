defmodule AletopeltaTest.Year2024.Day13 do
  use ExUnit.Case
  alias Aletopelta.Year2024.Day13, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 35_729
  end

  test "part2 is loaded" do
    assert Belodon.solve(Solution, :part2) == 88_584_689_879_723
  end
end
