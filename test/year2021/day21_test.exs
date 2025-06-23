defmodule AletopeltaTest.Year2021.Day21 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2021.Day21, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 734_820
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 193_170_338_541_590
  end
end
