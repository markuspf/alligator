defmodule StorageEngine.RocksDB do
  use Rustler, otp_app: :storage_engine, crate: "storageengine_rocksdb"

  # When your NIF is loaded, it will override this function.
  def add(_a, _b), do: :erlang.nif_error(:nif_not_loaded)

  def foobar(_a), do: :erlang.nif_error(:nif_not_loaded)

  def open(), do: :erlang.nif_error(:nif_not_loaded)
end
