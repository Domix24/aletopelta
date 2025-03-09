defmodule AletopeltaTest.Year2024.Day23 do
  use ExUnit.Case
  alias Aletopelta.Year2024.Day23, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 1154
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == "aj,ds,gg,id,im,jx,kq,nj,ql,qr,ua,yh,zn"
  end
end
