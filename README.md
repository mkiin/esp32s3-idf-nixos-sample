# esp32s3-idf-nixos-sample

NixOS の Nix flake devShell で ESP-IDF（ESP32-S3）をビルドするサンプルです。
Qiita 記事「NixOS と Neovim で ESP32-S3 の ESP-IDF 開発環境を構築する」の題材リポジトリです。

<!-- TODO: 公開後に記事URLを貼る -->

## 前提

- NixOS（flakes 有効）
- direnv + nix-direnv

## 使い方

```bash
cd esp32s3-idf-nixos-sample
direnv allow                          # 初回だけ。devShell が今のシェルに合流する
idf.py set-target esp32s3
idf.py build
idf.py -p /dev/ttyACM0 flash monitor  # ポートは環境に合わせる
```

direnv を使わない場合は `nix develop` で devShell に入ってから、同じ `idf.py ...` を実行してください。

## 構成

- `flake.nix` … ESP-IDF（`esp-idf-xtensa`）を載せた devShell
- `.envrc` … `use flake`（direnv 用）
- `.clangd` … clangd に `compile_commands.json` を読ませ、Xtensa 固有フラグを除去
- `CMakeLists.txt` / `main/` … ESP-IDF プロジェクト本体（hello world）
