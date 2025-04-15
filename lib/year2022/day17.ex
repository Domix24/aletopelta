defmodule Aletopelta.Year2022.Day17 do
  @moduledoc """
  Day 17 of Year 2022
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 17
    """
    @spec parse_input(list(binary())) :: any()
    def parse_input(input) do
      input
      |> Stream.map(fn line ->
        line
        |> String.graphemes()
        |> Enum.with_index(fn
          ">", index -> {0 + 1, index}
          "<", index -> {0 - 1, index}
        end)
      end)
      |> Enum.at(0)
    end

    @piece_count 5
    @piece_group 47
    @spec get_piece(0, integer()) :: list()
    def get_piece(0, y) do
      [{2, y + 4}, {3, y + 4}, {4, y + 4}, {5, y + 4}]
    end

    @spec get_piece(1, integer()) :: list()
    def get_piece(1, y) do
      [{3, y + 4}, {2, y + 5}, {3, y + 5}, {4, y + 5}, {3, y + 6}]
    end

    @spec get_piece(2, integer()) :: list()
    def get_piece(2, y) do
      [{2, y + 4}, {3, y + 4}, {4, y + 4}, {4, y + 5}, {4, y + 6}]
    end

    @spec get_piece(3, integer()) :: list()
    def get_piece(3, y) do
      [{2, y + 4}, {2, y + 5}, {2, y + 6}, {2, y + 7}]
    end

    @spec get_piece(4, integer()) :: list()
    def get_piece(4, y) do
      [{2, y + 4}, {3, y + 4}, {2, y + 5}, {3, y + 5}]
    end

    @spec drop_pieces(any(), integer()) :: integer()
    def drop_pieces(directions, nb_pieces) do
      drop_piece({directions, directions}, {0, nb_pieces}, {%{}, 0}, {%{}, 0})
    end

    defp drop_piece(_, {pieces_count, pieces_count}, {_, height}, {_, cache_height}),
      do: height + cache_height

    defp drop_piece(
           {current_directions, complete_directions},
           {pieces_count, nb_pieces},
           {chamber, chamber_height},
           {cache, cache_add}
         ) do
      piece_index = rem(pieces_count, @piece_count)

      {new_chamber, new_height, new_directions} =
        piece_index
        |> get_piece(chamber_height)
        |> move_piece(current_directions, complete_directions, chamber, chamber_height)

      new_count = pieces_count + 1

      {new_cache, new_add, update_count} =
        manage_cache(
          {new_chamber, new_height},
          {cache, cache_add},
          {new_count, nb_pieces, piece_index}
        )

      drop_piece(
        {new_directions, complete_directions},
        {update_count, nb_pieces},
        {new_chamber, new_height},
        {new_cache, new_add}
      )
    end

    defp manage_cache({chamber, height}, {cache, cache_add}, {count, nb_pieces, piece_index})
         when height > @piece_group and cache_add < 1 do
      cache_key = get_key({chamber, height})

      {new_count, new_add} =
        cache
        |> Map.fetch(cache_key)
        |> get_cache({count, height, nb_pieces, cache_add})

      cache_value = {new_count, height, piece_index}
      new_cache = Map.put(cache, cache_key, cache_value)

      {new_cache, new_add, new_count}
    end

    defp manage_cache(_, {cache, cache_add}, {count, _, _}) do
      {cache, cache_add, count}
    end

    defp get_key({chamber, height}) do
      Enum.join(
        for y <- (height - @piece_group + 1)..height, x <- 0..6 do
          if Enum.member?(Map.fetch!(chamber, y), x) do
            "1"
          else
            "0"
          end
        end
      )
    end

    defp get_cache({:ok, {cache_count, cache_height, _}}, {count, height, nb_pieces, _}) do
      cycle_count = count - cache_count
      cycle_height = height - cache_height

      cycle_multiplier = div(nb_pieces - count, cycle_count)

      {count + cycle_count * cycle_multiplier, cycle_height * cycle_multiplier}
    end

    defp get_cache(:error, {count, _, _, add}), do: {count, add}

    defp move_piece(piece, current_directions, complete_directions, chamber, height) do
      {state, new_piece, new_directions} =
        piece
        |> move_horizontal(current_directions, complete_directions, chamber)
        |> move_down()

      if state == :stop do
        new_chamber =
          Enum.reduce(new_piece, chamber, fn {x, y}, acc ->
            Map.update(acc, y, [x], fn list -> [x | list] end)
          end)

        new_height =
          new_piece
          |> Enum.max_by(fn {_, y} -> y end)
          |> elem(1)
          |> max(height)

        {new_chamber, new_height, new_directions}
      else
        move_piece(new_piece, new_directions, complete_directions, chamber, height)
      end
    end

    defp move_horizontal(piece, [], directions, chamber),
      do: move_horizontal(piece, directions, directions, chamber)

    defp move_horizontal(piece, [{delta, _} | other_directions], _, chamber) do
      new_piece = Enum.map(piece, fn {x, y} -> {x + delta, y} end)

      collides? =
        Enum.any?(new_piece, fn {x, _} = pos ->
          if x in 0..6 do
            collides?(pos, chamber)
          else
            true
          end
        end)

      if collides? do
        {piece, other_directions, chamber}
      else
        {new_piece, other_directions, chamber}
      end
    end

    defp collides?({x, y}, chamber) do
      case Map.fetch(chamber, y) do
        :error -> false
        {:ok, list} -> Enum.member?(list, x)
      end
    end

    defp move_down({piece, directions, chamber}) do
      new_piece = Enum.map(piece, fn {x, y} -> {x, y - 1} end)

      collides? =
        Enum.any?(new_piece, fn {_, y} = pos ->
          if y < 1 do
            true
          else
            collides?(pos, chamber)
          end
        end)

      if collides? do
        {:stop, piece, directions}
      else
        {:cont, new_piece, directions}
      end
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 17
    """
    @spec execute(any()) :: integer()
    def execute(input) do
      input
      |> Common.parse_input()
      |> Common.drop_pieces(2022)
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 17
    """
    @spec execute(any()) :: integer()
    def execute(input) do
      input
      |> Common.parse_input()
      |> Common.drop_pieces(1_000_000_000_000)
    end
  end
end
