defmodule StorageEngine.RocksDB do
  use Rustler, otp_app: :storage_engine, crate: "storageengine_rocksdb"

  alias ArangoDB.Database
  alias ArangoDB.Collection
  alias StorageEngine.RocksDB
  alias StorageEngine.RocksDB.ColumnFamilies

  defstruct [:reference]
  # When your NIF is loaded, it will override this function.
  def open(_path), do: error()
  def close(_db), do: error()
  def get_path(_db), do: error()
  def get_column_family(_db, _name), do: error()

  def open_test_db() do
    open("/home/makx/databases/analytics-6-b/engine-rocksdb")
  end

  def read_definitions(%StorageEngine.RocksDB{} = db) do
    entries =
      get_column_family(db, "default")
      |> Enum.map(&ColumnFamilies.EntryParser.parse_entry/1)

    %ColumnFamilies.Definitions{entries: entries}
  end

  def open_test_cf() do
    db = open_test_db()
    get_column_family(db, "default")
  end

  def open_test_docs() do
    db = open_test_db()
    get_column_family(db, "Documents")
  end

  def fullon() do
    cf = open_test_docs()
    {_, v} = Enum.at(cf, 0)
    VelocyPack.decode(v)
  end

  def databases(%ColumnFamilies.Definitions{entries: defs}) do
    defs
    |> Enum.filter(fn v ->
      case v do
        %ArangoDB.Database{} -> true
        _ -> false
      end
    end)
  end

  def collections(%ColumnFamilies.Definitions{entries: defs}) do
    defs
    |> Enum.reduce(%{}, fn e, acc ->
      case e do
        %ArangoDB.Collection{database_id: database_id, spec: %{"name" => name}} ->
          Map.update(acc, database_id, %{"name" => e}, fn m -> Map.put(m, name, e) end)

        _ ->
          acc
      end
    end)
  end

  def list_collection_names(cff) do
    cff
    |> Enum.map(&ArangoDB.Collection.name/1)
  end

  defp error() do
    :erlang.nif_error(:nif_not_loaded)
  end
end
