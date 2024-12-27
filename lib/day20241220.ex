defmodule Aletopelta.Day20241220 do
  defmodule Common do
    def get_cheats([], _, _) do
      0
    end

    def get_cheats([{cidx, {cx, cy}} | rest], cheat, save) do
      count = Enum.drop(rest, save + 1)
      |> Enum.reduce(0, fn {idx, {x, y}}, count ->
        dist = abs(cx - x) + abs(cy - y)
        if dist <= cheat and idx - cidx >= save + dist do
          count + 1
        else
          count
        end
      end)
      count + get_cheats(rest, cheat, save)
    end

    def follow_path(grid, start, finish) do
      follow_path(grid, start, finish, [{0, start}], nil)
    end

    defp follow_path(_, _, finish, [{_, finish} | _] = path, _) do
      :lists.reverse(path)
    end

    defp follow_path(grid, start, finish, [{idx, {lastx, lasty}} | _] = path, passed) do
      [newpos] = [{lastx + 1, lasty}, {lastx, lasty + 1}, {lastx - 1, lasty}, {lastx, lasty - 1}]
      |> Enum.filter(fn pos -> Map.has_key?(grid, pos) and pos != passed end)

      follow_path(grid, start, finish, [{idx + 1, newpos} | path], {lastx, lasty})
    end

    def parse_input(input) do
      {grid, meta} = Enum.with_index(input)
      |> Enum.reduce({[], %{}}, fn {line, row_index}, {acc_grid, acc_meta} ->
        {line_result, line_meta} = parse_line(line, row_index, 0)
        {[line_result | acc_grid], Map.merge(acc_meta, line_meta)}
      end)

      {Map.new(:lists.flatten(grid), fn pos -> {pos, true} end), meta}
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
    defp parse_character(_), do: :nothing
  end

  defmodule Part1 do
    def execute(input \\ nil, saves \\ 100) do
      {grid, %{start: start, finish: finish}} = Common.parse_input(input)

      grid
      |> Common.follow_path(start, finish)
      |> Common.get_cheats(2, saves)
    end
  end

  defmodule Part2 do
    def execute(input \\ nil, saves \\ 100) do
      {grid, %{start: start, finish: finish}} = Common.parse_input(input)

      grid
      |> Common.follow_path(start, finish)
      |> Common.get_cheats(20, saves)
    end
  end
end
