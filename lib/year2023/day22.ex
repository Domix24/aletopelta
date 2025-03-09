defmodule Aletopelta.Year2023.Day22 do
  @moduledoc """
  Day 22 of Year 2023
  """
  defmodule Brick do
    @moduledoc """
    Brick
    """
    defstruct [:id, :x, :y, :z]
  end

  defmodule Common do
    @moduledoc """
    Common part for Day 22
    """
    def parse_input(input) do
      Enum.reduce input, {[], 0}, fn line, {map, index} ->
        Regex.scan(~r/\d+/, line)
        |> Enum.map(fn [coord] -> String.to_integer coord end)
        |> then(fn [x1, y1, z1, x2, y2, z2] ->
          brick = %Brick{id: index, x: x1..x2//1, y: y1..y2//1, z: z1..z2//1}
          map = [brick | map]

          {map, index + 1}
        end)
      end
    end

    def simulate_fall bricks do
      Enum.reduce(bricks, {[], %{}}, fn brick, {stable_bricks, height_map} ->
        max_height = find_height brick, height_map

        brick = %{brick | z: Range.shift(brick.z, -brick.z.first + max_height + 1)}
        height_map = update_map brick, height_map

        {[brick | stable_bricks], height_map}
      end)
      |> elem(0)
      |> Enum.reverse
    end

    defp find_height brick, height_map do
      for x <- Enum.to_list(brick.x),
          y <- Enum.to_list(brick.y),
          reduce: 0 do
        max ->
          current = Map.get height_map, {x, y}, 0
          max current, max
      end
    end

    defp update_map brick, height_map do
      for x <- Enum.to_list(brick.x),
          y <- Enum.to_list(brick.y),
          reduce: height_map do
        height_map ->
          Map.put height_map, {x, y}, brick.z.last
      end
    end

    def build_relationships bricks do
      Enum.reduce bricks, {%{}, %{}}, fn brick, {supports, supported_by} ->
        supports = Map.put_new supports, brick.id, MapSet.new
        supported_by = Map.put_new supported_by, brick.id, MapSet.new

        sits_on = Enum.filter bricks, fn other ->
          other.id != brick.id and
          other.z.last + 1 == brick.z.first and
          !Range.disjoint?(brick.x, other.x) and
          !Range.disjoint?(brick.y, other.y)
        end

        Enum.reduce sits_on, {supports, supported_by}, fn support, {supports, supported_by} ->
          supports = Map.update! supports, support.id, &MapSet.put(&1, brick.id)
          supported_by = Map.update! supported_by, brick.id, &MapSet.put(&1, support.id)

          {supports, supported_by}
        end
      end
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 22
    """
    def execute(input) do
      {bricks, _} = Common.parse_input input

      Enum.sort_by(bricks, & &1.z.first)
      |> Common.simulate_fall
      |> count_bricks
    end

    defp count_bricks bricks do
      {supports, supported_by} = Common.build_relationships bricks

      Enum.count bricks, fn brick ->
        Map.get(supports, brick.id, MapSet.new)
        |> Enum.all?(fn supported_id ->
          size = Map.get(supported_by, supported_id, MapSet.new)
          |> MapSet.size

          size > 1
        end)
      end
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 22
    """
    def execute(input) do
      {bricks, _} = Common.parse_input input

      bricks = Enum.sort_by(bricks, & &1.z.first)
      |> Common.simulate_fall

      {supports, supported_by} = Common.build_relationships bricks
      sum_reactions bricks, supports, supported_by
    end

    defp sum_reactions bricks, supports, supported_by do
      Enum.sum_by bricks, fn brick ->
        count_falls brick.id, supports, supported_by
      end
    end

    defp count_falls brick_id, supports, supported_by do
      size = process_chain(MapSet.new([brick_id]), MapSet.new, supports, supported_by)
      |> MapSet.size
      size - 1
    end

    defp process_chain to_process, already_falling, supports, supported_by do
      case MapSet.size to_process do
        0 ->
          already_falling

        _ ->
          current = Enum.at MapSet.to_list(to_process), 0
          remaining = MapSet.delete to_process, current
          all_falling = MapSet.put already_falling, current

          Map.get(supports, current, MapSet.new)
          |> Enum.filter(fn supported_id ->
            Map.get(supported_by, supported_id, MapSet.new)
            |> MapSet.subset?(all_falling)
          end)
          |> MapSet.new
          |> MapSet.difference(all_falling)
          |> MapSet.union(remaining)
          |> process_chain(all_falling, supports, supported_by)
      end
    end
  end
end
