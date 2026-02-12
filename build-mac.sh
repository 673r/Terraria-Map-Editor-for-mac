#!/bin/bash
set -e

# TEdit5 Avalonia - macOS Build Script
RELEASE_PATH="${1:-./release}"
VERSION_PREFIX="${2:-5.0.0}"
VERSION_SUFFIX="${3:-}"
PUBLISH_PATH="publish/avalonia"

# Detect architecture
ARCH=$(uname -m)
if [ "$ARCH" = "arm64" ]; then
    PLATFORM="osx-arm64"
else
    PLATFORM="osx-x64"
fi

echo "=========================================="
echo " TEdit5 macOS Build"
echo " Platform: $PLATFORM"
echo " Version:  $VERSION_PREFIX${VERSION_SUFFIX:+-$VERSION_SUFFIX}"
echo "=========================================="

# Find dotnet
if command -v dotnet &> /dev/null; then
    DOTNET_CMD="dotnet"
elif [ -f "/usr/local/share/dotnet/dotnet" ]; then
    DOTNET_CMD="/usr/local/share/dotnet/dotnet"
    export DOTNET_ROOT="/usr/local/share/dotnet"
else
    echo "ERROR: .NET SDK not found. Install .NET 10 SDK first."
    exit 1
fi

echo "Using dotnet: $($DOTNET_CMD --version)"

# Clean previous builds
rm -rf "./$PUBLISH_PATH/$PLATFORM"
mkdir -p "$RELEASE_PATH"

# Build args
BUILD_ARGS=(
    "publish"
    "-c" "Release"
    "-r" "$PLATFORM"
    "--self-contained" "true"
    "-p:PublishSingleFile=true"
    "-o" "./$PUBLISH_PATH/$PLATFORM"
    "/p:VersionPrefix=$VERSION_PREFIX"
)

if [ -n "$VERSION_SUFFIX" ]; then
    BUILD_ARGS+=("--version-suffix" "$VERSION_SUFFIX")
fi

BUILD_ARGS+=("./src/TEdit5/TEdit5.csproj")

echo ""
echo "Building TEdit5 for $PLATFORM..."
$DOTNET_CMD "${BUILD_ARGS[@]}"

# Copy schematics if they exist
if [ -d "./schematics" ]; then
    cp -r ./schematics "./$PUBLISH_PATH/$PLATFORM/"
fi

# Create .app bundle
APP_NAME="TEdit5.app"
APP_DIR="$RELEASE_PATH/$APP_NAME"
CONTENTS_DIR="$APP_DIR/Contents"
MACOS_DIR="$CONTENTS_DIR/MacOS"
RESOURCES_DIR="$CONTENTS_DIR/Resources"

echo ""
echo "Creating macOS .app bundle..."

rm -rf "$APP_DIR"
mkdir -p "$MACOS_DIR"
mkdir -p "$RESOURCES_DIR"

# Copy published files to MacOS directory
cp -r "./$PUBLISH_PATH/$PLATFORM/"* "$MACOS_DIR/"

# Make executable
chmod +x "$MACOS_DIR/TEdit5"

# Create Info.plist
cat > "$CONTENTS_DIR/Info.plist" << 'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleName</key>
    <string>TEdit5</string>
    <key>CFBundleDisplayName</key>
    <string>TEdit - Terraria Map Editor</string>
    <key>CFBundleIdentifier</key>
    <string>com.tedit.terraria-map-editor</string>
    <key>CFBundleVersion</key>
    <string>VERSION_PLACEHOLDER</string>
    <key>CFBundleShortVersionString</key>
    <string>VERSION_PLACEHOLDER</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleExecutable</key>
    <string>TEdit5</string>
    <key>CFBundleIconFile</key>
    <string>tedit</string>
    <key>LSMinimumSystemVersion</key>
    <string>12.0</string>
    <key>NSHighResolutionCapable</key>
    <true/>
    <key>NSSupportsAutomaticGraphicsSwitching</key>
    <true/>
    <key>CFBundleDocumentTypes</key>
    <array>
        <dict>
            <key>CFBundleTypeName</key>
            <string>Terraria World</string>
            <key>CFBundleTypeExtensions</key>
            <array>
                <string>wld</string>
            </array>
            <key>CFBundleTypeRole</key>
            <string>Editor</string>
        </dict>
    </array>
</dict>
</plist>
PLIST

# Replace version placeholder
FULL_VERSION="$VERSION_PREFIX${VERSION_SUFFIX:+.$VERSION_SUFFIX}"
sed -i '' "s/VERSION_PLACEHOLDER/$FULL_VERSION/g" "$CONTENTS_DIR/Info.plist"

# Also create a zip archive
echo ""
echo "Creating zip archive..."
ZIP_NAME="TEdit5-${VERSION_PREFIX}${VERSION_SUFFIX:+-$VERSION_SUFFIX}-${PLATFORM}"
(cd "$RELEASE_PATH" && zip -r -q "${ZIP_NAME}.zip" "$APP_NAME")

echo ""
echo "=========================================="
echo " Build Complete!"
echo " .app bundle: $APP_DIR"
echo " ZIP archive: $RELEASE_PATH/${ZIP_NAME}.zip"
echo "=========================================="
