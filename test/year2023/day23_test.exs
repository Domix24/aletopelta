defmodule AletopeltaTest.Year2023.Day23 do
  use ExUnit.Case
  alias Aletopelta.Year2023.Day23, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 2034
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 6302
  end
end
