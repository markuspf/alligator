use rustler::{Env, NifStruct, Term};

use rustler::resource::ResourceArc;

// use ArangoRocks;
use rocksdb::TransactionDB;

mod arangodb;
mod brangodb;

pub struct MyDB {
    pub path: String,
    pub db: TransactionDB,
}

#[derive(NifStruct)]
#[module = "StorageEngine.RocksDB"]
struct DBResource {
    pub reference: ResourceArc<MyDB>,
}

#[rustler::nif]
fn open(path: String) -> DBResource {
    let db = arangodb::open_arangodb_database(path.clone()).unwrap();

    DBResource {
        reference: ResourceArc::new(MyDB {
            path: path.clone(),
            db: db,
        }),
    }
}

#[rustler::nif]
fn get_collection_list(res: DBResource) -> Vec<String> {
    arangodb::get_collection_list(&res.reference.db)
}

#[rustler::nif]
fn get_path(res: DBResource) -> String {
    res.reference.path.clone()
}

fn load(env: Env, _: Term) -> bool {
    rustler::resource!(MyDB, env);
    true
}

rustler::init!(
    "Elixir.StorageEngine.RocksDB",
    [open, get_path, get_collection_list],
    load = load
);
