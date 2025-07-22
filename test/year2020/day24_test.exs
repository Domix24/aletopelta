defmodule AletopeltaTest.Year2020.Day24 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2020.Day24, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 382
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 3964
  end
end
