defmodule AletopeltaTest.Year2016.Day19 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2016.Day19, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 1_830_117
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 1_417_887
  end
end
