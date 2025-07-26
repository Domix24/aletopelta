defmodule AletopeltaTest.Year2019.Day10 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2019.Day10, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 253
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 815
  end
end
