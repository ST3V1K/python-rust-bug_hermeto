# Reproducer for hermetoproject/hermeto#1097

## The Bug

When a repository contains both:
1. A **Rust** project (cargo)
2. A **Python** project with dependencies that have **Rust extensions** (e.g. `cryptography`)

Hermeto generates two conflicting `.cargo/config.toml` files that both point to the
same `${output_dir}/deps/cargo` directory but use different source names:

**For the Rust project** (`rust-crate/.cargo/config.toml`):
```toml
[source.crates-io]
replace-with = "vendored-sources"

[source.vendored-sources]
directory = "${output_dir}/deps/cargo"
```

**For Python's Rust extensions** (`${output_dir}/.cargo/config.toml`):
```toml
[source.crates-io]
replace-with = "local"

[source.local]
directory = "${output_dir}/deps/cargo"
```

Cargo refuses to build because the same directory is defined by two different source
names:

```
error: source `local` defines source dir /output/deps/cargo, but that source is already
       defined by `vendored-sources`
      note: Sources are not allowed to be defined multiple times.
```

## How to Reproduce

```shell
hermeto fetch-deps \
  --source ~/Documents/python-rust-bug \
  --output /tmp/hermeto-output \
  '[{"type": "cargo", "path": "rust-crate"}, {"type": "pip", "path": "python-app"}]'
```

## Project Structure

```
python-rust-bug/
├── rust-crate/          # Rust project processed by cargo package manager
│   ├── Cargo.toml
│   ├── Cargo.lock
│   └── src/main.rs
└── python-app/          # Python project with Rust-extension dependency (cryptography)
    ├── requirements.txt
    └── app.py
```
