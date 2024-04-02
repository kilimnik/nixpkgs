{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "lk-jwt-service";
  # No releases yet, so we use the latest commit
  version = "d64476283494c4f13a960c890a258fe5b1a0979f";

  src = fetchFromGitHub {
    owner = "element-hq";
    repo = "lk-jwt-service";
    rev = version;
    hash = "sha256-Xz9rcsl6kLChnladjE/+7yK22iKyFvTzu6D6b9y5v0M=";
  };

  vendorHash = "sha256-9qOApmmOW+N1L/9hj9tVy0hLIUI36WL2TGWUcM3ajeM=";

  postInstall = ''
    mv $out/bin/ec-lms $out/bin/lk-jwt-service
  '';

  meta = with lib; {
    description = "Minimal service to provide LiveKit JWTs using Matrix OpenID Connect";
    homepage = "https://github.com/element-hq/lk-jwt-service";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ kilimnik ];
    mainProgram = "lk-jwt-service";
  };
}
