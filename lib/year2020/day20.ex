defmodule Aletopelta.Year2020.Day20 do
  @moduledoc """
  Day 20 of Year 2020
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 20
    """

    @type input() :: list(binary())
    @type borders() :: list(binary())
    @type grid() :: %{{integer(), integer()} => binary()}
    @type id() :: integer()
    @type output() :: %{id() => {grid(), borders()}}

    @spec parse_input(input()) :: output()
    def parse_input(input) do
      input
      |> Enum.chunk_by(&(&1 == ""))
      |> Enum.reject(&(&1 == [""]))
      |> Map.new(fn [tile | grid] ->
        [id] =
          ~r/\d+/
          |> Regex.run(tile)
          |> Enum.map(&String.to_integer/1)

        borders = get_borders(grid)

        new_grid = parse_grid(grid)

        {id, {new_grid, borders}}
      end)
    end

    @spec get_borders(list(binary())) :: borders()
    def get_borders(grid) do
      borders = Enum.map(0..3, &border_wrapper(grid, &1))
      reverse = Enum.map(borders, &String.reverse(&1))

      borders ++ reverse
    end

    defp border_wrapper(grid, n),
      do:
        grid
        |> get_border(n)
        |> Enum.join("")

    defp get_border(grid, 0),
      do:
        grid
        |> Enum.at(0)
        |> String.graphemes()

    defp get_border(grid, 1),
      do:
        grid
        |> Enum.at(length(grid) - 1)
        |> String.graphemes()

    defp get_border(grid, 2), do: Enum.map(grid, &String.slice(&1, 0..0))
    defp get_border(grid, 3), do: Enum.map(grid, &String.slice(&1, -1, 1))

    defp parse_grid(lines),
      do:
        lines
        |> Enum.with_index()
        |> Enum.flat_map(fn {line, y} ->
          line
          |> String.graphemes()
          |> Enum.with_index()
          |> Enum.map(fn {cell, x} ->
            {{x, y}, cell}
          end)
        end)
        |> Map.new()

    @spec find_corners(output()) :: list({id(), grid(), borders()})
    def find_corners(tiles),
      do:
        Enum.reduce_while(tiles, {0, []}, fn {first_id, {first_grid, first_borders}},
                                             {acc_count, acc_list} = acc ->
          count =
            Enum.count_until(
              tiles,
              fn {second_id, {_, second_borders}} ->
                first_id != second_id and
                  Enum.any?(first_borders, &Enum.member?(second_borders, &1))
              end,
              3
            )

          {new_count, new_list} =
            new_acc =
            if count == 2 do
              {acc_count + 1, [{first_id, first_grid, first_borders} | acc_list]}
            else
              acc
            end

          if new_count == 4 do
            {:halt, new_list}
          else
            {:cont, new_acc}
          end
        end)
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 20
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Common.find_corners()
      |> Enum.product_by(&elem(&1, 0))
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 20
    """
    @spec execute(Common.input(), []) :: integer() | :ok
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> get_corner()
      |> align_tiles()
      |> build_grid()
      |> remove_borders()
      |> find_monsters()
      |> roughness()
    end

    defp roughness({grid, nb_monsters}) do
      nb_rough =
        Enum.sum_by(grid, fn line ->
          ~r/#/
          |> Regex.scan(line)
          |> Enum.count()
        end)

      nb_rough - 15 * nb_monsters
    end

    defp find_monsters(grid),
      do:
        Enum.reduce_while(0..7, grid, fn transform_id, acc_grid ->
          new_grid = transform_grid(acc_grid, transform_id)
          nb_monsters = find_monsters(new_grid, :find)

          if nb_monsters > 0 do
            {:halt, {grid, nb_monsters}}
          else
            {:cont, new_grid}
          end
        end)

    defp find_monsters([line1, line2, line3 | rest], :find) do
      regex_line1 = ~r/(?=(..................#.))/
      regex_line2 = ~r/(?=(#....##....##....###))/
      regex_line3 = ~r/(?=(.#..#..#..#..#..#...))/

      regex_line3
      |> Regex.scan(line3, return: :index, capture: :all_but_first)
      |> Enum.flat_map(& &1)
      |> find_monsters(regex_line2, line2, line3, :line)
      |> find_monsters(regex_line1, line1, line2, :line)
      |> find_monsters([line2, line3 | rest], :find)
    end

    defp find_monsters(_, :find), do: 0

    defp find_monsters(list, regex, line2, _, :line),
      do:
        Enum.flat_map(list, fn {index, length} ->
          regex
          |> Regex.scan(String.slice(line2, index, length),
            return: :index,
            capture: :all_but_first
          )
          |> Enum.flat_map(fn [{sindex, length}] ->
            [{sindex + index, length}]
          end)
        end)

    defp find_monsters(list, lines, :find), do: length(list) + find_monsters(lines, :find)

    defp transform_grid(grid, 0), do: grid
    defp transform_grid(grid, 4), do: Enum.map(grid, &String.reverse/1)

    defp transform_grid(grid, _) do
      reverse_grid =
        grid
        |> Enum.reverse()
        |> Enum.map(&String.graphemes/1)

      reverse_grid
      |> Enum.with_index()
      |> Enum.map(fn {_, index} ->
        Enum.map_join(reverse_grid, &Enum.at(&1, index))
      end)
    end

    defp get_corner(tiles) do
      {corner_id, corner_grid, corner_borders} =
        tiles
        |> Common.find_corners()
        |> Enum.at(0)

      {{corner_id, {corner_grid, corner_borders}}, tiles}
    end

    defp align_tiles({{id, _} = corner, tiles}),
      do:
        [corner]
        |> align_tiles(tiles, Map.new())
        |> Map.new(fn {id, {grid, right, bottom}} -> {id, {normalize(grid), right, bottom}} end)
        |> traverse(id)

    defp align_tiles([], %{}, aligned), do: aligned

    defp align_tiles([_ | _] = list, tiles, aligned) do
      tile_complete =
        Enum.map(list, fn {corner_id, {corner_grid, corner_borders}} ->
          match_borders(corner_borders, tiles, corner_id, corner_grid)
        end)

      {new_tiles, new_aligned, to_process} = prepare(tile_complete, tiles, aligned)

      to_process
      |> Map.to_list()
      |> align_tiles(new_tiles, new_aligned)
    end

    defp match_borders(corner_borders, tiles, corner_id, corner_grid),
      do:
        corner_borders
        |> Enum.take(4)
        |> Enum.with_index()
        |> Enum.reduce_while({0, []}, &complete_border(&1, &2, tiles, corner_id))
        |> elem(1)
        |> Enum.reduce({{corner_id, {corner_grid, nil, nil}}, []}, &reduce_borders/2)

    defp reduce_borders({3, {id, _} = tile}, {{acc_id, {acc_grid, acc_1, nil}}, acc_tiles}),
      do: {{acc_id, {acc_grid, acc_1, id}}, [tile | acc_tiles]}

    defp reduce_borders({1, {id, _} = tile}, {{acc_id, {acc_grid, nil, acc_3}}, acc_tiles}),
      do: {{acc_id, {acc_grid, id, acc_3}}, [tile | acc_tiles]}

    defp complete_border({border, border_index}, {acc_count, acc_list}, tiles, corner_id) do
      matching =
        Enum.find_value(tiles, fn {tile_id, {_, tile_borders}} = tile ->
          {_, side_index} =
            tile_borders
            |> Enum.with_index()
            |> Enum.find({0, -1}, fn {sub_border, _} ->
              tile_id != corner_id and sub_border == border
            end)

          prepare_transform(side_index, border_index, tile, border)
        end)

      new_count = if matching, do: acc_count + 1, else: acc_count
      new_list = if matching, do: [matching | acc_list], else: acc_list
      new_acc = {new_count, new_list}

      if new_count == 4, do: {:halt, new_acc}, else: {:cont, new_acc}
    end

    defp prepare_transform(side_index, border_index, tile, border),
      do:
        prepare_transform(
          side_index,
          border_index,
          tile,
          border,
          no_transformation?(border_index, side_index)
        )

    defp prepare_transform(side_index, border_index, tile, _, true) when side_index > -1,
      do: {border_index, tile}

    defp prepare_transform(side_index, border_index, tile, border, false) when side_index > -1,
      do: Enum.reduce_while(0..7, tile, &transform_tile(&1, &2, border_index, border))

    defp prepare_transform(_, _, _, _, _), do: nil

    defp transform_tile(transformation_id, acc_tile, border_index, border) do
      {_, {_, new_borders}} = new_tile = transform(acc_tile, transformation_id)

      new_borders
      |> Enum.at(transformed_index(border_index))
      |> found_border(border_index, new_tile, border)
    end

    defp found_border(border, index, tile, border), do: {:halt, {index, tile}}
    defp found_border(_, _, tile, _), do: {:cont, tile}

    defp prepare(tile_complete, tiles, aligned),
      do:
        Enum.reduce(tile_complete, {tiles, aligned, Map.new()}, fn {{id, info}, tiles},
                                                                   {acc_tiles, acc_aligned,
                                                                    acc_process} ->
          temp_tiles = Map.delete(acc_tiles, id)
          temp_aligned = Map.put_new(acc_aligned, id, info)

          temp_process =
            Enum.reduce(tiles, acc_process, fn {id, subinfo}, acc_toprocess ->
              Map.put_new(acc_toprocess, id, subinfo)
            end)

          {temp_tiles, temp_aligned, temp_process}
        end)

    defp normalize(grid) do
      keys = Map.keys(grid)
      {minx, _} = Enum.min_by(keys, &elem(&1, 0))
      {_, miny} = Enum.min_by(keys, &elem(&1, 1))

      if {minx, miny} == {0, 0} do
        grid
      else
        {xadjust, yadjust} = {0 - minx, 0 - miny}
        Map.new(grid, fn {{x, y}, value} -> {{x + xadjust, y + yadjust}, value} end)
      end
    end

    defp traverse(normalize, corner_id) do
      {_, bottom, right} = Map.fetch!(normalize, corner_id)

      traversed = traverse([{right, bottom, {0, 0}}], normalize, [{{0, 0}, corner_id}])
      {normalize, traversed}
    end

    defp traverse([], _, traversed),
      do:
        traversed
        |> Enum.reject(&(elem(&1, 1) == nil))
        |> Map.new()

    defp traverse([_ | _] = list, normalize, traversed) do
      [new_list, new_traversed] =
        list
        |> Enum.reduce([[], traversed], &process_traverse(&1, &2, normalize))
        |> Enum.map(&Enum.uniq/1)

      new_list
      |> Enum.reject(&Enum.member?(traversed, &1))
      |> traverse(normalize, new_traversed)
    end

    defp traverse(acc, id, normalize, source, side),
      do:
        normalize
        |> Map.get(id, nil)
        |> then(fn
          nil -> acc
          {_, bottom, right} -> [{right, bottom, increment_side(side, source)} | acc]
        end)

    defp process_traverse(
           {right_id, bottom_id, {source_x, source_y}},
           [acc_next, acc_traversed],
           normalize
         ) do
      new_next =
        acc_next
        |> traverse(right_id, normalize, {source_x, source_y}, :right)
        |> traverse(bottom_id, normalize, {source_x, source_y}, :bottom)

      new_traversed = [
        {{source_x + 1, source_y}, right_id},
        {{source_x, source_y + 1}, bottom_id} | acc_traversed
      ]

      [new_next, new_traversed]
    end

    defp increment_side(:right, {x, y}), do: {x + 1, y}
    defp increment_side(:bottom, {x, y}), do: {x, y + 1}

    defp build_grid({normalize, mapping}) do
      {{maxx, _}, _} = Enum.max_by(mapping, fn {{x, _}, _} -> x end)
      {{_, maxy}, _} = Enum.max_by(mapping, fn {{_, y}, _} -> y end)

      Enum.reduce(0..maxy, nil, fn tx, acc ->
        build_grid(tx, acc, normalize, mapping, maxx)
      end)
    end

    defp build_grid(ty, acc, normalize, mapping, maxx),
      do:
        Enum.reduce(0..maxx, acc, fn tx, acc ->
          tile_id = Map.fetch!(mapping, {tx, ty})
          {tile_grid, _, _} = Map.fetch!(normalize, tile_id)
          build_grid(tx, ty, tile_grid, acc)
        end)

    defp build_grid(_, _, tile_grid, nil), do: tile_grid

    defp build_grid(tx, ty, tile_grid, acc),
      do:
        tile_grid
        |> Map.new(fn {{x, y}, value} ->
          {{x + tx * 10, y + ty * 10}, value}
        end)
        |> Map.merge(acc)

    defp remove_borders(grid),
      do:
        grid
        |> Enum.flat_map(&remove_border/1)
        |> Enum.group_by(fn {{_, y}, _} -> y end, fn {{x, _}, v} -> {x, v} end)
        |> Enum.sort_by(&elem(&1, 0))
        |> Enum.map(fn {_, list} ->
          list
          |> Enum.sort_by(&elem(&1, 0))
          |> Enum.map_join(&elem(&1, 1))
        end)

    defp remove_border({{x, y}, _}) when rem(x, 10) in [0, 9] when rem(y, 10) in [0, 9], do: []
    defp remove_border(value), do: [value]

    defp no_transformation?(0, t), do: t < 4 and transformed_index(t) == 0
    defp no_transformation?(1, t), do: t < 4 and transformed_index(t) == 1
    defp no_transformation?(2, t), do: t < 4 and transformed_index(t) == 2
    defp no_transformation?(3, t), do: t < 4 and transformed_index(t) == 3

    defp transformed_index(0), do: 1
    defp transformed_index(1), do: 0
    defp transformed_index(2), do: 3
    defp transformed_index(3), do: 2
    defp transformed_index(_), do: 4

    defp transform(tile, 0), do: tile

    defp transform({id, {grid, _}}, 4),
      do:
        grid
        |> Enum.map(fn {{x, y}, v} -> {{y, x}, v} end)
        |> recreate_tile(id)

    defp transform({id, {grid, _}}, _),
      do:
        grid
        |> Enum.map(fn {{x, y}, v} -> {{y, -x}, v} end)
        |> recreate_tile(id)

    defp recreate_tile(new_grid, id) do
      new_borders =
        new_grid
        |> Enum.group_by(fn {{_, y}, _} -> y end, fn {{x, _}, v} -> {x, v} end)
        |> Enum.map(&combine_line/1)
        |> Enum.sort_by(&elem(&1, 0))
        |> Enum.map(&elem(&1, 1))
        |> Common.get_borders()

      {id, {Map.new(new_grid), new_borders}}
    end

    defp combine_line({y, list}) do
      new_list =
        list
        |> Enum.sort_by(&elem(&1, 0))
        |> Enum.map_join(&elem(&1, 1))

      {y, new_list}
    end
  end
end
