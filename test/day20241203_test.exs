defmodule AletopeltaTest.Day20241203 do
  use ExUnit.Case

  defmodule FileReader do
    def read_file_lines(file_path) do
      File.stream!(file_path) |> Enum.to_list() |> Enum.map(&String.trim_trailing(&1, "\n"))
    end
  end

  @filename "test/input/20241203.txt"

  test "part1 is loaded" do
    input = FileReader.read_file_lines(@filename)

    assert Aletopelta.Day20241203.Part1.execute(input) == 165225049
  end

  test "part2 is loaded" do
    input = FileReader.read_file_lines(@filename)

    assert Aletopelta.Day20241203.Part2.execute(input) == 108830766 
  end
end
