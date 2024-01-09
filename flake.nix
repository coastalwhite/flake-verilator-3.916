{
    description = "Verilator v3.916";
    
    inputs = {
        nixpkgs.url = "nixpkgs/7b9448665e4be84c3f97becded3676e150f94694";
        flake-utils.url = "github:numtide/flake-utils";
    
        verilator-src = {
            url = "https://github.com/verilator/verilator/archive/refs/tags/v3.916.tar.gz";
            flake = false;
        };
    };
    
    outputs = { self, nixpkgs, flake-utils, verilator-src }: 
        flake-utils.lib.eachDefaultSystem (system:
          let pkgs = nixpkgs.legacyPackages.${system}; in
          {
              packages = rec {
                  default = pkgs.stdenv.mkDerivation {
                      version = "3.916";
                      pname = "verilator";
                      src = verilator-src;

                      buildInputs = with pkgs; [
					  	  libgcc
                          bison
						  gnupatch
                          gnumake
                          flex
                          perl
                      ];
                      configurePhase = ''
                          unset VERILATOR_ROOT
                          ${pkgs.autoconf}/bin/autoconf
                          ./configure --prefix "$out"
                      '';
                      buildPhase = "${pkgs.gnumake}/bin/make";
                  };
              };
        });
}
