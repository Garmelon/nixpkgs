{
  stdenv,
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  which,
}:

buildGoModule (finalAttrs: {
  pname = "landrun";
  version = "0.1.15-main";

  src = fetchFromGitHub {
    owner = "Zouuup";
    repo = "landrun";
    rev = "5ed4a3db3a4ad930d577215c6b9abaa19df7f99f"; # main
    hash = "sha256-4DDVRUCTZLn6o7dGEz4vRX8wwauz1zkpTda0IFMH4F8=";
  };

  postPatch = ''
    substituteInPlace cmd/landrun/main.go \
      --replace-fail 'const Version = "0.1.15"' 'const Version = "0.1.15-main"'
  '';

  vendorHash = "sha256-Bs5b5w0mQj1MyT2ctJ7V38Dy60moB36+T8TFH38FA08=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
    which
  ];

  meta = {
    description = "Lightweight, secure sandbox for running Linux processes using Landlock LSM";
    mainProgram = "landrun";
    longDescription = ''
      Landrun is designed to make it practical to sandbox any command with fine-grained filesystem
      and network access controls, without root/containers/SELinux/AppArmor.

      It's lightweight, auditable, and wraps Landlock v5 features.

      Linux 5.13+ is required for file access restrictions, Linux 6.7+ for TCP restrictions.
    '';
    homepage = "https://github.com/Zouuup/landrun";
    changelog = "https://github.com/Zouuup/landrun/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.fliegendewurst ];
    platforms = lib.platforms.linux;
  };
})
