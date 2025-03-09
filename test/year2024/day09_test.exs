defmodule AletopeltaTest.Year2024.Day09 do
  use ExUnit.Case
  alias Aletopelta.Year2024.Day09, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 6_398_608_069_280
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 6_427_437_134_372
  end
end
