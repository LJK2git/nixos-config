#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias wg-up='sudo resolvconf -u; sudo wg-quick up /etc/wireguard/Leon-Archlinux.conf'
alias wg-down='sudo wg-quick down /etc/wireguard/Leon-Archlinux.conf'
alias grep='grep --color=auto'
alias network='speedtest-cli'
alias speed='speedtest-cli'
alias myip='curl -4 icanhazip.com'
alias fix='sudo iw dev wlan0 set power_save off'
rebuild() {
  if [[ "$1" == "-f" || "$1" == "--flake" ]]; then
    shift
    sudo nixos-rebuild switch --flake /etc/nixos#nixos "$@"
  else
    sudo nixos-rebuild switch "$@"
  fi
}
delold() {
  local profile="/nix/var/nix/profiles/system"
  local gens
  gens=$(sudo nix-env -p "$profile" --list-generations | awk '{print $1}' | head -n 10 | tr '\n' ' ')

  if [[ -z "$gens" ]]; then
    echo "No generations found."
    return 1
  fi

  echo "Deleting generations: $gens"
  sudo nix-env -p "$profile" --delete-generations $gens
}
gen() {
  sudo nix-env -p /nix/var/nix/profiles/system --list-generations | wc -l
}
alias dotfiles='bash ~/config/script.sh'
alias search='nix-search'
PS1='[\u@\h \W]\$ '

fastfetch
