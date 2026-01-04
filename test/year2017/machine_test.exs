defmodule AletopeltaTest.Year2017.Machine do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2017.Machine

  test "empty test" do
    assert Machine.new(nil,
             pointer: 2,
             registers: Map.new([{"z", 2}]),
             options: Map.new(test: 4),
             flag: true
           ) === {nil, 2, %{"z" => 2}, %{test: 4}}
  end
end
