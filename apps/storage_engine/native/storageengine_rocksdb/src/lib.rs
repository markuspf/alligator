use rustler::{Env, NifStruct, Term};

use rustler::resource::ResourceArc;

// use ArangoRocks;
use rocksdb::DB;

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
fn open(path : String) -> DBResource {
   let db = DB::open_default(path.clone()).unwrap();

    db.put(b"my key", b"my value").unwrap();
   match db.get(b"my key") {
       Ok(Some(value)) => println!("retrieved value {}", String::from_utf8(value).unwrap()),
       Ok(None) => println!("value not found"),
       Err(e) => println!("operational problem encountered: {}", e),
   }
   db.delete(b"my key").unwrap();


    DBResource {
        reference: ResourceArc::new(MyDB {
            path: path.clone(),
            db: db         })
    }
}

#[rustler::nif]
fn get_path(res : DBResource) -> String {
    res.reference.path.clone()
}

#[rustler::nif]
fn put(res: DBResource, key: String, value: String) -> () {
    res.reference.db.put(key, value).unwrap();
}

#[rustler::nif]
fn get(res: DBResource, key: String) -> Result<String, String> {
    match res.reference.db.get(key) {
        Ok(Some(value)) => Ok(String::from_utf8(value).unwrap()),
        Ok(None) => Err("not found".to_string()),
        Err(e) => Err("penis".to_string())
    }
}

fn load(env: Env, _: Term) -> bool {
    rustler::resource!(MyDB, env);
    true
}

rustler::init!("Elixir.StorageEngine.RocksDB", [open, get_path, put, get], load = load);
