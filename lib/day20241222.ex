defmodule Aletopelta.Day20241222 do
  defmodule Common do
  end

  defmodule Part1 do
    def execute(input \\ nil) do
      input
      |> parse_input
      |> evolve(2000)
      |> Enum.sum
    end

    defp parse_input(input) do
      input
      |> Enum.reject(& &1 == "")
      |> Enum.map(&String.to_integer/1)
    end

    defp evolve(secrets, 0), do: secrets
    defp evolve(secrets, count) do
      secrets
      |> Enum.map(&evolve(&1))
      |> evolve(count - 1)
    end

    defp evolve(secret) do
      secret = prune(mix(secret, secret * 64))
      secret = prune(mix(secret, div(secret, 32)))
      prune(mix(secret, secret * 2048))
    end

    defp mix(secret, value) do
      Bitwise.bxor(secret, value)
    end

    defp prune(secret) do
      rem(secret, 16777216)
    end
  end

  defmodule Part2 do
    def execute(_input \\ nil), do: 2
  end
end
#|> dbg(pretty: true, limit: :infinity, charlists: :as_lists)
