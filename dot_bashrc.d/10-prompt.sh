# Prompt: [(exit code) (red)] [toolbx (magenta)] hostname (green) working dir (blue)
#         git branch (yellow)

# Capture the last command's exit status before any other PROMPT_COMMAND
# hooks (e.g. Fedora's vte/systemd ones) run and clobber $?.
__prompt_save_status() { __prompt_status=$?; }
if [ "${PROMPT_COMMAND[0]}" != __prompt_save_status ]; then
    PROMPT_COMMAND=(__prompt_save_status "${PROMPT_COMMAND[@]}")
fi

# Report commands that ran longer than this many seconds.
__prompt_long_threshold=10

# Runs from PS0, i.e. after a command line is read and before it executes.
# ${ ...; } (bash 5.3+) runs in the current shell, so the variables stick.
__prompt_preexec() {
    __prompt_cmd_start=$EPOCHSECONDS
}

# Format a number of seconds as e.g. "1d 2h 3m 4s", omitting leading zeros.
__prompt_format_duration() {
    local s=$1 d h m out=
    d=$((s / 86400)) h=$((s % 86400 / 3600)) m=$((s % 3600 / 60)) s=$((s % 60))
    ((d)) && out+="${d}d "
    ((d || h)) && out+="${h}h "
    ((d || h || m)) && out+="${m}m "
    printf '%s' "$out${s}s"
}

# Before the prompt, report the previous command if it ran long.
__prompt_report_duration() {
    local histcmd=$HISTCMD last_histcmd=$__prompt_last_histcmd
    __prompt_last_histcmd=$histcmd
    [ -n "$__prompt_cmd_start" ] || return
    local elapsed=$((EPOCHSECONDS - __prompt_cmd_start)) cmd=command
    unset __prompt_cmd_start
    ((elapsed > __prompt_long_threshold)) || return

    # Name the command from history. If the history number didn't move since
    # the last prompt, the line wasn't saved: under ignoredups the newest
    # entry is still the same command, but under ignorespace it may not be.
    # (Not fc -l: interactively it skips the newest entry.)
    if ((histcmd != last_histcmd)) || [[ $HISTCONTROL != *ignorespace* && $HISTCONTROL != *ignoreboth* ]]; then
        local HISTTIMEFORMAT=
        cmd=$(history 1)
        cmd=${cmd#*[0-9]  }
        cmd=${cmd#"${cmd%%[![:space:]]*}"}
    fi
    printf '%s completed in %s\n' "$cmd" "$(__prompt_format_duration "$elapsed")"
}

if [[ $PS0 != *__prompt_preexec* ]]; then
    PS0='${ __prompt_preexec; }'"$PS0"
fi
if [[ " ${PROMPT_COMMAND[*]} " != *" __prompt_report_duration "* ]]; then
    PROMPT_COMMAND=(__prompt_save_status __prompt_report_duration "${PROMPT_COMMAND[@]:1}")
fi

# Print "(N) " when the last command failed.
__prompt_exit_code() {
    [ "${__prompt_status:-0}" -ne 0 ] && printf '(%s) ' "$__prompt_status"
}

# Print the current git branch, or short commit hash when detached.
__prompt_git_branch() {
    local ref
    ref=$(git symbolic-ref --short -q HEAD 2>/dev/null) ||
        ref=$(git rev-parse --short -q HEAD 2>/dev/null) || return
    printf ' (%s)' "$ref"
}

# Inside a toolbx container, prefix the prompt with ⬢ and the container name.
__prompt_toolbx=
if [ -f /run/.toolboxenv ]; then
    __prompt_toolbx_name=$(sed -n 's/^name="\(.*\)"$/\1/p' /run/.containerenv 2>/dev/null)
    __prompt_toolbx="\[\e[1;35m\]⬢ ${__prompt_toolbx_name:-toolbx}\[\e[0m\] "
    unset __prompt_toolbx_name
fi

# \[ \] wrap non-printing escapes so bash measures line length correctly.
# 1;3x = bold + color.
PS1='\[\e[1;31m\]$(__prompt_exit_code)\[\e[0m\]'"${__prompt_toolbx}"'\[\e[1;32m\]\h\[\e[0m\] \[\e[1;34m\]\w\[\e[0m\]\[\e[1;33m\]$(__prompt_git_branch)\[\e[0m\] \$ '
unset __prompt_toolbx
