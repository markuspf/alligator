defmodule Gui do
  @moduledoc """
  Documentation for `Gui`.
  """

  @doc """

  """
  def run() do
    {:wx_ref, _, _, pid} = Gui.Canvas.start_link()
    ref = Process.monitor(pid)

    receive do
      {:DOWN, ^ref, _, _, _} ->
        :ok
    end
  end

  def definitions_explorer() do
    {:wx_ref, _, _, pid} = Gui.Definitions.start_link()
    ref = Process.monitor(pid)
  end
end
