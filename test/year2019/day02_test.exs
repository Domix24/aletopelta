defmodule AletopeltaTest.Year2019.Day02 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2019.Day02, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 4_138_658
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 7264
  end
end
