defmodule AletopeltaTest.Year2022.Day16 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2022.Day16, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 1559
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 2191
  end
end
