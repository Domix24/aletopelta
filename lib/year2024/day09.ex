defmodule Aletopelta.Year2024.Day09 do
  @moduledoc """
  Day 9 of Year 2024
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 9
    """
    defmodule FileSpace do
      @moduledoc """
      FileSpace
      """
      defstruct [:id, :size]
    end

    defmodule EmptySpace do
      @moduledoc """
      EmptySpace
      """
      defstruct [:size]
    end

    defprotocol SpaceType do
      @doc "Determines the type of space."
      def type(space)
    end

    defimpl SpaceType, for: FileSpace do
      def type(_), do: :file
    end

    defimpl SpaceType, for: EmptySpace do
      def type(_), do: :empty
    end

    def identify_spaces(graphemes, file_id \\ 0)
    def identify_spaces([], _file_id), do: []

    def identify_spaces([file_size, free_size | rest], file_id) do
      [%FileSpace{id: file_id, size: String.to_integer(file_size)}] ++
        [%EmptySpace{size: String.to_integer(free_size)}] ++
        identify_spaces(rest, file_id + 1)
    end

    def identify_spaces([file_size], file_id) do
      [%FileSpace{id: file_id, size: String.to_integer(file_size)}]
    end

    def calculate_checksum([block | _] = list), do: calculate_checksum(list, block.size, 0)

    def calculate_checksum([%EmptySpace{} = empty, block2 | rest], _, index),
      do: 0 + calculate_checksum([block2 | rest], block2.size, index + empty.size)

    def calculate_checksum([%EmptySpace{}], _, _), do: 0

    def calculate_checksum([_, block2 | rest], 0, index),
      do: calculate_checksum([block2 | rest], block2.size, index)

    def calculate_checksum([block | _] = list, block_size, index),
      do: block.id * index + calculate_checksum(list, block_size - 1, index + 1)
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 9
    """
    alias Common.EmptySpace
    alias Common.FileSpace
    alias Common.SpaceType

    def execute(input \\ nil) do
      input
      |> Enum.join()
      |> String.graphemes()
      |> Common.identify_spaces()
      |> compact_spaces
      |> Common.calculate_checksum()
    end

    defp compact_spaces(spaces) do
      compact_spaces(
        spaces,
        Enum.reduce(spaces, %{files: 0, empties: 0}, fn
          %FileSpace{}, acc -> Map.update!(acc, :files, &(&1 + 1))
          %EmptySpace{}, acc -> Map.update!(acc, :empties, &(&1 + 1))
        end)
      )
    end

    defp compact_spaces([], _counts), do: []

    defp compact_spaces([%EmptySpace{size: 0} | rest], %{files: files, empties: empties}),
      do: compact_spaces(rest, %{files: files, empties: empties - 1})

    defp compact_spaces([%EmptySpace{} = space | rest], %{files: 0, empties: empties}),
      do: [space | compact_spaces(rest, %{files: 0, empties: empties - 1})]

    defp compact_spaces([%FileSpace{} = space | rest], %{files: files, empties: empties}),
      do: [space | compact_spaces(rest, %{files: files - 1, empties: empties})]

    defp compact_spaces([%EmptySpace{} = empty_space | rest], _counts) do
      {last_file, updated_rest} = update_last_file(rest)
      new_empty_space = %EmptySpace{size: empty_space.size - last_file.size}

      {updated_file, updated_list} =
        cond do
          new_empty_space.size > 0 ->
            {last_file, [new_empty_space | updated_rest]}

          new_empty_space.size < 0 ->
            {%FileSpace{id: last_file.id, size: empty_space.size},
             update_list_size(rest, last_file.size - empty_space.size)}

          true ->
            {last_file, updated_rest}
        end

      new_list = [updated_file | updated_list]
      compact_spaces(new_list, count_spaces(new_list))
    end

    defp update_last_file(rest) do
      last_file_index = get_last_file_index(rest)
      {Enum.at(rest, last_file_index), List.delete_at(rest, last_file_index)}
    end

    defp update_list_size(rest, new_size) do
      last_file_index = get_last_file_index(rest)

      List.update_at(rest, last_file_index, fn %FileSpace{id: id} ->
        %FileSpace{id: id, size: new_size}
      end)
    end

    defp count_spaces(spaces) do
      Enum.reduce(spaces, %{files: 0, empties: 0}, fn
        %FileSpace{}, acc -> Map.update!(acc, :files, &(&1 + 1))
        %EmptySpace{}, acc -> Map.update!(acc, :empties, &(&1 + 1))
      end)
    end

    defp get_last_file_index(rest),
      do: length(rest) - 1 - Enum.find_index(Enum.reverse(rest), &(SpaceType.type(&1) == :file))
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 9
    """
    alias Common.EmptySpace
    alias Common.FileSpace

    def execute(input \\ nil) do
      input
      |> Enum.join()
      |> String.graphemes()
      |> Common.identify_spaces()
      |> compact_spaces
      |> Common.calculate_checksum()
    end

    defp compact_spaces([space]), do: [space]
    defp compact_spaces([%FileSpace{} = space | rest]), do: [space | compact_spaces(rest)]

    defp compact_spaces([%EmptySpace{} = space | rest] = list),
      do: compact_space_with_fitting(list, find_fitting_file(Enum.reverse(rest), space.size))

    defp compact_space_with_fitting([%EmptySpace{} = empty | rest], nil),
      do: [empty | compact_spaces(rest)]

    defp compact_space_with_fitting([%EmptySpace{} = empty | rest], %FileSpace{} = file)
         when file.size == empty.size do
      rest =
        rest
        |> List.replace_at(
          rest
          |> Enum.find_index(fn
            %FileSpace{id: id} -> id == file.id
            _ -> false
          end),
          %EmptySpace{size: file.size}
        )

      [file | compact_spaces(rest)]
    end

    defp compact_space_with_fitting([%EmptySpace{} = empty | rest], %FileSpace{} = file) do
      rest =
        rest
        |> List.replace_at(
          rest
          |> Enum.find_index(fn
            %FileSpace{id: id} -> id == file.id
            _ -> false
          end),
          %EmptySpace{size: file.size}
        )

      empty = %EmptySpace{size: empty.size - file.size}

      [file | compact_spaces([empty | rest])]
    end

    defp find_fitting_file(_, 0), do: nil
    defp find_fitting_file([%EmptySpace{} | rest], size), do: find_fitting_file(rest, size)
    defp find_fitting_file([], _), do: nil

    defp find_fitting_file([%FileSpace{} = space | rest], size) when space.size > size,
      do: find_fitting_file(rest, size)

    defp find_fitting_file([%FileSpace{} = space | _], _), do: space
  end
end
