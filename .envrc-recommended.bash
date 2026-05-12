source_url \
  'https://raw.githubusercontent.com/bigolu/system-configurations/refs/heads/master/direnv/plugins/direnv-manual-reload.bash' \
  'sha256-A/bOJRYyd8fJpR5Djb0oU28ZyWF497EwyrgZzMW6qkY='
direnv_manual_reload

source_url \
  'https://raw.githubusercontent.com/bigolu/system-configurations/refs/heads/master/direnv/plugins/devshell-direnv.bash' \
  'sha256-+qXct2GDcvQ/LONqktYMOvG3v8Re/wPGpKUJGmzAivI='
DEVSHELL_DIRENV_FALLBACK=true use_devshell --file nix/flake-compat.nix outputsForCurrentSystem.devShells.dev
