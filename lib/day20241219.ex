defmodule Aletopelta.Day20241219 do
  defmodule Common do
  end

  defmodule Part1 do
    def execute(input \\ nil) do
      {towels, designs} = parse_input(input)

      Enum.count(designs, &is_valid?(&1, towels))
    end

    defp is_valid?("", _), do: true
    defp is_valid?(design, towels) do
      Enum.any?(towels, fn towel ->
        String.starts_with?(design, towel) and is_valid?(String.trim_leading(design, towel), towels)
      end)
    end

    defp parse_input(input) do
      towels = input |> Enum.at(0) |> String.split(", ")
      designs = input |> Enum.drop(2) |> Enum.reject(& &1 == "")

      {towels, designs}
    end
  end

  defmodule Part2 do
    def execute(_input \\ nil), do: 2
  end
end
