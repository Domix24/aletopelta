defmodule AletopeltaTest.Year2021.Day16 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2021.Day16, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 947
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 660_797_830_937
  end
end
