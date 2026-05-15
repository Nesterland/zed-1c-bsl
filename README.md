# 1C BSL for Zed

Zed IDE extension with syntax highlighting for 1C:Enterprise BSL, OneScript, and 1C SDBL query language.

Repository: https://github.com/Nesterland/zed-1c-bsl

**Version:** 0.1.0 | **Status:** 🚧 In development (WASM ready, needs Zed testing)

## Features

- **BSL files:** `.bsl`, `.osl` — full syntax highlighting
- **SDBL files:** `.sdbl` — query language highlighting
- **Embedded queries:** SDBL highlighting inside BSL strings starting with `ВЫБРАТЬ`/`SELECT`/`УНИЧТОЖИТЬ`/`DROP`
- **Auto-indentation:** procedures, functions, conditions, loops, try/except, preprocessor regions
- **Snippets:** ~40 snippets (procedures, functions, if/else, loops, try/except, regions)
- **Outline & text objects:** document structure, block navigation
- **Bracket matching:** `()`, `[]`, `""`
- **LSP integration:** diagnostics, autocompletion, hover, go-to-def, find-references, rename via [BSL Language Server](https://github.com/1c-syntax/bsl-language-server)
- **WASM auto-start (v0.1.0):** automatic Java detection + JAR download + LSP launch — no manual setup

> **Note:** For `#Region ... #EndRegion` folding, ensure the region body is indented. Auto-indent handles this on newline.

## Quick Start

1. Install the extension from the Zed Extensions catalog (or `Install Dev Extension` for local)
2. Open any `.bsl` or `.osl` file
3. **v0.1.0:** The WASM extension auto-finds Java, downloads `bsl-language-server.jar`, and launches LSP
4. Diagnostics, autocompletion, and navigation work out of the box

**Requirements:** Java 17+ (JRE/JDK). Set `JAVA_HOME` or have `java` in PATH.

## Project Structure

```
zed-1c-bsl/
  extension.toml              # Manifest + LSP + WASM declaration
  Cargo.toml                  # Rust WASM project
  src/lib.rs                  # Extension trait implementation
  1c-bsl.wasm                 # Compiled WASM (~158K)
  LICENSE                     # MIT
  README.md
  CHANGELOG.md
  languages/
    bsl/
      config.toml
      highlights.scm          # BSL highlighting rules
      injections.scm          # SDBL injection into BSL strings
      brackets.scm            # Bracket pairs
      indents.scm             # Auto-indentation
      outline.scm             # Document outline
      textobjects.scm         # Text objects
    sdbl/
      config.toml
      highlights.scm
    sdbl-embedded/
      config.toml
      highlights.scm
  snippets/
    bsl.json                  # ~40 snippets
  examples/
    basic.bsl
    basic_1.bsl
    query.sdbl
  docs/
    LSP_SETUP.md              # LSP setup guide (manual fallback)
    WASM_BUILD.md             # WASM build instructions
  .bsl-language-server.json   # LSP configuration template
  grammars/                   # Tree-sitter grammars (submodule)
```

## Installation (Development)

1. Install Rust: `rustup update`
2. Add WASM target: `rustup target add wasm32-wasip1`
3. Build WASM: `cargo build --target wasm32-wasip1 --release`
4. Copy artifact: `cp target/wasm32-wasip1/release/zed_1c_bsl.wasm ./1c-bsl.wasm`
5. Open Zed → Extensions → `Install Dev Extension` → select this folder
6. Open `examples/basic.bsl` to test

## Grammar

Tree-sitter grammar: https://github.com/alkoleft/tree-sitter-bsl (rev pinned in `extension.toml`).

## Publishing

1. Push to https://github.com/Nesterland/zed-1c-bsl
2. Fork https://github.com/zed-industries/extensions
3. Add submodule + `extensions.toml` entry
4. Open PR into `zed-industries/extensions`

## License

MIT. See `LICENSE`.
