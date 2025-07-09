defmodule AletopeltaTest.Year2020.Day10 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2020.Day10, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 2376
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 129_586_085_429_248
  end
end
