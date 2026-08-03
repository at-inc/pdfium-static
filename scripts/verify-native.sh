#!/usr/bin/env bash
# Verify a native (non-WASM) static PDFium library.
# Usage: verify-native.sh <lib_path> <target_os> <target_cpu>
set -euo pipefail

LIB_PATH="$1"
TARGET_OS="$2"
TARGET_CPU="$3"

test -f "$LIB_PATH" || { echo "ERROR: $LIB_PATH not found"; exit 1; }
echo "Library size: $(wc -c < "$LIB_PATH") bytes"

if [ "$TARGET_OS" = "win" ]; then
  DUMPBIN=$(find "/c/Program Files/Microsoft Visual Studio" -name dumpbin.exe -path "*/Hostx64/x64/*" 2>/dev/null | head -1)
  [ -n "$DUMPBIN" ] || { echo "ERROR: dumpbin.exe not found"; exit 1; }
  "$DUMPBIN" //symbols "$LIB_PATH" | grep FPDF_InitLibrary || { echo "ERROR: symbol not found"; exit 1; }
else
  nm "$LIB_PATH" | grep "T _\?FPDF_InitLibrary$" || { echo "ERROR: symbol not found"; exit 1; }
fi

if [ "$TARGET_OS" = "mac" ]; then
  case "$TARGET_CPU" in
    arm64) EXPECTED_ARCH="arm64" ;;
    x64) EXPECTED_ARCH="x86_64" ;;
    *) echo "ERROR: unsupported macOS CPU: $TARGET_CPU"; exit 1 ;;
  esac

  lipo -archs "$LIB_PATH" | tr ' ' '\n' | grep -Fx "$EXPECTED_ARCH" || {
    echo "ERROR: expected macOS architecture $EXPECTED_ARCH not found"
    exit 1
  }
fi

echo "Static library verified OK"
