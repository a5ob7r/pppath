#!/usr/bin/env bats

setup () {
  source "$BATS_TEST_DIRNAME"/../pppath.sh
}

@test "Show paths." {
  PATH=/sbin:/bin run pppath

  [[ $status == 0 ]]
  [[ ${#lines[@]} == 2 ]]
  [[ ${lines[0]} == /sbin ]]
  [[ ${lines[1]} == /bin ]]
}

@test "Show tilda prefix path with quoting" {
  PATH="$HOME:~:$HOME/bin:~/bin" run pppath

  [[ $status == 0 ]]
  [[ ${#lines[@]} == 4 ]]
  [[ ${lines[0]} == '~' ]]
  [[ ${lines[1]} == "'~'" ]]
  [[ ${lines[2]} == '~/bin' ]]
  [[ ${lines[3]} == "'~/bin'" ]]
}

@test "Show multiple paths." {
  PATH=/sbin:/bin:/usr/sbin:/usr/bin run pppath

  [[ $status == 0 ]]
  [[ ${#lines[@]} == 4 ]]
  [[ ${lines[0]} == /sbin ]]
  [[ ${lines[1]} == /bin ]]
  [[ ${lines[2]} == /usr/sbin ]]
  [[ ${lines[3]} == /usr/bin ]]
}

@test "Show multiple paths with raw format." {
  PATH="$HOME/bin:/sbin:/bin:$HOME/sbin" run pppath --format=raw

  [[ $status == 0 ]]
  [[ ${#lines[@]} == 4 ]]
  [[ ${lines[0]} == ~/bin ]]
  [[ ${lines[1]} == /sbin ]]
  [[ ${lines[2]} == /bin ]]
  [[ ${lines[3]} == ~/sbin ]]
}

@test "Show multiple paths with pretty format." {
  PATH="$HOME/bin:/sbin:/bin:$HOME/sbin" run pppath --format=pretty

  [[ $status == 0 ]]
  [[ ${#lines[@]} == 4 ]]
  [[ ${lines[0]} == '~/bin' ]]
  [[ ${lines[1]} == /sbin ]]
  [[ ${lines[2]} == /bin ]]
  [[ ${lines[3]} == '~/sbin' ]]
}

@test "Non existance paths are colored in reversed red." {
  NO_COLOR=
  PATH=/foo/bar/sbin:/foo/bar/bin run pppath --color=always

  [[ $status == 0 ]]
  [[ ${#lines[@]} == 2 ]]
  [[ ${lines[0]} == '[7;31m/foo/bar/sbin[0m' ]]
  [[ ${lines[1]} == '[7;31m/foo/bar/bin[0m' ]]
}

@test "Paths under the home directory don't have color." {
  PATH=~ run pppath --color=always

  [[ $status == 0 ]]
  [[ ${#lines[@]} == 1 ]]
  [[ ${lines[0]} == '~' ]]
}

@test "Wellknown or default paths are colored in green." {
  PATH=/sbin:/bin run pppath --color=always

  [[ $status == 0 ]]
  [[ ${#lines[@]} == 2 ]]
  [[ ${lines[0]} == '[32m/sbin[0m' ]]
  [[ ${lines[1]} == '[32m/bin[0m' ]]
}

@test "Unknown paths are colored in yellow." {
  PATH=/etc:/usr run pppath --color=always

  [[ $status == 0 ]]
  [[ ${#lines[@]} == 2 ]]
  [[ ${lines[0]} == '[33m/etc[0m' ]]
  [[ ${lines[1]} == '[33m/usr[0m' ]]
}

@test "Duplicate paths are colored in red." {
  PATH=/bin:/bin run pppath --color=always

  [[ $status == 0 ]]
  [[ ${#lines[@]} == 2 ]]
  [[ ${lines[0]} == '[31m/bin[0m' ]]
  [[ ${lines[1]} == '[31m/bin[0m' ]]
}

@test "Show multiple paths given as arguments." {
  run pppath /usr/sbin /usr/bin /sbin:/bin

  [[ $status == 0 ]]
  [[ ${#lines[@]} == 4 ]]
  [[ ${lines[0]} == /usr/sbin ]]
  [[ ${lines[1]} == /usr/bin ]]
  [[ ${lines[2]} == /sbin ]]
  [[ ${lines[3]} == /bin ]]
}

@test "Return an error when invalid options given." {
  run pppath --color=foo --color=auto

  [[ $status == 1 ]]
  [[ ${#lines[@]} == 1 ]]
  [[ ${lines[0]} == "[path] An unknown option: --color=foo." ]]

  run pppath --format=raw --format=bar

  [[ $status == 1 ]]
  [[ ${#lines[@]} == 1 ]]
  [[ ${lines[0]} == "[path] An unknown option: --format=bar." ]]
}

@test "Accept options as arguments even if they are valid after --." {
  run pppath -- --format=raw --format=bar

  echo "${lines[@]}"
  [[ $status == 0 ]]
  [[ ${#lines[@]} == 2 ]]
  [[ ${lines[0]} == "--format=raw" ]]
  [[ ${lines[1]} == "--format=bar" ]]
}

@test "Show help." {
  run pppath --help

  [[ $status == 0 ]]
  [[ -n $output ]]
}

@test "Show version." {
  run pppath --version

  [[ $status == 0 ]]
  [[ -n $output ]]
}
