{ pkgs }:

with pkgs;
let shared-packages = import ../shared/packages.nix { inherit pkgs; }; in
shared-packages ++ [
  dockutil
  lazygit
  zsh-autosuggestions
  gh
  presenterm
  devenv
  direnv
  helix
  git
  nodejs
  just
  k6
  tokei
  go
  elixir
  (with dotnetCorePackages; combinePackages [
      sdk_8_0
      sdk_9_0
    ])
]
