# Aliases.

# Attach to an existing tmux session, or start a new one if there are none.
alias t='if tmux has-session 2>/dev/null; then tmux attach; else tmux; fi'

# Keep mosh sessions alive for up to a week without network.
alias mosh="/usr/bin/mosh --server 'MOSH_SERVER_NETWORK_TMOUT=604800 mosh-server'"

alias open='xdg-open'

alias vpn_up='netbird up -m https://netbird.rosaiclabs.com'
alias vpn_down='netbird down'
