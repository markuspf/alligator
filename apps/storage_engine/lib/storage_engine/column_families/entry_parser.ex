defmodule StorageEngine.RocksDB.ColumnFamilies.EntryParser do
  @doc """
  Interpreting the definitions column family in ArangoDB's RocksDB Storage Engine
  """

  """
  enum class RocksDBEntryType : char {
    Placeholder = '\0',
    Database = '0',
    Collection = '1',
    CounterValue = '2',
    Document = '3',
    PrimaryIndexValue = '4',
    EdgeIndexValue = '5',
    VPackIndexValue = '6',
    UniqueVPackIndexValue = '7',
    SettingsValue = '8',
    ReplicationApplierConfig = '9',
    FulltextIndexValue = ':',
    LegacyGeoIndexValue = ';',
    IndexEstimateValue = '<',
    KeyGeneratorValue = '=',
    View = '>',
    GeoIndexValue = '?',
    LogEntry = 'L',
    // RevisionTreeValue = '@', // pre-3.8 GA revision trees. do not use or reuse!
    // RevisionTreeValue = '/', // pre-3.8 GA revision trees. do not use or reuse!
    RevisionTreeValue = '*',
    ReplicatedState = 's',
    ZkdIndexValue = 'z',
    UniqueZkdIndexValue = 'Z',
  };
  """

  def parse_entry({<<0, _rest::binary>>, _vpack}) do
  end

  def parse_entry({<<"0", _database_id::64>>, vpack}) do
    spec = VelocyPack.decode!(vpack)
    %ArangoDB.Database{spec: spec}
  end

  def parse_entry({<<"1", database_id::64, _collection_id::64>>, vpack}) do
    spec = VelocyPack.decode!(vpack)
    %ArangoDB.Collection{database_id: database_id, spec: spec}
  end

  def parse_entry(<<"2", id, _rest::binary>>) do
  end

  def parse_entry({<<"3", id, _rest::binary>>, vpack}) do
    spec = VelocyPack.decode!(vpack)
    %ArangoDB.Document{spec: spec}
  end

  def parse_entry(<<"4", id, _rest::binary>>) do
  end

  def parse_entry(<<"5", id, _rest::binary>>) do
  end

  def parse_entry(<<"6", id, _rest::binary>>) do
  end

  def parse_entry(<<"7", id, _rest::binary>>) do
  end

  def parse_entry(<<"8", id, _rest::binary>>) do
  end

  def parse_entry(<<"9", id, _rest::binary>>) do
  end

  def parse_entry(<<":", id, _rest::binary>>) do
  end

  def parse_entry(<<";", id, _rest::binary>>) do
  end

  def parse_entry(<<"<", id, _rest::binary>>) do
  end

  def parse_entry(<<"=", id, _rest::binary>>) do
  end

  def parse_entry(<<">", id, _rest::binary>>) do
  end

  def parse_entry(<<"?", id, _rest::binary>>) do
  end

  def parse_entry(<<"L", id, _rest::binary>>) do
  end

  def parse_entry(<<"*", id, _rest::binary>>) do
  end

  def parse_entry(<<"s", id, _rest::binary>>) do
  end

  def parse_entry(<<"z", id, _rest::binary>>) do
  end

  def parse_entry(<<"Z", id, _rest::binary>>) do
  end

  def parse_entry({<<t, _rest::binary>>, vpack}) do
    VelocyPack.decode(vpack)
  end
end
