defmodule AletopeltaTest.Year2023.Day07 do
  use ExUnit.Case
  alias Aletopelta.Year2023.Day07, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 250_232_501
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 249_138_943
  end
end
