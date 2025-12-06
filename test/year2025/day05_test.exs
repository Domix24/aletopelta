defmodule AletopeltaTest.Year2025.Day05 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2025.Day05, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 758
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 343_143_696_885_053
  end
end
