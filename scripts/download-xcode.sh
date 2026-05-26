#!/usr/bin/env bash
# Downloads and installs a specific Xcode version directly from Apple's
# developer portal without going through the Mac App Store.
#
# Requirements:
#   - Apple Developer credentials (APPLE_ID and APPLE_ID_PASSWORD env vars)
#   - macOS with Homebrew available
#
# Usage:
#   ./scripts/download-xcode.sh [XCODE_VERSION]
#
# Examples:
#   ./scripts/download-xcode.sh 16.2
#   ./scripts/download-xcode.sh 15.4
#   XCODE_VERSION=16.2 ./scripts/download-xcode.sh

set -euo pipefail

XCODE_VERSION="${1:-${XCODE_VERSION:-}}"

if [[ -z "$XCODE_VERSION" ]]; then
  echo "Error: Xcode version required." >&2
  echo "Usage: $0 <version>  (e.g. $0 16.2)" >&2
  exit 1
fi

if [[ -z "${APPLE_ID:-}" || -z "${APPLE_ID_PASSWORD:-}" ]]; then
  echo "Error: APPLE_ID and APPLE_ID_PASSWORD environment variables must be set." >&2
  exit 1
fi

# Install xcodes if not present
if ! command -v xcodes &>/dev/null; then
  echo "Installing xcodes..."
  brew install xcodesorg/made/xcodes
fi

# Install aria2 for faster parallel downloads (xcodes uses it automatically)
if ! command -v aria2c &>/dev/null; then
  echo "Installing aria2..."
  brew install aria2
fi

echo "Downloading Xcode $XCODE_VERSION..."
xcodes install "$XCODE_VERSION" --experimental-unxip

echo "Selecting Xcode $XCODE_VERSION..."
xcodes select "$XCODE_VERSION"

echo "Active Xcode:"
xcode-select -p
xcodebuild -version
