# Changelog

## [0.1.0] — Unreleased

### Added
- **WASM extension** — auto-detects Java, downloads `bsl-language-server.jar` from GitHub Releases, and launches LSP with zero manual configuration
  - `Cargo.toml` + `src/lib.rs` — full `Extension` trait implementation
  - `1c-bsl.wasm` — compiled artifact (~158K)
  - `extension.toml` — `wasm = true` for `[language_servers.bsl]`
- `docs/WASM_BUILD.md` — build instructions (EN)
- All documentation (`README.md`, `docs/LSP_SETUP.md`) translated to English

### Changed
- `languages/bsl/injections.scm` — regex simplified with `(?i)`, 4 alternatives instead of 8; fully documented

### Fixed
- `highlights.scm` — removed reference to hidden node `_var_definition_variables` that broke syntax highlighting entirely

## [0.0.3] — 2025-01-20

### Added
- `indents.scm` — auto-indentation for BSL (procedures, functions, conditions, loops, try/except, preprocessor, brackets, multiline expressions, Else/ElseIf)
- `[language_servers.bsl]` in `extension.toml` — LSP declaration
- `languages/bsl/config.toml` — linked BSL language with LSP server
- `docs/LSP_SETUP.md` — step-by-step LSP setup guide
- `.bsl-language-server.json` — configuration template
- `PLAN.md`, `TZ.md` — development roadmap and technical specification

### Changed
- `highlights.scm` — detailed scopes: `@keyword.control`, `@keyword.operator`, `@storage.modifier`, `@keyword.directive`, `@function.builtin`, `@variable.builtin`, `@variable.parameter`, `@label`, `@namespace`, `@attribute`
- `sdbl/highlights.scm` — detailed scopes for SDBL keywords
- `sdbl-embedded/highlights.scm` — synced with SDBL

## [0.0.2] — 2025-01-20

### Added
- `indents.scm` v0.0.2 — auto-indentation (procedures, functions, conditions, loops, exceptions, preprocessor)
- Detailed BSL/SDBL syntax highlighting scopes (Phase 1)
- ~40 snippets (Phase 2)
- `.cursorrules`, `AGENTS.md` — AI assistant context

## [0.0.1] — 2025-01-19

### Added
- Initial release
- Support for `.bsl`, `.osl`, `.sdbl` files
- Tree-sitter highlighting for BSL/SDBL
- SDBL injection into BSL strings
- Snippets, outline, text objects
