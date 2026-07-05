{
  description = "ESP32-S3 ESP-IDF development shell";

  inputs = {
    # esp-dev の overlay は最新 nixos-unstable / 26.05 では python310 が削除済みで
    # 壊れるため、python310 が残る安定版 (25.11) に固定する。
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-esp-dev = {
      url = "github:mirrexagon/nixpkgs-esp-dev";
      # esp-idf を「この flake の nixpkgs」でビルドさせ、nixpkgs を 1 本化する。
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, nixpkgs-esp-dev, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        # esptool 依存の python ecdsa は CVE-2024-23342 で insecure 指定。
        # 手元のファーム署名/書き込み用途ではリスクが実質無いため許可する。
        config.permittedInsecurePackages = [
          "python3.13-ecdsa-0.19.1"
        ];
        overlays = [ nixpkgs-esp-dev.overlays.default ];
      };
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        name = "esp32s3-idf-dev";
        buildInputs = [ pkgs.esp-idf-xtensa ];
      };
    };
}
