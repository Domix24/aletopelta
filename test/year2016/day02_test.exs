defmodule AletopeltaTest.Year2016.Day02 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2016.Day02, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == "78293"
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == "AC8C8"
  end
end
