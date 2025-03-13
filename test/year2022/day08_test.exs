defmodule AletopeltaTest.Year2022.Day08 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2022.Day08, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 1705
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 371_200
  end
end
