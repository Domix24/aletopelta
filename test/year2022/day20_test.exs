defmodule AletopeltaTest.Year2022.Day20 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2022.Day20, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 8764
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 535_648_840_980
  end
end
