defmodule AletopeltaTest.Year2021.Day14 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2021.Day14, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 3697
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 4_371_307_836_157
  end
end
