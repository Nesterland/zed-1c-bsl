# BSL Language Server Setup in Zed

The **1C BSL** extension supports autocompletion, diagnostics, navigation, and more via the **BSL Language Server** (LSP implementation for 1C:Enterprise and OneScript).

> **Note:** The WASM extension (v0.1.0) can auto-download and launch the LSP. Manual setup below is a fallback.

## 1. Install BSL Language Server

Download the JAR from [GitHub Releases](https://github.com/1c-syntax/bsl-language-server/releases):

```bash
wget https://github.com/1c-syntax/bsl-language-server/releases/download/v0.9.0/bsl-language-server.jar \
  -O ~/bin/bsl-language-server.jar
```

**Requirements:** Java 17+ (JRE or JDK).

## 2. Zed Configuration (Manual, fallback)

Add to `settings.json` (Zed → Open Settings):

```json
{
  "lsp": {
    "bsl": {
      "binary": {
        "path": "java",
        "arguments": [
          "-Xmx2g",
          "-jar",
          "bsl-language-server.jar"
        ]
      }
    }
  }
}
```

Use an **absolute path** to the JAR if not in the working directory:

```json
{
  "lsp": {
    "bsl": {
      "binary": {
        "path": "java",
        "arguments": [
          "-Xmx2g",
          "-jar",
          "/home/user/bin/bsl-language-server.jar"
        ]
      }
    }
  }
}
```

## 3. Project Configuration (Optional)

Create `.bsl-language-server.json` in the project root:

```json
{
  "language": "en",
  "diagnostics": {
    "lineLength": {
      "maxLineLength": 140
    }
  }
}
```

Details: https://1c-syntax.github.io/bsl-language-server/configuration

## 4. Verification

1. Open any `.bsl` file in your project
2. The status bar should show a BSL LSP indicator
3. `Ctrl+Shift+I` (View → LSP Log) — check for errors
4. Hover over a procedure name — hover info should appear

## 5. Features

- ✔ Diagnostics (errors, warnings)
- ✔ Autocompletion (global context functions, procedures)
- ✔ Hover information
- ✔ Go to Definition
- ✔ Find References
- ✔ Rename
- ✔ Code Actions (quick fixes)
- ✔ Semantic Tokens
- ✔ Folding
- ✔ Inlay Hints

## 6. Troubleshooting

| Issue | Solution |
|-------|----------|
| Java not found | Ensure `java` is in PATH: `java -version` |
| Out of memory | Increase `-Xmx2g` → `-Xmx4g` |
| LSP won't connect | Check logs: `Ctrl+Shift+I` → LSP Log |
| JAR download failed | Check URL and GitHub access |
| LSP won't start | Run manually: `java -jar bsl-language-server.jar --lsp` |
