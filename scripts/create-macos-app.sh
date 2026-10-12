#!/bin/bash
set -euo pipefail

# macOS app bundler for yhcodex
# 用法: ./scripts/create-macos-app.sh [binary_path] [output_dir]

BINARY_PATH="${1:-.}"
OUTPUT_DIR="${2:-.}"

# 查找编译出的 yhcodex 二进制
if [[ -f "$BINARY_PATH/target/release/yhcodex" ]]; then
    BINARY="$BINARY_PATH/target/release/yhcodex"
elif [[ -f "$BINARY_PATH" ]]; then
    BINARY="$BINARY_PATH"
else
    echo "Error: Cannot find yhcodex binary at $BINARY_PATH"
    exit 1
fi

# App bundle 结构
APP_NAME="yhcodex.app"
APP_PATH="$OUTPUT_DIR/$APP_NAME"
CONTENTS_PATH="$APP_PATH/Contents"
MACOS_PATH="$CONTENTS_PATH/MacOS"
RESOURCES_PATH="$CONTENTS_PATH/Resources"

echo "Creating macOS app bundle at $APP_PATH..."

# 创建目录结构
mkdir -p "$MACOS_PATH"
mkdir -p "$RESOURCES_PATH"

# 复制二进制
cp "$BINARY" "$MACOS_PATH/yhcodex"
chmod +x "$MACOS_PATH/yhcodex"

# 创建 Info.plist
cat > "$CONTENTS_PATH/Info.plist" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleDisplayName</key>
    <string>YHCodex</string>
    <key>CFBundleExecutable</key>
    <string>yhcodex</string>
    <key>CFBundleIdentifier</key>
    <string>com.local.yhcodex</string>
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
    <key>CFBundleName</key>
    <string>YHCodex</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0</string>
    <key>CFBundleVersion</key>
    <string>1.0.0</string>
    <key>LSMinimumSystemVersion</key>
    <string>11.0</string>
    <key>NSHighResolutionCapable</key>
    <true/>
</dict>
</plist>
EOF

echo "✅ App bundle created successfully at: $APP_PATH"
echo ""
echo "Next steps:"
echo "1. To sign the app (optional, for local testing):"
echo "   codesign --force --sign - '$APP_PATH'"
echo ""
echo "2. To run the app:"
echo "   open '$APP_PATH'"
echo ""
echo "3. Or access the binary directly:"
echo "   '$MACOS_PATH/yhcodex' --help"
