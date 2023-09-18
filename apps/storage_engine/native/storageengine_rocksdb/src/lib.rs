

use rustler::{Atom, Error, Term};

use ArangoRocks;

mod atoms {
    rustler::atoms! {
        ok,
        error,
    banana}
}

#[rustler::nif]
fn add(a: i64, b: i64) -> i64 {
    a + b
}

#[rustler::nif]
fn foobar(a: i64) -> i64 {
    ArangoRocks::foo() * a
}

#[rustler::nif]
fn open<'a>() -> Atom {
    atoms::banana()
}



rustler::init!("Elixir.StorageEngine.RocksDB", [add, foobar, open]);
