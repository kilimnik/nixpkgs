{ lib
, stdenv
, mkYarnPackage
, fetchFromGitHub
, fetchYarnDeps
}:

let
  os = if stdenv.isDarwin then "osx" else "linux";
  offlineCacheHash = {
    linux = "sha256-xVpObAJEsHVS0+bvasQZ97PRRUdtvXpiV03qt29tz8c=";
    osx = "sha256-bHc1FjvKDTL5apJqgXv7zk1z1WF68B3T7ibV7ZX3DWM=";
  }.${os};
in
mkYarnPackage rec {
  pname = "element-call";
  version = "0.5.15";

  src = fetchFromGitHub {
    owner = "element-hq";
    repo = "element-call";
    rev = "v${version}";
    hash = "sha256-2RGzbbdlDj497YFRdppegW1P9O2H4mQ5vfhZEcfMRkc=";
  };

  packageJSON = ./package.json;

  prePatch = ''
    patch -i ${./name.patch}
  '';

  offlineCache = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    hash = offlineCacheHash;
  };

  buildPhase = ''
    runHook preBuild
    yarn --offline run build
    runHook postBuild
  '';

  preInstall = ''
    mkdir $out
    cp -R ./deps/element-call/dist $out
  '';

  doDist = false;

  meta = with lib; {
    homepage = "https://github.com/element-hq/element-call";
    description = "Group calls powered by Matrix";
    license = licenses.asl20;
    maintainers = with maintainers; [ kilimnik ];
    mainProgram = "element-call";
  };
}
