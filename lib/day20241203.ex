defmodule Aletopelta.Day20241203 do 
  defmodule Part1 do
    def execute(input \\ nil) do
      input
      |> Enum.map(&parse_text/1)
      |> Enum.sum()
    end
    
    defp parse_text(message) do
      pattern = ~r/mul\(([0-9]{1,3}),([0-9]{1,3})\)/i
      Regex.scan(pattern, message) |> Enum.map(fn [_, first, second] -> String.to_integer(first) * String.to_integer(second) end) |> Enum.sum()
    end
  end

  defmodule Part2 do
    def execute(input \\ nil), do: 2
  end
end
