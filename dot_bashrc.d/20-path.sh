# Extra PATH entries.

if [[ ":$PATH:" != *":$HOME/depot_tools:"* ]]; then
    PATH="$PATH:$HOME/depot_tools"
fi
export PATH
