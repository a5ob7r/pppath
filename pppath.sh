#!/bin/bash

pppath () {
  local -r version=0.1.0

  local -a args=()
  local color=auto
  local format=pretty

  while (( $# )); do
    case "$1" in
      --version )
        echo "$version"
        return 0
        ;;
      --help | -h )
        echo -n "\
Descriptions:
  Pretty printer for \$PATH. This substitutes each path prefixes with a literal
  tilda(~) if the prefix is \$HOME's value, the substitution is inspired by
  zsh's \"print -D\". And this decorates each paths with some colors, but skips
  decorations for an empty path.

  1. If no directory exists at the path, Reverse Red
  2. If the path is duplicated, Red
  3. If the path is well known or in general or contained in defaults, Green
  4. If the path prefix is \$HOME, None
  5. Otherwise, Yellow

Usages:
  pppath [--color=WHEN] [--format=FORMAT] [PATH...]

Globals:
  NO_COLOR: Disable text decorations with SGR forcibly.

Arguments:
  PATH  Optional multiple, and probably directpry paths. This is \$PATH if
        omitted.

Options:
  --color=WHEN     Whether or not coloring output. Valid values of WHEN are
                   'always', 'never', and 'auto'. The default value is 'auto'.
  --format=FORMAT  Whether or not using pretty print format. Valid values of
                   FORMAT are 'raw' and 'pretty'. The default value is 'pretty'.
  --help, -h       Show this message and exit
  --version        Show the version info and exit
"
        return 0
        ;;
      --color=always )
        color=always
        shift
        ;;
      --color=never )
        color=never
        shift
        ;;
      --color=auto )
        color=auto
        shift
        ;;
      --format=raw )
        format=raw
        shift
        ;;
      --format=pretty )
        format=pretty
        shift
        ;;
      -- )
        shift
        args+=("$@")
        shift $#
        ;;
      -* )
        echo "[path] An unknown option: $1."
        return 1
        ;;
      * )
        args+=("$1")
        shift
        ;;
    esac
  done

  if (( ${#args[@]} == 0 )); then
    args=("$PATH")
  fi

  # Assume almost all terminals can interpret SGR.
  if [[ $color == always || $color != never && $color == auto && -z ${NO_COLOR+1} && -t 1 && $TERM != dumb ]]; then
    red='\033[31m'
    reversered='\033[7;31m'
    green='\033[32m'
    yellow='\033[33m'
    reset='\033[0m'
  else
    red=''
    reversered=''
    green=''
    yellow=''
    reset=''
  fi

  # A common value of $PATH.
  local -r wellknowns=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin

  local -r path="$(IFS=:; echo "${args[*]}")"

  # Each path components.
  local -a paths=()
  IFS=: read -r -a paths <<<"$path"

  for p in "${paths[@]}"; do
    # Substitute $HOME with a literal tilda(~) if a prefix of the path is
    # $HOME.
    if [[ $format == pretty ]]; then
      case $p in
        ~ )
          local label='~'
          ;;
        ~/* )
          local label="~${p:${#HOME}}"
          ;;
        '~' | '~'/* )
          local label="'~${p:1}'"
          ;;
        * )
          local label=$p
          ;;
      esac
    else
      local label=$p
    fi

    if [[ -z $p ]]; then
      echo
    elif [[ ! -d $p ]]; then
      echo -e "$reversered$label$reset"
    elif [[ :$path: == *:$p:$p:* || :$path: == *:$p:*:$p:* ]]; then
      echo -e "$red$label$reset"
    elif [[ :$wellknowns: == *:$p:* ]]; then
      echo -e "$green$label$reset"
    elif [[ $p == ~ || $p == ~/* ]]; then
      echo "$label"
    else
      echo -e "$yellow$label$reset"
    fi
  done
}
