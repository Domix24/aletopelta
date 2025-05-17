defmodule AletopeltaTest.Year2022.Day22 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2022.Day22, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 75_254
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 108_311
  end
end
