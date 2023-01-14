{
  description = "A Python-based web service to print labels on Brother QL label printers";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }: 
    flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
      python = pkgs.python3.withPackages (ps: with ps; [
        bottle
        jinja2
        brother-ql
      ]);
      src = ./.;
    in
      rec {
        packages = flake-utils.lib.flattenTree {
          brother_ql_web = pkgs.writeShellScriptBin "helloWorld" ''
            ${python}/bin/python3 ${src}/brother_ql_web.py $@
            '';
        };
        defaultPackage = packages.hello;
        apps.brother_ql_web = flake-utils.lib.mkApp { drv = packages.brother_ql_web; };
        apps.default = apps.brother_ql_web;
      }
    );
}
