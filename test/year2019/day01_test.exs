defmodule AletopeltaTest.Year2019.Day01 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2019.Day01, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 3_087_896
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 4_628_989
  end
end
