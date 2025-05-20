defmodule Aletopelta.Year2022.Day24 do
  @moduledoc """
  Day 24 of Year 2022
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 24
    """
    @spec parse_input([binary()]) :: {{Range.t(), Range.t()}, {tuple(), tuple()}, map()}
    def parse_input(input) do
      {x_range, position, winds, empty, y} =
        Enum.reduce(input, {nil, nil, Map.new(), nil, 0}, fn line, {_, position, winds, _, y} ->
          {x, new_position, new_winds, new_empty} =
            line
            |> String.graphemes()
            |> Enum.reduce({0, position, winds, nil}, fn cell, acc ->
              parse_line(cell, acc, y)
            end)

          {1..(x - 2)//1, new_position, new_winds, new_empty, y + 1}
        end)

      {{x_range, 1..(y - 2)//1}, {position, empty}, winds}
    end

    defp parse_line(".", {x, nil, winds, nil}, y) do
      {x + 1, {x, y}, winds, nil}
    end

    defp parse_line(".", {x, position, winds, nil}, y) do
      {x + 1, position, winds, {x, y}}
    end

    defp parse_line(sign, {x, position, winds, empty}, _) when sign in [".", "#"] do
      {x + 1, position, winds, empty}
    end

    defp parse_line(wind, {x, position, winds, empty}, y) do
      new_winds = Map.put(winds, {x, y}, [wind])
      {x + 1, position, new_winds, empty}
    end

    defp move_winds(winds, ranges) do
      Enum.reduce(winds, Map.new(), fn {position, directions}, winds ->
        Enum.reduce(directions, winds, fn direction, winds ->
          new_position = move_wind(position, direction, ranges)
          Map.update(winds, new_position, [direction], &[direction | &1])
        end)
      end)
    end

    defp move_wind({x, y}, ">", {first..last//1, _}) when x == last, do: {first, y}
    defp move_wind({x, y}, ">", _), do: {x + 1, y}
    defp move_wind({x, y}, "<", {first..last//1, _}) when x == first, do: {last, y}
    defp move_wind({x, y}, "<", _), do: {x - 1, y}
    defp move_wind({x, y}, "v", {_, first..last//1}) when y == last, do: {x, first}
    defp move_wind({x, y}, "v", _), do: {x, y + 1}
    defp move_wind({x, y}, "^", {_, first..last//1}) when y == first, do: {x, last}
    defp move_wind({x, y}, "^", _), do: {x, y - 1}

    @spec do_loop(integer(), MapSet.t(), {tuple(), tuple()}, {Range.t(), Range.t()}, map(), map()) ::
            {integer(), map(), map()}
    def do_loop(
          minute,
          positions,
          {_, end_position} = initial_positions,
          ranges,
          winds,
          wind_cache
        ) do
      {new_winds, new_cache} = get_pattern(minute, winds, ranges, wind_cache)

      new_positions =
        positions
        |> Enum.flat_map(fn position ->
          get_positions(position, ranges, initial_positions, new_winds)
        end)
        |> MapSet.new()

      if MapSet.member?(new_positions, end_position) do
        {minute, new_winds, new_cache}
      else
        do_loop(minute + 1, new_positions, initial_positions, ranges, new_winds, new_cache)
      end
    end

    defp get_positions({x, y}, ranges, positions, winds) do
      [{0, -1}, {-1, 0}, {0, 0}, {1, 0}, {0, 1}]
      |> Enum.map(fn {dx, dy} -> {x + dx, y + dy} end)
      |> Enum.reject(fn position ->
        valid_position?(position, ranges, positions, winds)
      end)
    end

    defp get_pattern(minute, winds, {x_range, y_range} = ranges, cache) do
      [x_period, y_period] = Enum.map([x_range, y_range], &Range.size/1)
      cycle_minute = rem(minute, lcm(x_period, y_period))

      case {Map.get(cache, cycle_minute), cycle_minute} do
        {nil, 1} ->
          compute_pattern(winds, ranges, cache, 1, cycle_minute)

        {nil, _} ->
          {temp_winds, temp_cache} = get_pattern(minute - 1, winds, ranges, cache)
          compute_pattern(temp_winds, ranges, temp_cache, cycle_minute, cycle_minute)

        {new_winds, _} ->
          {new_winds, cache}
      end
    end

    defp lcm(a, b), do: div(a * b, gcd(a, b))

    defp gcd(a, 0), do: a
    defp gcd(a, b), do: gcd(b, rem(a, b))

    defp compute_pattern(winds, _, cache, current, target) when current > target,
      do: {winds, cache}

    defp compute_pattern(winds, ranges, cache, current, target) do
      new_winds = move_winds(winds, ranges)
      new_cache = Map.put(cache, current, new_winds)
      compute_pattern(new_winds, ranges, new_cache, current + 1, target)
    end

    defp valid_position?(
           {x, y} = position,
           {x_range, y_range},
           {start_position, end_position},
           winds
         ) do
      if x in x_range and y in y_range do
        Map.has_key?(winds, position)
      else
        not (position == end_position or position == start_position)
      end
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 24
    """
    @spec execute([binary()]) :: number()
    def execute(input) do
      input
      |> Common.parse_input()
      |> prepare_loop()
    end

    defp prepare_loop({ranges, {start_position, end_position}, winds}) do
      wind_cache = Map.new()

      {minute, _, _} =
        Common.do_loop(
          1,
          MapSet.new([start_position]),
          {start_position, end_position},
          ranges,
          winds,
          wind_cache
        )

      minute
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 24
    """
    @spec execute([binary()]) :: number()
    def execute(input) do
      input
      |> Common.parse_input()
      |> prepare_loop()
    end

    defp prepare_loop({ranges, {start_position, end_position}, winds}) do
      cache = Map.new()

      {minutes0, winds0, cache0} =
        Common.do_loop(
          1,
          MapSet.new([start_position]),
          {start_position, end_position},
          ranges,
          winds,
          cache
        )

      {minutes1, winds1, cache1} =
        Common.do_loop(
          minutes0 + 1,
          MapSet.new([end_position]),
          {end_position, start_position},
          ranges,
          winds0,
          cache0
        )

      {minutes2, _, _} =
        Common.do_loop(
          minutes1 + 1,
          MapSet.new([start_position]),
          {start_position, end_position},
          ranges,
          winds1,
          cache1
        )

      minutes2
    end
  end
end
