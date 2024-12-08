defmodule AletopeltaTest.Custom do
  use ExUnit.CaseTemplate

  setup do
    :timer.sleep(2000)
    :ok
  end

  defmacro __using__() do
    quote do
      use ExUnit.Case, async: true
      import unquote(__MODULE__)
    end
  end
end
