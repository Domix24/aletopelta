defmodule AletopeltaTest.Year2023.Day11 do
  use ExUnit.Case
  alias Aletopelta.Year2023.Day11, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 9_565_386
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 857_986_849_428
  end
end
