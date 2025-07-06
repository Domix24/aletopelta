defmodule AletopeltaTest.Year2020.Day01 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2020.Day01, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 786_811
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 199_068_980
  end
end
