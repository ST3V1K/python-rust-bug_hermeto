#!/usr/bin/env bash
set -euo pipefail

SOURCE_DIR="$(pwd)"
OUTPUT_DIR="$(pwd)/hermeto-output"

# Step 1: Fetch dependencies for both cargo and pip packages
rm -rf "$OUTPUT_DIR"
hermeto fetch-deps \
    --source "$SOURCE_DIR" \
    --output "$OUTPUT_DIR" \
    '[{"type": "cargo", "path": "rust-crate"}, {"type": "pip", "path": "python-app"}]'

# Step 2: Inject the project files hermeto generated (writes .cargo/config.toml files)
hermeto inject-files --from-output-dir "$OUTPUT_DIR"

# Step 3: Generate and source the environment variables (sets CARGO_HOME, etc.)
hermeto generate-env --from-output-dir "$OUTPUT_DIR" --output "$OUTPUT_DIR/hermeto.env" -f env
set -a
source "$OUTPUT_DIR/hermeto.env"
set +a

# Step 4: Try to build the Rust crate — this triggers the cargo config conflict
echo ""
echo "=== Attempting cargo build (this should fail) ==="
echo ""
cd rust-crate
cargo build 2>&1
