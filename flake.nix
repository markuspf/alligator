{
  description = "alligator -- ArangoDB, but in Erlang";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs = { self, nixpkgs, flake-utils, rust-overlay, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs { inherit system overlays; };
        rustVersion = pkgs.rust-bin.stable.latest.default;
        rustPlatform = pkgs.makeRustPlatform {
          cargo = rustVersion;
          rustc = rustVersion;
        };
        myRustBuild = rustPlatform.buildRustPackage {
          pname = "araongorocks-rs";
          version = "0.1.0";
          src = ./.;

          cargoLock.lockFile = ./Cargo.lock;
        };
        dockerImage = pkgs.dockerTools.buildImage {
          name = "graph-rs";
          config = { Cmd = [ "${myRustBuild}/bin/arangorocks-rs" ]; };
        };
      in {
        package = {
          rustPackage = myRustBuild;
          docker = dockerImage;
        };
        defaultPackage = dockerImage;
        devShell = (pkgs.mkShell.override { stdenv = pkgs.llvmPackages_14.stdenv; }) {
          LIBCLANG_PATH = "${pkgs.llvmPackages_14.libclang.lib}/lib";
          buildInputs =
            [ pkgs.pkg-config 
              pkgs.openssl 
	      pkgs.elixir_1_14
	      pkgs.python310
	      pkgs.rust-analyzer
	      pkgs.rustfmt
              (rustVersion.override { extensions = [ "rust-src" ]; }) ];
        };
      });
}
