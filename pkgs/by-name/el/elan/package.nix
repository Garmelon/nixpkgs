{
  stdenv,
  lib,
  makeWrapper,
  pkg-config,
  curl,
  openssl,
  zlib,
  fetchFromGitHub,
  rustPlatform,
  libiconv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "elan";
  version = "4.2.1";

  src = fetchFromGitHub {
    owner = "leanprover";
    repo = "elan";
    rev = "v${finalAttrs.version}";
    hash = "sha256-NSgzAYQjsf3lwYOiuJbkLJGRZ7rY2FEOjPORXNhjWuU=";
  };

  cargoHash = "sha256-JzyDVFp1lGPk1IK6CLQMBcJi5yCVD9x1iXtN0wlOF3g=";

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  env.OPENSSL_NO_VENDOR = 1;
  buildInputs = [
    curl
    zlib
    openssl
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin libiconv;

  buildFeatures = [ "no-self-update" ];

  postInstall = ''
    pushd $out/bin
    mv elan-init elan
    for link in lean leanpkg leanchecker leanc leanmake lake; do
      ln -s elan $link
    done
    popd

    # tries to create .elan
    export HOME=$(mktemp -d)
    mkdir -p "$out/share/"{bash-completion/completions,fish/vendor_completions.d,zsh/site-functions}
    $out/bin/elan completions bash > "$out/share/bash-completion/completions/elan"
    $out/bin/elan completions fish > "$out/share/fish/vendor_completions.d/elan.fish"
    $out/bin/elan completions zsh >  "$out/share/zsh/site-functions/_elan"
  '';

  meta = {
    description = "Small tool to manage your installations of the Lean theorem prover";
    homepage = "https://github.com/leanprover/elan";
    changelog = "https://github.com/leanprover/elan/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = [ ];
    mainProgram = "elan";
  };
})
