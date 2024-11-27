function _logan_if_mac() {
    if [[ "$(uname -s)" == Darwin* ]]; then
        return 0
    else
        return 1
    fi
}

function _logan_if_linux() {
    if [[ "$(uname -s)" == Linux* ]]; then
        return 0
    else
        return 1
    fi
}

function _logan_if_debian() {
    if [[ "$(uname -s)" == Linux* ]]; then
        if grep -qi '^ID=debian' /etc/os-release; then
            return 0
        fi
    fi
    return 1
}

function _logan_if_windows() {
    local uname_out
    uname_out=$(uname -s)
    if grep -qEi "(Microsoft|WSL)" /proc/version &>/dev/null; then
        # windows 的 WSL 环境
        return 0
    elif [[ "$uname_out" == CYGWIN* || "$uname_out" == MINGW* || "$uname_out" == MSYS* ]]; then
        # windows 上的 git bash 或 Cygwin 等环境
        return 0
    else
        return 1
    fi
}

function _logan_if_command_exist() {
    command -v "$1" >/dev/null 2>&1
}
