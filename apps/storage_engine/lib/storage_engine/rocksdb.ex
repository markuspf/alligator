defmodule StorageEngine.RocksDB do
  use Rustler, otp_app: :storage_engine, crate: "storageengine_rocksdb"

  defstruct [:reference]
  # When your NIF is loaded, it will override this function.
  def open(_path), do: error()
  def close(_db), do: error()
  def get_path(_db), do: error()
  def get_column_family(_db, _name), do: error()

  def test() do
    se = open("/home/makx/databases/analytics-6-b/engine-rocksdb")
    cf = get_column_family(se, "default")
    {se, cf}
  end

  defp error() do
    :erlang.nif_error(:nif_not_loaded)
  end
end
