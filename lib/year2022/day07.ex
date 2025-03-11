defmodule Aletopelta.Year2022.Day07 do
  @moduledoc """
  Day 7 of Year 2022
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 7
    """
    @spec parse_input(any()) :: [integer()]
    def parse_input(input) do
      input
      |> Enum.reduce({%{}, "", 0}, fn line, {map, last, depth} ->
        line
        |> String.split()
        |> handle_line(map, last, depth)
      end)
      |> elem(0)
      |> Enum.sort(:desc)
      |> accumulate_sizes()
    end

    defp handle_line(["$", "cd", "/"], dir_map, _, depth) do
      new_map = initialize_root(dir_map, depth)

      {new_map, "/", depth + 1}
    end

    defp handle_line(["$", "cd", ".."], dir_map, current_directory, depth) do
      new_current = get_parent(current_directory)

      {dir_map, new_current, depth - 1}
    end

    defp handle_line(["$", "cd", directory], dir_map, current_directory, depth) do
      {new_map, new_current} = enter_directory(dir_map, current_directory, depth, directory)

      {new_map, new_current, depth + 1}
    end

    defp handle_line(["$", "ls"], dir_map, current_directory, depth) do
      {dir_map, current_directory, depth}
    end

    defp handle_line(["dir", _], dir_map, current_directory, depth) do
      {dir_map, current_directory, depth}
    end

    defp handle_line([file_size, _], dir_map, current_directory, depth) do
      new_map = add_file(dir_map, current_directory, depth, file_size)

      {new_map, current_directory, depth}
    end

    defp initialize_root(dir_map, depth) do
      Map.put_new(dir_map, depth, %{"/" => 0})
    end

    defp get_parent(<<"/", rest::binary>>) do
      new_rest =
        rest
        |> String.split("/")
        |> Enum.drop(-1)
        |> Enum.join("/")

      "/" <> new_rest
    end

    defp enter_directory(dir_map, current_directory, depth, directory) do
      separator = if current_directory == "/", do: "", else: "/"
      new_current = current_directory <> separator <> directory

      new_map =
        Map.update(dir_map, depth, %{new_current => 0}, fn existing ->
          Map.put(existing, new_current, 0)
        end)

      {new_map, new_current}
    end

    defp add_file(dir_map, current_directory, depth, file_size) do
      conevrted_size = String.to_integer(file_size)
      parent_level = depth - 1

      updated_parent =
        dir_map
        |> Map.fetch!(parent_level)
        |> Map.update!(current_directory, &(&1 + conevrted_size))

      Map.put(dir_map, parent_level, updated_parent)
    end

    defp accumulate_sizes([{0, [{"/", size}]}]) do
      [size]
    end

    defp accumulate_sizes([{depth, directories} | remaining]) do
      parent_sizes =
        directories
        |> sum_parents()
        |> update_parents(depth, remaining)

      updated_remaining =
        Enum.map(remaining, fn {other_depth, value} ->
          if other_depth == depth - 1 do
            {other_depth, parent_sizes}
          else
            {other_depth, value}
          end
        end)

      directory_sizes = Enum.map(directories, &elem(&1, 1))
      directory_sizes ++ accumulate_sizes(updated_remaining)
    end

    defp sum_parents(directories) do
      directories
      |> Enum.group_by(
        fn {"/" <> directory, _} ->
          parent =
            directory
            |> String.split("/")
            |> Enum.drop(-1)
            |> Enum.join("/")

          "/" <> parent
        end,
        fn {_, size} -> size end
      )
      |> Map.new(fn {parent, sizes} ->
        {parent, Enum.sum(sizes)}
      end)
    end

    defp update_parents(parents, depth, remaining) do
      remaining
      |> Enum.find_value(fn {other_depth, value} ->
        if other_depth == depth - 1 do
          value
        end
      end)
      |> Enum.map(fn {parent, size} ->
        {parent, size + Map.get(parents, parent, 0)}
      end)
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 7
    """
    @spec execute(any()) :: integer()
    def execute(input) do
      input
      |> Common.parse_input()
      |> Enum.filter(&(&1 < 100_000))
      |> Enum.sum()
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 7
    """
    @spec execute(any()) :: integer()
    def execute(input) do
      directory_sizes = Common.parse_input(input)
      unused_space = 70_000_000 - Enum.max(directory_sizes)

      directory_sizes
      |> Enum.filter(fn size -> unused_space + size > 30_000_000 end)
      |> Enum.min()
    end
  end
end
