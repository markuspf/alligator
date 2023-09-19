defmodule StorageEngine.RocksDB do
  use Rustler, otp_app: :storage_engine, crate: "storageengine_rocksdb"

  defstruct [:reference]
  # When your NIF is loaded, it will override this function.
  def open(_path), do: error()
  def get_path(_db), do: error()
  def put(_db, _key, _value), do: error()
  def get(_db, _key), do: error()

  defp error() do
    :erlang.nif_error(:nif_not_loaded)
  end
end
