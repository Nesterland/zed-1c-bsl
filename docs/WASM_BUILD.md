# Building the WASM Extension for 1C BSL

## Prerequisites

- Rust 1.80+ (`rustup update`)
- wasm32-wasip1 target: `rustup target add wasm32-wasip1`

## Build

```bash
cd zed-1c-bsl
cargo build --target wasm32-wasip1 --release
cp target/wasm32-wasip1/release/zed_1c_bsl.wasm ./1c-bsl.wasm
```

The WASM artifact is ~158K (release, LTO, opt-level=s).

## How It Works

When a `.bsl`/`.osl` file is opened, Zed calls `language_server_command("bsl", worktree)`, which:

1. **Finds Java:**
   - Checks `JAVA_HOME/bin/java` (or `java.exe` on Windows)
   - Fallback: plain `java` (Zed resolves via PATH)

2. **Downloads BSL Language Server:**
   - Cache: `~/.cache/zed/bsl-language-server/bsl-language-server.jar`
   - If missing — fetches the latest release from `1c-syntax/bsl-language-server` (GitHub Releases)

3. **Launches the LSP:**
   ```
   java -Xmx2g -jar bsl-language-server.jar
   ```

## File Layout

| File | Purpose |
|------|---------|
| `Cargo.toml` | Manifest: `cdylib`, `zed_extension_api = "0.7.0"` |
| `src/lib.rs` | `Extension` trait implementation |
| `1c-bsl.wasm` | Compiled WASM (~158K) |
| `extension.toml` | `wasm = true` in `[language_servers.bsl]` |

## User Requirements

- **Java 17+** (JRE or JDK)
- `JAVA_HOME` set **or** `java` in PATH
- Internet access on first run (JAR download → cached thereafter)

## Debugging

If the LSP doesn't start:

1. Check `zed: open log` → search for `language_server_command` and `bsl`
2. Verify Java: `java -version`
3. Check the JAR cache: `ls ~/.cache/zed/bsl-language-server/`
4. Clear the cache to force re-download: `rm ~/.cache/zed/bsl-language-server/bsl-language-server.jar`

## API Compatibility

Built against `zed_extension_api = "0.7.0"` (crates.io).  
Compatible with Zed 0.163+.
