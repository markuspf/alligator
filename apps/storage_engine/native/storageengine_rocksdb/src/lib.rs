use rustler::{Binary, NewBinary, OwnedBinary, Env, NifResult, NifStruct, Term};

use rustler::resource::ResourceArc;

// use ArangoRocks;
use rocksdb::DB;

mod arangodb;

pub struct MyDB {
    pub path: String,
    pub db: DB,
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
fn close(res: DBResource) -> Result<(), ()> {
    Err(())
}

#[rustler::nif]
fn get_column_family<'a>(env: Env<'a>, res: DBResource, name: String) -> NifResult<Vec<(Binary<'a>, Binary<'a>)>> {
    let vals = arangodb::get_column_family(&res.reference.db, name);

    let mut r : Vec<(Binary<'a>, Binary<'a>)> = vec! [];

    for v in vals {
        let mut key = NewBinary::new(env, v.0.len());
        key.copy_from_slice(&v.0);
        let mut value = NewBinary::new(env, v.1.len());
        value.copy_from_slice(&v.1);
        r.push((key.into(), value.into()))
    }
    // The imaginary API call presumedly filled in our binary with meaningful
    // data, so let's return it.
    Ok(r)
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
    [open, get_path, get_column_family],
    load = load
);
