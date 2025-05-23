defmodule AletopeltaTest.Year2021.Day03 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2021.Day03, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 3_958_484
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 1_613_181
  end
end
