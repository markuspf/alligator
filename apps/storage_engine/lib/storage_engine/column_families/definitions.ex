defmodule StorageEngine.RocksDB.ColumnFamilies.Definitions do
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

  def parse_entry(<<0, _rest::binary>>) do
    IO.puts("placeholder")
  end

  def parse_entry(<<"0", database_id::64>>) do
    IO.puts("type: Database, database_id #{database_id}")
  end

  def parse_entry(<<"1", database_id::64, collection_id::64>>) do
    IO.puts("type: Collection, database_id: #{database_id}, collection_id: #{collection_id}")
  end

  def parse_entry(<<"2", id, _rest::binary>>) do
    IO.puts("type: Countervalue, id #{id}")
  end

  def parse_entry(<<"3", id, _rest::binary>>) do
    IO.puts("type: Document, id #{id}")
  end

  def parse_entry(<<"4", id, _rest::binary>>) do
    IO.puts("type: PrimaryIndexValue, id #{id}")
  end

  def parse_entry(<<"5", id, _rest::binary>>) do
    IO.puts("type: EdgeIndexValue, id #{id}")
  end

  def parse_entry(<<"6", id, _rest::binary>>) do
    IO.puts("type: VPackIndexValue, id #{id}")
  end

  def parse_entry(<<"7", id, _rest::binary>>) do
    IO.puts("type: UniqueVPackIndexValue, id #{id}")
  end

  def parse_entry(<<"8", id, _rest::binary>>) do
    IO.puts("type: SettingsValue, id #{id}")
  end

  def parse_entry(<<"9", id, _rest::binary>>) do
    IO.puts("type: ReplicationApplierConfig, id #{id}")
  end

  def parse_entry(<<":", id, _rest::binary>>) do
    IO.puts("type: FulltextIndexValue, id #{id}")
  end

  def parse_entry(<<";", id, _rest::binary>>) do
    IO.puts("type: LegacyGeoIndexValue, id #{id}")
  end

  def parse_entry(<<"<", id, _rest::binary>>) do
    IO.puts("type: IndexEstimateValue, id #{id}")
  end

  def parse_entry(<<"=", id, _rest::binary>>) do
    IO.puts("type: KeyGeneratorValue, id #{id}")
  end

  def parse_entry(<<">", id, _rest::binary>>) do
    IO.puts("type: View, id #{id}")
  end

  def parse_entry(<<"?", id, _rest::binary>>) do
    IO.puts("type: GeoIndexValue, id #{id}")
  end

  def parse_entry(<<"L", id, _rest::binary>>) do
    IO.puts("type: LogEntry, id #{id}")
  end

  def parse_entry(<<"*", id, _rest::binary>>) do
    IO.puts("type: RevisionTreeValue, id #{id}")
  end

  def parse_entry(<<"s", id, _rest::binary>>) do
    IO.puts("type: ReplicatedState, id #{id}")
  end

  def parse_entry(<<"z", id, _rest::binary>>) do
    IO.puts("type: ZkdIndexValue, id #{id}")
  end

  def parse_entry(<<"Z", id, _rest::binary>>) do
    IO.puts("type: UniqueZkdIndexValue, id #{id}")
  end

  def parse_entry(<<t, _rest::binary>>) do
    IO.puts("unsupported type byte: #{t}")
  end
end
