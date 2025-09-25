defmodule AletopeltaTest.Year2018.Day10 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2018.Day10, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == [
             ".XXXX...XXXXXX..X....X..XXXXX...X....X....XX....XXXXX...X....X",
             "X....X.......X..X...X...X....X..XX...X...X..X...X....X..XX...X",
             "X............X..X..X....X....X..XX...X..X....X..X....X..XX...X",
             "X...........X...X.X.....X....X..X.X..X..X....X..X....X..X.X..X",
             "X..........X....XX......XXXXX...X.X..X..X....X..XXXXX...X.X..X",
             "X.........X.....XX......X.......X..X.X..XXXXXX..X..X....X..X.X",
             "X........X......X.X.....X.......X..X.X..X....X..X...X...X..X.X",
             "X.......X.......X..X....X.......X...XX..X....X..X...X...X...XX",
             "X....X..X.......X...X...X.......X...XX..X....X..X....X..X...XX",
             ".XXXX...XXXXXX..X....X..X.......X....X..X....X..X....X..X....X"
           ]
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 10_003
  end
end
