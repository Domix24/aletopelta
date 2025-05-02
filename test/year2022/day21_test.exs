defmodule AletopeltaTest.Year2022.Day21 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2022.Day21, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 282_285_213_953_670
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 3_699_945_358_564
  end
end
