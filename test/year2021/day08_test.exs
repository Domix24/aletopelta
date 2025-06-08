defmodule AletopeltaTest.Year2021.Day08 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2021.Day08, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 365
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 975_706
  end
end
