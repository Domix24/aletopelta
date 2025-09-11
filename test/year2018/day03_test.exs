defmodule AletopeltaTest.Year2018.Day03 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2018.Day03, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 115_304
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 275
  end
end
