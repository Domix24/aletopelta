defmodule AletopeltaTest.Year2023.Day19 do
  use ExUnit.Case
  alias Aletopelta.Year2023.Day19, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 350_678
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 124_831_893_423_809
  end
end
