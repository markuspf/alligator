defmodule Tui do
  @moduledoc """
  Documentation for `Tui`.
  """

  def run(column_family) do
    #     Ratatouille.run(Tui.ColumnFamilyBrowser, column_family: column_family)
    Supervisor.start_child(Application.Supervisor, Tui.ColumnFamilyBrowser)
  end

  def run() do
    db = StorageEngine.RocksDB.open_test_db()
    cf = StorageEngine.RocksDB.get_column_family(db, "default")

    run(cf)
  end
end
