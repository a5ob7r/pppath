# pppath

[![CI](https://github.com/a5ob7r/pppath/actions/workflows/ci.yml/badge.svg)](https://github.com/a5ob7r/pppath/actions/workflows/ci.yml)

A pretty printer for $PATH written in Bash.

![screenshot01](etc/screenshot01.png)

## Usage

1. Close this repository.

2. Source `pppath.sh` on your .bashrc.

3. Call `pppath`. For more detail, see `pppath --help`.

For example,

```sh
# Clone this repository into your home directory.
cd
git clone https://github.com/a5ob7r/pppath.git

# Append a config to your .bashrc to load pppath.
echo 'source ~/pppath/pppath.sh' >> ~/.bashrc

# Reload the .bashrc in the current session.
source ~/.bashrc

# Call pppath.
pppath
```
