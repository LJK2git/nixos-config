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
alias rebuild='sudo nixos-rebuild switch --flake /etc/nixos#nixos'
alias dotfiles='bash ~/config/config-files.sh'
PS1='[\u@\h \W]\$ '

fastfetch
