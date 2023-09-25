use rocksdb::{
    BlockBasedIndexType, BlockBasedOptions, ColumnFamilyDescriptor, Error, IteratorMode, Options,
    ReadOptions, SliceTransform, TransactionDB, DB,
};

enum ArangoRocksDBColumnFamily {
    Definitions(ColumnFamilyDescriptor),
    Documents(ColumnFamilyDescriptor),
    PrimaryIndex(ColumnFamilyDescriptor),
    EdgeIndex(ColumnFamilyDescriptor),
    VPackIndex(ColumnFamilyDescriptor),
    GeoIndex(ColumnFamilyDescriptor),
    FulltextIndex(ColumnFamilyDescriptor),
    ReplicatedLogs(ColumnFamilyDescriptor),
    ZkdIndex(ColumnFamilyDescriptor),
    Invalid(ColumnFamilyDescriptor),
}

impl ArangoRocksDBColumnFamily {
    fn definitions() -> ColumnFamilyDescriptor {
        let opts = Options::default();
        ColumnFamilyDescriptor::new("default", opts)
    }
    fn documents() -> ColumnFamilyDescriptor {
        let mut opts = Options::default();
        opts.set_optimize_filters_for_hits(true);
        ColumnFamilyDescriptor::new("Documents", opts)
    }
    fn primary_index() -> ColumnFamilyDescriptor {
        let mut opts = Options::default();
        opts.set_optimize_filters_for_hits(true);
        opts.set_prefix_extractor(SliceTransform::create_fixed_prefix(std::mem::size_of::<
            usize,
        >()));
        ColumnFamilyDescriptor::new("PrimaryIndex", opts)
    }
    fn edge_index() -> ColumnFamilyDescriptor {
        let mut opts = Options::default();
        opts.set_optimize_filters_for_hits(true);
        opts.set_prefix_extractor(SliceTransform::create(
            "RocksDBPrefixExtractor",
            |x: &[u8]| {
                if x.last() != Some(&0u8) {
                    &x[0..x.len() - 9]
                } else {
                    x
                }
            },
            Some(|x: &[u8]| x.last() != Some(&0u8)),
        ));

        let mut tableopts = BlockBasedOptions::default();
        tableopts.set_index_type(BlockBasedIndexType::HashSearch);

        opts.set_block_based_table_factory(&tableopts);
        ColumnFamilyDescriptor::new("EdgeIndex", opts)
    }
    fn vpack_index() -> ColumnFamilyDescriptor {
        let mut opts = Options::default();
        opts.set_optimize_filters_for_hits(true);
        opts.set_prefix_extractor(SliceTransform::create_fixed_prefix(std::mem::size_of::<
            usize,
        >()));
        opts.set_comparator(
            "RocksDBVPackComparator",
            Box::new(|x: &[u8], u: &[u8]| std::cmp::Ordering::Equal),
        );

        let mut tableopts = BlockBasedOptions::default();
        // tableopgs reset filter opts
        tableopts.set_index_type(BlockBasedIndexType::HashSearch);

        ColumnFamilyDescriptor::new("VPackIndex", opts)
    }
    fn geo_index() -> ColumnFamilyDescriptor {
        let mut opts = Options::default();
        opts.set_optimize_filters_for_hits(true);
        opts.set_prefix_extractor(SliceTransform::create_fixed_prefix(std::mem::size_of::<
            usize,
        >()));
        ColumnFamilyDescriptor::new("GeoIndex", opts)
    }
    fn fulltext_index() -> ColumnFamilyDescriptor {
        let mut opts = Options::default();
        opts.set_prefix_extractor(SliceTransform::create_fixed_prefix(std::mem::size_of::<
            usize,
        >()));
        opts.set_optimize_filters_for_hits(true);
        ColumnFamilyDescriptor::new("FulltextIndex", opts)
    }
    fn replicated_logs() -> ColumnFamilyDescriptor {
        let mut opts = Options::default();
        opts.set_optimize_filters_for_hits(true);
        opts.set_prefix_extractor(SliceTransform::create_fixed_prefix(std::mem::size_of::<
            usize,
        >()));
        ColumnFamilyDescriptor::new("ReplicatedLogs", opts)
    }
    fn zkd_index() -> ColumnFamilyDescriptor {
        let mut opts = Options::default();
        opts.set_optimize_filters_for_hits(true);
        opts.set_prefix_extractor(SliceTransform::create_fixed_prefix(std::mem::size_of::<
            usize,
        >()));
        ColumnFamilyDescriptor::new("ZkdIndex", opts)
    }
}

pub(crate) fn get_column_family(db: &DB, name: String) -> Vec<(Box<[u8]>, Box<[u8]>)> {
    let cf_handle = db.cf_handle(&name).unwrap();
    let mut ropts = ReadOptions::default();
    ropts.set_verify_checksums(false);
    ropts.fill_cache(false);

    let mut iter = db.raw_iterator_cf(cf_handle);
    iter.seek_to_first();

    let mut stuff: Vec<(Box<[u8]>, Box<[u8]>)> = vec![];
    while iter.valid() {
        stuff.push((iter.key().unwrap().into(), iter.value().unwrap().into()));
        iter.next();
    }
    stuff
}

pub(crate) fn open_arangodb_database(path: String) -> Result<DB, Error> {
    let mut cf_opts = Options::default();
    cf_opts.set_max_write_buffer_number(16);
    let cfs: Vec<ColumnFamilyDescriptor> = vec![
        ArangoRocksDBColumnFamily::definitions(),
        ArangoRocksDBColumnFamily::documents(),
        ArangoRocksDBColumnFamily::primary_index(),
        ArangoRocksDBColumnFamily::edge_index(),
        ArangoRocksDBColumnFamily::vpack_index(),
        ArangoRocksDBColumnFamily::geo_index(),
        ArangoRocksDBColumnFamily::fulltext_index(),
        ArangoRocksDBColumnFamily::replicated_logs(),
        ArangoRocksDBColumnFamily::zkd_index(),
    ];

    let mut db_opts = Options::default();
    db_opts.create_missing_column_families(false);
    db_opts.create_if_missing(false);

    DB::open_cf_descriptors(&db_opts, path, cfs)
}
