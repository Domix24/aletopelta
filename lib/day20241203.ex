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
    def execute(input \\ nil) do
      parse_text(Enum.join(input, ""))      
    end
    
    defp parse_text(message) do
      pattern = ~r/(mul\(([0-9]{1,3}),([0-9]{1,3})\))|(do\(\))|(don't\(\))/i
      calculate(Regex.scan(pattern, message), :active)
    end
    
    def calculate([], _active), do: 0
    def calculate([message | rest], active) do
      # IO.inspect [message, active]
      case String.slice(Enum.at(message, 0), 0, 3) do
        "don" -> calculate(rest, :notactive)
        "do(" -> calculate(rest, :active)
        "mul" ->
          case active do
            :active -> String.to_integer(Enum.at(message, 2)) * String.to_integer(Enum.at(message, 3)) + calculate(rest, active)
            :notactive -> calculate(rest, active)
          end
        _ -> calculate(rest, active)
      end
    end
  end
end
