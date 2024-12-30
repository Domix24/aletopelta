defmodule Aletopelta.Day20241222 do
  defmodule Common do
    def parse_input(input) do
      input
      |> Enum.reject(& &1 == "")
      |> Enum.map(&String.to_integer/1)
    end

    def mix(secret, value) do
      Bitwise.bxor(secret, value)
    end

    def prune(secret) do
      rem(secret, 16777216)
    end

    def evolve(secret) do
      secret = Common.prune(Common.mix(secret, secret * 64))
      secret = Common.prune(Common.mix(secret, div(secret, 32)))
      Common.prune(Common.mix(secret, secret * 2048))
    end
  end

  defmodule Part1 do
    def execute(input \\ nil) do
      input
      |> Common.parse_input
      |> evolve(2000)
      |> Enum.sum
    end

    defp evolve(secrets, 0), do: secrets
    defp evolve(secrets, count) do
      secrets
      |> Enum.map(&Common.evolve(&1))
      |> evolve(count - 1)
    end
  end

  defmodule Part2 do
    def execute(input \\ nil) do
      input
      |> Common.parse_input
      |> do_evolve(%{})
      |> find_highest
    end

    defp find_highest(map) do
      Enum.max_by(map, fn {_, value} -> value end)
      |> elem(1)
    end

    defp do_evolve([], map), do: map
    defp do_evolve([code | others], map) do
      result = evolve(code, 2000)
      |> build_seqmap(%{})
      |> Map.to_list
      |> update_map(map)

      do_evolve(others, result)
    end

    defp update_map([], map), do: map
    defp update_map([{sequence, digit} | others], map) do
      update_map(others, Map.update(map, sequence, digit, & &1 + digit))
    end

    defp build_seqmap([_, _, _], map), do: map
    defp build_seqmap([{_, diff1}, {_, diff2} = e2, {_, diff3} = e3, {digit, diff4} = e4 | others], map) do
      build_seqmap([e2, e3, e4 | others], Map.put_new(map, "#{diff1},#{diff2},#{diff3},#{diff4}", digit))
    end

    defp evolve(secret, 1) do
      {_, digit, change} = evolve(secret)
      [{digit, change}]
    end

    defp evolve(secret, count) do
      {secret, digit, change} = evolve(secret)
      [{digit, change} | evolve(secret, count - 1)]
    end

    defp evolve(secret) do
      last_before = rem(secret, 10)
      secret = Common.evolve(secret)
      last_after = rem(secret, 10)
      change = last_after - last_before
      {secret, last_after, change}
    end
  end
end
