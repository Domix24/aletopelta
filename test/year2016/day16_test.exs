defmodule AletopeltaTest.Year2016.Day16 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2016.Day16, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == "10010101010011101"
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == "01100111101101111"
  end
end
