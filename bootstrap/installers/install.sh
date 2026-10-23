#!/usr/bin/env bash

# Interactive front-end for the dotfiles bootstrap.
#
# Discovers every *.sh installer next to this script and every top-level
# directory in the repository's .config tree, then lets you choose what to
# install.
#
# Rules:
#   * Tool already provided by the system      -> blocked (grey, cannot select)
#   * Tool already present in ~/.local/bin     -> selectable, unchecked default
#   * Tool not installed                       -> selectable, checked default
#   * ~/.config/<name> already exists          -> selectable, unchecked default
#   * ~/.config/<name> does not exist          -> selectable, checked default
#
# Usage:
#   ./install.sh [--dry-run]
#   ./install.sh [--all | --only LIST] [--yes | --dry-run]
#
# Selection:
#   --all         Select every selectable row.
#   --only LIST   Select only the comma-separated names (ranger,fzf,...).
#   --yes         Apply the selection without opening the UI.
#   --dry-run     Show the plan and exit without changing anything.
#
# Keys:
#   Up/Down, k/j   Move
#   Enter/Space    Toggle highlighted row
#   a              Select/deselect all installable rows
#   y              Apply the selection and exit
#   q, Esc         Leave without applying anything
#   Ctrl-C         Leave without applying anything

set -uo pipefail

if ((BASH_VERSINFO[0] < 4)); then
    echo "Error: bash 4 or newer is required." >&2
    exit 1
fi

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd -- "$SCRIPT_DIR/../.." && pwd)"
CONFIG_SOURCE_ROOT="$REPO_ROOT/.config"
CONFIG_DEST_ROOT="${XDG_CONFIG_HOME:-$HOME/.config}"
LOCAL_BIN="$HOME/.local/bin"
POST_INSTALL="$SCRIPT_DIR/post_install/post_install.sh"

DRY_RUN=0
SELECT_ALL=0
ASSUME_YES=0
ONLY_LIST=''

### Glyphs and styles

CHECK='✓'
CROSS='✗'

C_RESET=''
C_BOLD=''
C_DIM=''
C_GREY=''
C_CYAN=''
C_YELLOW=''
C_RED=''
C_REV=''

if [[ -t 1 && ${TERM:-dumb} != dumb ]]; then
    C_RESET=$'\033[0m'
    C_BOLD=$'\033[1m'
    C_DIM=$'\033[2m'
    C_GREY=$'\033[90m'
    C_CYAN=$'\033[36m'
    C_YELLOW=$'\033[33m'
    C_RED=$'\033[31m'
    C_REV=$'\033[7m'
fi

### Row storage
#
# R_KIND    tool | config | post
# R_NAME    what is shown in the row
# R_DETAIL  dim information shown next to the name
# R_STATUS  system | local | absent | none
# R_PATH    installer script, config source directory, or post-install script
# R_DEST    destination directory (config rows only)
# R_BINS    executables the installer provides (tool rows only)
# R_CHECKED 0 | 1
# R_ENABLED 0 = grey / not selectable, 1 = selectable
# R_NOTE    explanation shown under the table for the highlighted row

R_KIND=()
R_NAME=()
R_DETAIL=()
R_STATUS=()
R_PATH=()
R_DEST=()
R_BINS=()
R_CHECKED=()
R_ENABLED=()
R_NOTE=()

add_row() {
    R_KIND+=("$1")
    R_NAME+=("$2")
    R_DETAIL+=("$3")
    R_STATUS+=("$4")
    R_PATH+=("$5")
    R_DEST+=("${6:-}")
    R_BINS+=("${7:-}")
    R_CHECKED+=("$8")
    R_ENABLED+=("$9")
    R_NOTE+=("${10:-}")
}

pretty_path() {
    local path=$1
    printf '%s' "${path/#$HOME/\~}"
}

### Discovery

extract_bins() {
    local script=$1
    local base=${script##*/}
    base=${base%.sh}

    local -a bins=()

    # shellcheck disable=SC2016 # $BIN_DIR / $HOME are matched literally.
    mapfile -t bins < <(
        {
            grep -oE '\$\{?BIN_DIR\}?/[A-Za-z0-9._+-]+' "$script" || true
            grep -oE '\$HOME/\.local/bin/[A-Za-z0-9._+-]+' "$script" || true
        } |
            sed -E 's#^\$\{?BIN_DIR\}?/##; s#^\$HOME/\.local/bin/##' |
            sort -u
    )

    # Most scripts also refer to the installed binary through $BIN_DIR. If a
    # script does not, assume the installer name is the executable name.
    # fonts.sh is the exception: it only populates ~/.local/share/fonts.
    if ((${#bins[@]} == 0)) && [[ $base != fonts ]]; then
        bins=("$base")
    fi

    if ((${#bins[@]} > 0)); then
        printf '%s\n' "${bins[@]}"
    fi
}

discover_tools() {
    local -a scripts=()
    local -a bins=()
    local script base bin status checked enabled name detail note
    local first_local first_system system_path

    mapfile -t scripts < <(
        find "$SCRIPT_DIR" -maxdepth 1 -type f -name '*.sh' \
            ! -name '.*' ! -name 'install.sh' ! -name 'lib.sh' -print | sort
    )

    for script in "${scripts[@]}"; do
        base=${script##*/}
        base=${base%.sh}

        mapfile -t bins < <(extract_bins "$script")

        status=absent
        first_local=''
        first_system=''

        for bin in "${bins[@]}"; do
            if [[ -e "$LOCAL_BIN/$bin" || -L "$LOCAL_BIN/$bin" ]]; then
                [[ -n $first_local ]] || first_local="$LOCAL_BIN/$bin"
                [[ $status == system ]] || status=local
            elif system_path="$(type -P "$bin" 2>/dev/null)" && [[ -n $system_path ]]; then
                first_system=$system_path
                status=system
            fi
        done

        if ((${#bins[@]} == 0)); then
            status=none
        fi

        if ((${#bins[@]} == 1)); then
            name=${bins[0]}
            if [[ $name == "$base" ]]; then
                detail=''
            else
                detail="(from ${base}.sh)"
            fi
        elif ((${#bins[@]} > 1)); then
            name=$base
            detail="(${bins[*]})"
        else
            name=$base
            detail='(no executable)'
        fi

        case $status in
            system)
                checked=0
                enabled=0
                note="system install found: $first_system — cannot install"
                ;;
            local)
                checked=0
                enabled=1
                note="$first_local already exists — install is opt-in (would overwrite)"
                ;;
            absent)
                checked=1
                enabled=1
                note='not found — ready to install'
                ;;
            none)
                checked=1
                enabled=1
                note='no executable to check — ready to install'
                ;;
        esac

        if [[ $base == fonts ]]; then
            detail='(fonts → ~/.local/share/fonts)'
        fi

        add_row tool "$name" "$detail" "$status" "$script" '' \
            "${bins[*]}" "$checked" "$enabled" "$note"
    done
}

discover_post_install() {
    local src name dest status checked note
    local -a config_dirs=()

    if [[ -f $POST_INSTALL ]]; then
        add_row post 'Bash/Git environment' '(post_install.sh)' none \
            "$POST_INSTALL" '' '' 1 1 \
            'updates ~/.bashrc, ~/.bash, and the Git/GDB configuration'
    fi

    if [[ -d $CONFIG_SOURCE_ROOT ]]; then
        mapfile -t config_dirs < <(
            find "$CONFIG_SOURCE_ROOT" -mindepth 1 -maxdepth 1 -type d -print | sort
        )

        for src in "${config_dirs[@]}"; do
            name=${src##*/}
            dest="$CONFIG_DEST_ROOT/$name"

            if [[ -e $dest || -L $dest ]]; then
                status=local
                checked=0
                note="$(pretty_path "$dest") already exists — install is opt-in (would overwrite)"
            else
                status=absent
                checked=1
                note="$(pretty_path "$dest") missing — ready to install"
            fi

            add_row config ".config/$name" '' "$status" "$src" "$dest" '' \
                "$checked" 1 "$note"
        done
    fi
}

### Selection flags

list_row_names() {
    local i key

    for i in "${!R_KIND[@]}"; do
        key=${R_PATH[i]##*/}
        key=${key%.sh}
        printf '  %s\n' "$key"
    done | sort -u
}

apply_selection_flags() {
    local i key name want found=0
    local -a wanted=()

    if ((SELECT_ALL)); then
        for i in "${!R_ENABLED[@]}"; do
            ((R_ENABLED[i])) && R_CHECKED[i]=1
        done
        return 0
    fi

    [[ -n $ONLY_LIST ]] || return 0

    IFS=',' read -r -a wanted <<<"$ONLY_LIST"

    # Start from a clean selection: only explicitly named rows are checked.
    for i in "${!R_CHECKED[@]}"; do
        R_CHECKED[i]=0
    done

    for i in "${!R_KIND[@]}"; do
        key=${R_PATH[i]##*/}
        key=${key%.sh}
        name=${R_NAME[i]#.config/}

        for want in "${wanted[@]}"; do
            want=${want//[[:space:]]/}
            [[ -n $want ]] || continue

            # Match the installer name, its file name, its binaries, or the
            # short "post" alias for the post-install row.
            if [[ $want == "$name" || $want == "$key" ||
                $want == post && $key == post_install ||
                " ${R_BINS[i]} " == *" $want "* ]]; then
                found=1
                if ((R_ENABLED[i])); then
                    R_CHECKED[i]=1
                else
                    printf 'Skipping %s: %s\n' "$name" "${R_NOTE[i]}" >&2
                fi
                break
            fi
        done
    done

    if ((found == 0)); then
        printf 'Error: --only matched nothing.\nAvailable names:\n' >&2
        list_row_names >&2
        exit 1
    fi
}

### Selection helpers

any_enabled() {
    local i
    for i in "${!R_ENABLED[@]}"; do
        ((R_ENABLED[i])) && return 0
    done
    return 1
}

all_selected() {
    local i
    local any=0
    for i in "${!R_CHECKED[@]}"; do
        ((R_ENABLED[i])) || continue
        any=1
        ((R_CHECKED[i])) || return 1
    done
    ((any == 1))
}

selected_count() {
    local i count=0
    for i in "${!R_CHECKED[@]}"; do
        if ((R_ENABLED[i] && R_CHECKED[i])); then
            count=$((count + 1))
        fi
    done
    printf '%s' "$count"
}

toggle_all() {
    local i value=1
    if all_selected; then
        value=0
    fi
    for i in "${!R_ENABLED[@]}"; do
        if ((R_ENABLED[i])); then
            R_CHECKED[i]=$value
        fi
    done
}

### Rendering

PLAIN_LINES=()
LINE_STYLE=()
LINE_NAV=()

CUR=0
UI_ACTIVE=0
CURSOR_HIDDEN=0

add_line() {
    PLAIN_LINES+=("$1")
    LINE_STYLE+=("${2:-normal}")
    LINE_NAV+=("${3:--1}")
}

ui_start() {
    printf '\033[?1049h'
    UI_ACTIVE=1
    printf '\033[?25l'
    CURSOR_HIDDEN=1
}

ui_stop() {
    if ((CURSOR_HIDDEN)); then
        printf '\033[?25h'
        CURSOR_HIDDEN=0
    fi
    if ((UI_ACTIVE)); then
        printf '\033[?1049l'
        UI_ACTIVE=0
    fi
}

cleanup() {
    ui_stop
}

render() {
    PLAIN_LINES=()
    LINE_STYLE=()
    LINE_NAV=()

    local i nav=0 mark style text note
    local tool_header_done=0
    local post_header_done=0
    local cols height avail offset=0 cur_line=-1
    local content_start content_end content_count header_count footer_count

    add_line 'Dotfiles installer' title
    add_line "repo: $REPO_ROOT" dim
    if ((DRY_RUN)); then
        add_line 'DRY RUN — nothing will be changed' warning
    fi
    add_line '' dim

    mark=' '
    if all_selected; then
        mark=$CHECK
    fi
    add_line "[$mark] Select / deselect all" normal 0

    content_start=${#PLAIN_LINES[@]}

    for i in "${!R_KIND[@]}"; do
        if [[ ${R_KIND[i]} == tool && $tool_header_done == 0 ]]; then
            tool_header_done=1
            add_line '' dim
            add_line 'Tool installers (.sh)' header
        elif [[ ${R_KIND[i]} != tool && $post_header_done == 0 ]]; then
            post_header_done=1
            add_line '' dim
            add_line 'Post-install (.config)' header
        fi

        if ((!R_ENABLED[i])); then
            mark=' '
        elif ((R_CHECKED[i])); then
            mark=$CHECK
        else
            mark=$CROSS
        fi

        text="[$mark] ${R_NAME[i]}"
        if [[ -n ${R_DETAIL[i]} ]]; then
            text+="  ${R_DETAIL[i]}"
        fi

        style=normal
        ((R_ENABLED[i])) || style=disabled

        nav=$((i + 1))
        add_line "$text" "$style" "$nav"
    done

    content_end=${#PLAIN_LINES[@]}
    content_count=$((content_end - content_start))

    add_line '' dim

    if ((CUR == 0)); then
        note='Enter toggles every selectable row.'
    else
        note=${R_NOTE[$((CUR - 1))]:-}
    fi
    add_line "› $note" dim
    add_line "selected: $(selected_count)/$((${#R_KIND[@]}))" dim
    add_line '↑/↓ move · Enter toggle · a all · y apply · q/Esc leave' dim

    cols=$(tput cols 2>/dev/null) || cols=''
    [[ $cols =~ ^[0-9]+$ ]] || cols=80
    height=$(tput lines 2>/dev/null) || height=''
    [[ $height =~ ^[0-9]+$ ]] || height=24

    header_count=$content_start
    footer_count=$((${#PLAIN_LINES[@]} - content_end))
    avail=$((height - 1 - header_count - footer_count))
    ((avail < 3)) && avail=3

    for ((i = content_start; i < content_end; i++)); do
        if ((LINE_NAV[i] == CUR)); then
            cur_line=$((i - content_start))
            break
        fi
    done

    if ((content_count > avail)); then
        if ((cur_line >= avail)); then
            offset=$((cur_line - avail + 1))
        fi
        if ((offset > content_count - avail)); then
            offset=$((content_count - avail))
        fi
    fi

    printf '\033[H\033[2J'

    local content_limit=$((content_start + offset + avail))
    ((content_limit > content_end)) && content_limit=$content_end

    local text_display pad spaces s
    for i in "${!PLAIN_LINES[@]}"; do
        # Header and footer stay pinned; only the row area scrolls.
        if ((i >= content_start && i < content_end)); then
            if ((i < content_start + offset || i >= content_limit)); then
                continue
            fi
        fi

        text_display=${PLAIN_LINES[i]}

        if ((${#text_display} > cols)); then
            text_display="${text_display:0:cols-1}…"
        fi

        pad=$((cols - ${#text_display}))
        if ((pad > 0)); then
            printf -v spaces '%*s' "$pad" ''
            text_display+=$spaces
        fi

        s=''
        case ${LINE_STYLE[i]} in
            title | header) s="${C_BOLD}${C_CYAN}" ;;
            dim) s=$C_DIM ;;
            disabled) s=$C_GREY ;;
            warning) s=$C_YELLOW ;;
        esac

        if ((LINE_NAV[i] == CUR)); then
            if [[ ${LINE_STYLE[i]} == disabled ]]; then
                s="${C_GREY}${C_REV}"
            else
                s="${C_BOLD}${C_REV}"
            fi
        fi

        if [[ -n $s ]]; then
            printf '%s%s%s\n' "$s" "$text_display" "$C_RESET"
        else
            printf '%s\n' "$text_display"
        fi
    done
}

### Input

KEY=''

read_key() {
    local key rest

    KEY=''
    if ! IFS= read -rsn1 key; then
        KEY=cancel
        return
    fi

    if [[ $key == $'\e' ]]; then
        if IFS= read -rsn2 -t 0.08 rest; then
            case $rest in
                '[A' | 'OA') KEY=up ;;
                '[B' | 'OB') KEY=down ;;
                *) KEY=none ;;
            esac
        else
            KEY=quit
        fi
        return
    fi

    case $key in
        '') KEY=toggle ;;
        ' ') KEY=toggle ;;
        y | Y) KEY=apply ;;
        q | Q) KEY=quit ;;
        k | K) KEY=up ;;
        j | J) KEY=down ;;
        a | A) KEY=select_all ;;
        $'\003') KEY=cancel ;;
        *) KEY=none ;;
    esac
}

run_ui() {
    local total=${#R_KIND[@]}

    if ((total > 0)); then
        CUR=1
    else
        CUR=0
    fi

    ui_start
    while :; do
        render
        read_key

        case $KEY in
            up)
                ((CUR > 0)) && CUR=$((CUR - 1))
                ;;
            down)
                ((CUR < total)) && CUR=$((CUR + 1))
                ;;
            toggle)
                if ((CUR == 0)); then
                    toggle_all
                else
                    local idx=$((CUR - 1))
                    if ((R_ENABLED[idx])); then
                        R_CHECKED[idx]=$((1 - R_CHECKED[idx]))
                    fi
                fi
                ;;
            select_all)
                toggle_all
                ;;
            apply)
                break
                ;;
            quit | cancel)
                ui_stop
                printf '\nLeft without applying. No changes were made.\n' >&2
                exit 0
                ;;
        esac
    done
    ui_stop
}

### Plan / execution

show_plan() {
    local i phase actions=0 label
    if ((DRY_RUN)); then
        label='(dry run) '
    else
        label=''
    fi

    printf '\n%sPlan%s\n' "$C_BOLD" "$C_RESET"

    # Match the order used by run_plan: tools, configs, post-install.
    for phase in tool config post; do
        for i in "${!R_KIND[@]}"; do
            [[ ${R_KIND[i]} == "$phase" ]] || continue
            ((R_ENABLED[i] && R_CHECKED[i])) || continue

            case $phase in
                tool)
                    printf '  %srun    bash %s\n' "$label" "${R_PATH[i]}"
                    if [[ ${R_STATUS[i]} == local ]]; then
                        printf '         %swarning:%s %s\n' \
                            "$C_YELLOW" "$C_RESET" "${R_NOTE[i]}"
                    fi
                    ;;
                config)
                    printf '  %scopy   %s/ -> %s/\n' "$label" \
                        "${R_PATH[i]}" "$(pretty_path "${R_DEST[i]}")"
                    if [[ ${R_STATUS[i]} == local ]]; then
                        printf '         %swarning:%s %s exists and will be overwritten\n' \
                            "$C_YELLOW" "$C_RESET" "$(pretty_path "${R_DEST[i]}")"
                    fi
                    ;;
                post)
                    printf '  %srun    bash %s --no-config-copy\n' \
                        "$label" "${R_PATH[i]}"
                    ;;
            esac

            actions=$((actions + 1))
        done
    done

    if ((actions == 0)); then
        printf '  (nothing selected)\n'
    fi
    printf '\n'
}

run_plan() {
    local i failures=0 ran=0

    for i in "${!R_KIND[@]}"; do
        [[ ${R_KIND[i]} == tool ]] || continue
        ((R_ENABLED[i] && R_CHECKED[i])) || continue

        printf '%s==> %s%s\n' "$C_BOLD" "${R_NAME[i]}" "$C_RESET"
        if bash "${R_PATH[i]}"; then
            ran=$((ran + 1))
        else
            failures=$((failures + 1))
            printf '%sInstaller failed: %s%s\n' "$C_RED" "${R_PATH[i]}" "$C_RESET" >&2
        fi
        printf '\n'
    done

    for i in "${!R_KIND[@]}"; do
        [[ ${R_KIND[i]} == config ]] || continue
        ((R_ENABLED[i] && R_CHECKED[i])) || continue

        printf '%s==> %s -> %s%s\n' "$C_BOLD" "${R_NAME[i]}" \
            "$(pretty_path "${R_DEST[i]}")" "$C_RESET"

        if mkdir -p "$CONFIG_DEST_ROOT" &&
            cp -a "${R_PATH[i]}/." "${R_DEST[i]}/"; then
            ran=$((ran + 1))
        else
            failures=$((failures + 1))
            printf '%sConfig install failed: %s%s\n' "$C_RED" \
                "${R_PATH[i]}" "$C_RESET" >&2
        fi
        printf '\n'
    done

    for i in "${!R_KIND[@]}"; do
        [[ ${R_KIND[i]} == post ]] || continue
        ((R_ENABLED[i] && R_CHECKED[i])) || continue

        printf '%s==> Post-install (%s)%s\n' "$C_BOLD" \
            "${R_PATH[i]##*/}" "$C_RESET"
        if bash "${R_PATH[i]}" --no-config-copy; then
            ran=$((ran + 1))
        else
            failures=$((failures + 1))
            printf '%sPost-install failed: %s%s\n' "$C_RED" \
                "${R_PATH[i]}" "$C_RESET" >&2
        fi
        printf '\n'
    done

    printf '%sSummary:%s %s step(s) completed, %s failed.\n' \
        "$C_BOLD" "$C_RESET" "$ran" "$failures"

    ((failures == 0))
}

### Argument parsing

usage() {
    cat <<EOF
Usage: ${0##*/} [options]

Interactive installer for the dotfiles bootstrap.

  --all         Select every selectable row before starting.
  --only LIST   Select only the comma-separated names (e.g. ranger,fzf).
  --yes         Apply the selection without opening the UI.
  --dry-run     Show what would be installed and exit without changing anything.
  -h, --help    Show this help.

Names accepted by --only are the installer file names (ranger, post_install,
nvim, ...), the displayed names, or the provided binaries.

Keys: Up/Down move, Enter/Space toggle, a select all,
      y apply, q or Esc leave without applying.
EOF
}

while (($# > 0)); do
    case $1 in
        --dry-run)
            DRY_RUN=1
            ;;
        --all)
            SELECT_ALL=1
            ;;
        --only)
            if (($# < 2)); then
                printf 'Error: --only requires a value.\n\n' >&2
                usage >&2
                exit 1
            fi
            ONLY_LIST=$2
            shift
            ;;
        --only=*)
            ONLY_LIST=${1#*=}
            ;;
        --yes)
            ASSUME_YES=1
            ;;
        -h | --help)
            usage
            exit 0
            ;;
        *)
            printf 'Unknown option: %s\n\n' "$1" >&2
            usage >&2
            exit 1
            ;;
    esac
    shift
done

if ((SELECT_ALL)) && [[ -n $ONLY_LIST ]]; then
    printf 'Error: --all and --only are mutually exclusive.\n' >&2
    exit 1
fi

### Main

discover_tools
discover_post_install
apply_selection_flags

interactive=0
if [[ -t 0 && -t 1 ]]; then
    interactive=1
fi

if ((!interactive && !DRY_RUN && !ASSUME_YES)); then
    printf 'Error: this installer needs an interactive terminal.\n' >&2
    printf 'Use --yes to apply the current selection unattended,\n' >&2
    printf 'or --dry-run to print the plan without changing anything.\n' >&2
    exit 1
fi

trap cleanup EXIT
trap 'cleanup; printf "\nLeft without applying. No changes were made.\n" >&2; exit 130' INT TERM

if ((${#R_KIND[@]} == 0)); then
    printf 'No installers found in %s\n' "$SCRIPT_DIR" >&2
    exit 1
fi

if ((interactive && !ASSUME_YES)); then
    run_ui
fi

show_plan

if ((DRY_RUN)); then
    printf 'Dry run: no changes were made.\n'
    exit 0
fi

if ! any_enabled; then
    printf 'Nothing can be installed.\n'
    exit 0
fi

if [[ $(selected_count) -eq 0 ]]; then
    printf 'Nothing selected. No changes were made.\n'
    exit 0
fi

run_plan
