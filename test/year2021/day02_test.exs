defmodule AletopeltaTest.Year2021.Day02 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2021.Day02, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 1_480_518
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 1_282_809_906
  end
end
