defmodule AletopeltaTest.Year2021.Day10 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2021.Day10, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 367_227
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 3_583_341_858
  end
end
