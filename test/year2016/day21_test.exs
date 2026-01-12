defmodule AletopeltaTest.Year2016.Day21 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2016.Day21, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == "dbfgaehc"
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == "aghfcdeb"
  end
end
