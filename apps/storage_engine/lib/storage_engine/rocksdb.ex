defmodule StorageEngine.RocksDB do
  use Rustler, otp_app: :storage_engine, crate: "storageengine_rocksdb"

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
    get_column_family(db, "default")
    |> Enum.map(&StorageEngine.RocksDB.ColumnFamilies.Definitions.parse_entry/1)
  end

  def databases(defs) do
    defs
    |> Enum.filter(fn v ->
      case v do
        %ArangoDB.Database{} -> true
        _ -> false
      end
    end)
  end

  def collections(defs) do
    defs
    |> Enum.filter(fn v ->
      case v do
        %ArangoDB.Collection{} -> true
        _ -> false
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
