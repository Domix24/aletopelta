defmodule AletopeltaTest.Year2021.Day20 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2021.Day20, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 5419
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 17_325
  end
end
