defmodule Aletopelta.Day20241214 do
  defmodule Common do
  end

  defmodule Part1 do
    defmodule Position do
      defstruct [:x, :y]
    end

    defmodule Velocity do
      defstruct [:x, :y]
    end

    defmodule Robot do
      defstruct [:position, :velocity, :quadrant]
    end

    defmodule MapInfo do
      defstruct [:height, :width]
    end

    defmodule Quadrant do
      defstruct [:topleft, :bottomright]
    end

    @pattern_pv ~r/p=(\d+),(\d+) v=([-+]?\d+),([-+]?\d+)/

    def execute(input \\ nil) do
      map = %MapInfo{height: 103, width: 101}
      input
      |> parse_lines
      |> simulate(map, 100)
      |> assign_quadrants(map)
      |> Enum.reduce(1, fn {_, count}, acc -> acc * count end)
    end

    defp parse_lines([]), do: []
    defp parse_lines([line | rest]) do
      line = line
      |> parse_line

      [line | rest
      |> parse_lines]
      |> Enum.filter(&(&1 != nil))
    end

    defp parse_line(""), do: nil
    defp parse_line(line) do
      [_, px, py, vx, vy] = @pattern_pv
      |> Regex.run(line)

      [px, py, vx, vy] = [px, py, vx, vy]
      |> Enum.map(fn numberstring ->
        numberstring
        |> String.to_integer
      end)

      %Robot{position: %Position{x: px, y: py}, velocity: %Velocity{x: vx, y: vy}}
    end

    defp simulate([], _, _), do: []

    defp simulate([first | rest], map, simulations) do
      first = update_position(first, map, simulations)
      [first | simulate(rest, map, simulations)]
    end

    defp update_position(robot, map, simulations) do
      x = calculate_coordinate(robot.position.x, robot.velocity.x, simulations, map.width)
      y = calculate_coordinate(robot.position.y, robot.velocity.y, simulations, map.height)
      %{robot | position: %{robot.position | x: x, y: y}}
    end

    defp calculate_coordinate(position, velocity, simulations, limit) do
      rem(rem(position + velocity * simulations, limit) + limit, limit)
    end

    defp assign_quadrants(robots, map) do
      robots
      |> Enum.map(&determine_quadrant(&1, map))
      |> Enum.filter(&(&1.quadrant))
      |> Enum.reduce(%{}, fn robot, acc ->
        acc
        |> Map.update(robot.quadrant, 1, &(&1 + 1))
      end)
    end

    defp determine_quadrant(robot, map) do
      quadrants = define_quadrants(map)

      index = quadrants
      |> Enum.find_index(fn quadrant ->
        robot.position.x > quadrant.topleft.x and robot.position.x < quadrant.bottomright.x and
        robot.position.y > quadrant.topleft.y and robot.position.y < quadrant.bottomright.y
      end)

      %{robot | quadrant: index}
    end

    defp define_quadrants(map) do
      [
        %Quadrant{topleft: %Position{x: -1, y: -1}, bottomright: %Position{x: div(map.width, 2), y: div(map.height, 2)}},
        %Quadrant{topleft: %Position{x: div(map.width, 2), y: -1}, bottomright: %Position{x: map.width, y: div(map.height, 2)}},
        %Quadrant{topleft: %Position{x: -1, y: div(map.height, 2)}, bottomright: %Position{x: div(map.width, 2), y: map.height}},
        %Quadrant{topleft: %Position{x: div(map.width, 2), y: div(map.height, 2)}, bottomright: %Position{x: map.width, y: map.height }}
      ]
    end
  end

  defmodule Part2 do
    def execute(_input \\ nil), do: 2
  end
end
