defmodule AletopeltaTest.Year2023.Day16 do
  use ExUnit.Case
  alias Aletopelta.Year2023.Day16, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 7870
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 8143
  end
end
