defmodule AletopeltaTest.Year2024.Day01 do
  use ExUnit.Case
  alias Aletopelta.Year2024.Day01, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 1_319_616
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 27_267_728
  end
end
