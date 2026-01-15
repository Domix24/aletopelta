defmodule AletopeltaTest.Year2015.Day06 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2015.Day06, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 400_410
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 15_343_601
  end
end
