# Terraria Map Editor - BinaryConstruct

[![Build status](https://ci.appveyor.com/api/projects/status/xi3k3j54un10a0o4?svg=true)](https://ci.appveyor.com/project/BinaryConstruct/terraria-map-editor) [![GitHub Version](https://img.shields.io/github/tag/TEdit/Terraria-Map-Editor.svg?label=GitHub)](https://github.com/TEdit/Terraria-Map-Editor) [![CodeFactor](https://www.codefactor.io/repository/github/tedit/terraria-map-editor/badge)](https://www.codefactor.io/repository/github/tedit/terraria-map-editor)

![tedit](https://github.com/TEdit/Terraria-Map-Editor/blob/main/docs/images/te-logo.png)

TEdit - Terraria Map Editor is a stand alone, open source map editor for Terraria. It lets you edit maps just like (almost) paint!

## Important Links

- [TEdit Documentation](https://docs.binaryconstruct.com/)
- [Join us on Discord](https://discord.gg/xHcHd7mfpn)
- [Homepage](http://binaryconstruct.com/)

## Download

- [Source](http://github.com/TEdit/Terraria-Map-Editor)
- [Download](http://www.binaryconstruct.com/downloads/) 
- [GitHub Releases](https://github.com/TEdit/Terraria-Map-Editor/releases)
- [Change Log](http://github.com/TEdit/Terraria-Map-Editor/commits/master)

## Building on macOS

TEdit5 uses [Avalonia UI](https://avaloniaui.net/) and runs natively on macOS (both Apple Silicon and Intel).

### Prerequisites
- [.NET 10 SDK](https://dotnet.microsoft.com/download/dotnet/10.0) or later

### Build & Run
```bash
# Make the build script executable (first time only)
chmod +x build-mac.sh

# Build and create .app bundle
./build-mac.sh

# The .app bundle will be at: ./release/TEdit5.app
# Open it
open ./release/TEdit5.app
```

The script auto-detects your architecture (arm64/x64), builds a self-contained single-file binary, and packages it as a macOS `.app` bundle.

### Manual Build (without script)
```bash
dotnet publish -c Release -r osx-arm64 --self-contained true -p:PublishSingleFile=true -o ./publish/avalonia/osx-arm64 ./src/TEdit5/TEdit5.csproj
```

## Support

Do you enjoy TEdit, and would you like to show your support? Every donation is appreciated and helps keep development going, servers online and ad free. Thank you for considering becoming a patron. [Patreon](https://www.patreon.com/join/BinaryConstruct)
