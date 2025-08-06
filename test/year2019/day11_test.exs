defmodule AletopeltaTest.Year2019.Day11 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2019.Day11, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 2539
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == [
             " XXXX X    XXXX XXX  X  X   XX XXX   XX    ",
             "    X X    X    X  X X X     X X  X X  X   ",
             "   X  X    XXX  XXX  XX      X X  X X  X   ",
             "  X   X    X    X  X X X     X XXX  XXXX   ",
             " X    X    X    X  X X X  X  X X X  X  X   ",
             " XXXX XXXX XXXX XXX  X  X  XX  X  X X  X   "
           ]
  end
end
