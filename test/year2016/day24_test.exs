defmodule AletopeltaTest.Year2016.Day24 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2016.Day24, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 470
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 720
  end
end
