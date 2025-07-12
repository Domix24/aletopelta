defmodule AletopeltaTest.Year2020.Day16 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2020.Day16, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 27_802
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 279_139_880_759
  end
end
