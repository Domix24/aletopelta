defmodule AletopeltaTest.Year2022.Day24 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2022.Day24, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 262
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 785
  end
end
