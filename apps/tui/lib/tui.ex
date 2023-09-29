defmodule Tui do
  @moduledoc """
  Documentation for `Tui`.
  """

  def run() do
    Supervisor.start_link(Ratatouille.Runtime.Supervisor, runtime: [app: Tui.ColumnFamilyBrowser])
  end
end
