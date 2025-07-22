defmodule AletopeltaTest.Year2020.Day21 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2020.Day21, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 1885
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == "fllssz,kgbzf,zcdcdf,pzmg,kpsdtv,fvvrc,dqbjj,qpxhfp"
  end
end
