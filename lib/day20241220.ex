defmodule Aletopelta.Day20241220 do
  defmodule Common do
  end

  defmodule Part1 do
    def execute(input \\ nil, saves \\ 100) do
      {grid, %{start: start, finish: finish}} = parse_input(input)
      Map.new(grid, fn x -> {x, true} end)
      |> follow_path(start, finish)
      |> get_cheats(2, saves)
    end

    defp get_cheats([], _, _) do
      0
    end

    defp get_cheats([{cidx, {cx, cy}} | rest] = path, cheat, save) do
      x = Enum.drop(rest, cheat)
      |> Enum.reduce(0, fn {idx, {x, y}}, acc ->
        if abs(cx - x) + abs(cy - y) == cheat and idx - cidx - 2 >= save do
          acc + 1
        else
          acc
        end
      end)
      x + get_cheats(rest, cheat, save)
    end

    defp follow_path(grid, start, finish) do
      follow_path(grid, start, finish, [{0, start}], nil)
    end

    defp follow_path(_, _, finish, [{_, finish} | _] = path, _) do
      :lists.reverse(path)
    end

    defp follow_path(grid, start, finish, [{idx, {lastx, lasty}} | rest] = path, passed) do

      [newpos] = [{lastx + 1, lasty}, {lastx, lasty + 1}, {lastx - 1, lasty}, {lastx, lasty - 1}]
      |> Enum.filter(fn pos -> Map.has_key?(grid, pos) and pos != passed end)

      follow_path(grid, start, finish, [{idx + 1, newpos} | path], {lastx, lasty})
    end

    defp parse_input(input) do
      {grid, meta} = Enum.with_index(input)
      |> Enum.reduce({[], %{}}, fn {line, row_index}, {acc_grid, acc_meta} ->
        {line_result, line_meta} = parse_line(line, row_index, 0)
        {[line_result | acc_grid], Map.merge(acc_meta, line_meta)}
      end)

      {:lists.flatten(grid), meta}
    end

    defp parse_line(<<>>, _, _), do: {[], %{}}
    defp parse_line(<<c::utf8, rest::binary>>, row, column) do
      coord = {column, row}
      character_result = parse_character(c)

      updated_meta = case character_result do
        :start -> %{start: coord}
        :finish -> %{finish: coord}
        _ -> %{}
      end

      {line_result, line_meta} = parse_line(rest, row, column + 1)

      result = case character_result do
        :nothing -> line_result
        _ -> [coord | line_result]
      end

      {result, Map.merge(updated_meta, line_meta)}
    end

    defp parse_character(?E), do: :finish
    defp parse_character(?S), do: :start
    defp parse_character(?.), do: :track
    defp parse_character(c), do: :nothing
  end

  defmodule Part2 do
    def execute(_input \\ nil), do: 2
  end
end
