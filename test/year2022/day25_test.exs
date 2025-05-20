defmodule AletopeltaTest.Year2022.Day25 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2022.Day25, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == "2-0==21--=0==2201==2"
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 0
  end
end
