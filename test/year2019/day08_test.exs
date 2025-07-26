defmodule AletopeltaTest.Year2019.Day08 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2019.Day08, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 1820
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == [
             "1111010010100100110000110",
             "0001010010101001001000010",
             "0010010010110001000000010",
             "0100010010101001000000010",
             "1000010010101001001010010",
             "1111001100100100110001100"
           ]
  end
end
