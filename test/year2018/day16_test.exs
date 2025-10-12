defmodule AletopeltaTest.Year2018.Day16 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2018.Day16, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 646
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 681
  end
end
