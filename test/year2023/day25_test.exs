defmodule AletopeltaTest.Year2023.Day25 do
  use ExUnit.Case
  alias Aletopelta.Year2023.Day25, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 601_344
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 0
  end
end
