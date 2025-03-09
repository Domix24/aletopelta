defmodule Aletopelta.Year2023.Day24 do
  @moduledoc """
  Day 24 of Year 2023
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 24
    """
    def parse_input(input) do
      Enum.map input, fn line ->
        [px, py, pz, vx, vy, vz] = Regex.scan(~r/-?\d+/, line)
        |> Enum.map(fn [value] -> String.to_integer value end)
        {px, py, pz, vx, vy, vz}
      end
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 24
    """
    def execute(input) do
      Common.parse_input(input)
      |> chunk
      |> Enum.sum_by(&compare/1)
    end

    defp chunk stones  do
      Enum.reduce(stones, {stones, []}, fn stone1, {acc, res} ->
        stones = Enum.drop acc, 1
        res = Enum.reduce stones, res, fn stone2, res ->
          [{stone1, stone2} | res]
        end

        {stones, res}
      end)
      |> elem(1)
    end

    defp compare {{px1, py1, _, vx1, vy1, _}, {px2, py2, _, vx2, vy2, _}} do
      d = (vx1 * vy2) - (vy1 * vx2)
      t = ((px2 - px1) * vy2) - ((py2 - py1) * vx2)
      u = ((px2 - px1) * vy1) - ((py2 - py1) * vx1)

      if d == 0 do
        0
      else
        t = t / d
        u = u / d

        x = vx1 * t + px1
        y = vy1 * t + py1

        %{first: min, last: max} = 200_000_000_000_000..400_000_000_000_000

        if x >= min and x <= max and y >= min and y <= max and t > 0 and u > 0 do
          1
        else
          0
        end
      end
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 24
    """
    def execute(input) do
      [stone1, stone2, stone3] = Common.parse_input(input)
      |> Enum.take(3)

      [rx: x, ry: y, rz: z, vx: _, vy: _, vz: _] = create_equations(stone1, stone2) ++ create_equations(stone2, stone3)
      |> do_gauss

      Enum.sum([x, y, z])
      |> ceil
    end

    defp create_equations {px0, py0, pz0, vx0, vy0, vz0}, {px1, py1, pz1, vx1, vy1, vz1} do
      [[rx: vy0 - vy1, ry: vx1 - vx0, rz: 0, vx: py1 - py0, vy: px0 - px1, vz: 0,
        c: px0 * vy0 - py0 * vx0 - px1 * vy1 + py1 * vx1],
       [rx: vz0 - vz1, ry: 0, rz: vx1 - vx0, vx: pz1 - pz0, vy: 0, vz: px0 - px1,
        c: px0 * vz0 - pz0 * vx0 - px1 * vz1 + pz1 * vx1],
       [rx: 0, ry: vz0 - vz1, rz: vy1 - vy0, vx: 0, vy: pz1 - pz0, vz: py0 - py1,
        c: py0 * vz0 - pz0 * vy0 - py1 * vz1 + pz1 * vy1]]
    end

    defp do_gauss equations do
      order_equations(equations, :rx)
      |> do_gauss(:rx)
      |> Enum.reverse
      |> substitute(:vz, [])
    end

    defp do_gauss [], _  do
      []
    end
    defp do_gauss [equation | equations], atom do
      value = Keyword.fetch! equation, atom

      equation = if value == 1 do
        equation
      else
        multiplier = 1 / value
        Enum.map equation, fn {key, value} -> {key, value * multiplier} end
      end

      equations = Enum.map(equations, fn eq ->
        case Keyword.fetch! eq, atom do
          0 ->
            eq

          n ->
            normalize equation, eq, n
        end
      end)
      |> order_equations(atom)

      [equation | do_gauss(equations, get_next(atom))]
    end

    defp normalize equation, eq, n do
      Enum.map eq, fn {key, value} -> {key, value - n * Keyword.fetch!(equation, key)} end
    end

    defp substitute [], _, result do
      result
    end
    defp substitute [equation | equations], atom, result do
      sum = Enum.sum_by(equation, fn {key, value} ->
        cond do
          key == atom -> 0
          key == :c -> 0
          true -> value
        end
      end)

      value = (Keyword.fetch!(equation, :c) - sum) / Keyword.fetch!(equation, atom)

      equations = Enum.map equations, fn equation ->
        Keyword.update! equation, atom, & &1 * value
      end

      substitute equations, get_previous(atom), Keyword.put_new(result, atom, value)
    end

    defp order_equations equations, atom do
      Enum.sort_by equations, fn equation ->
        value = Keyword.fetch! equation, atom
        {value, equation}
      end, fn statement1, statement2 ->
        sort_equation statement1, statement2, atom
      end
    end

    defp sort_equation {value1, equation1}, {value2, equation2}, atom do
      if value1 != value2 do
        value1 > value2
      else
        atom = get_next atom

        value1 = Keyword.fetch! equation1, atom
        value2 = Keyword.fetch! equation2, atom

        sort_equation {value1, equation1}, {value2, equation2}, atom
      end
    end

    defp get_next :rx do
      :ry
    end
    defp get_next :ry do
      :rz
    end
    defp get_next :rz do
      :vx
    end
    defp get_next :vx do
      :vy
    end
    defp get_next :vy do
      :vz
    end
    defp get_next :vz do
      nil
    end

    defp get_previous :rx do
      nil
    end
    defp get_previous :ry do
      :rx
    end
    defp get_previous :rz do
      :ry
    end
    defp get_previous :vx do
      :rz
    end
    defp get_previous :vy do
      :vx
    end
    defp get_previous :vz do
      :vy
    end
  end
end
