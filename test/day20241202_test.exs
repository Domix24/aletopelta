defmodule AletopeltaTest.Day20241202 do
  use ExUnit.Case

  defmodule FileReader do
    def read_file_lines(file_path) do
      File.stream!(file_path) |> Enum.to_list() |> Enum.map(fn number_string -> String.split(number_string, ~r/\s+/) |> Enum.filter(&(String.length(&1)) > 0) end)
    end
  end

  @filename "test/input/20241202.txt"

  test "part1 is loaded" do
    input = FileReader.read_file_lines(@filename)

    assert Aletopelta.Day20241202.Part1.execute(input) == 1
  end

  test "part2 is loaded" do
    input = FileReader.read_file_lines(@filename)

    assert Aletopelta.Day20241202.Part2.execute(input) == 2
  end
end
