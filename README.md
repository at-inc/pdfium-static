# pdfium-static

Static PDFium libraries for macOS (Apple Silicon and Intel), Linux, Windows and WebAssembly.

Built from [pdfium.googlesource.com](https://pdfium.googlesource.com/pdfium/) via GitHub Actions.

## Download

Go to [Releases](../../releases) and download the `.a` / `.lib` for your platform.

Each release is tagged with the chromium branch number (e.g. `chromium/7543`).

## Build a new version

1. Go to **Actions** > **Build PDFium**
2. Click **Run workflow**
3. Enter the chromium branch number (e.g. `7543`)
4. Choose `all` or one platform to build
5. Wait for the build to complete
6. A release is created or updated with the selected static libraries

Available build targets are `macos-arm64`, `macos-x64`, `linux-x64`, `windows-x64` and `wasm`.

## Usage with pdfium-render (Rust)

Match the `pdfium_XXXX` feature flag to the branch number:

```toml
# For chromium/7543
pdfium-render = { version = "0.8", features = ["static", "pdfium_7543"] }
```

## Build config

Libraries are built with:

- No V8 JavaScript engine
- No XFA support
- Complete static library (`pdf_is_complete_lib = true`)
- Release mode, no debug symbols

The WASM build additionally patches PDFium's build system to support Emscripten as a target (see `scripts/patch-wasm.py`).
