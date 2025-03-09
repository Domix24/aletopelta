defmodule AletopeltaTest.Year2024.Day17 do
  use ExUnit.Case
  alias Aletopelta.Year2024.Day17, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == "2,7,2,5,1,2,7,3,7"
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 247_839_002_892_474
  end
end
