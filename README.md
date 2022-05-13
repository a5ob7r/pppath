# pppath

[![CI](https://github.com/a5ob7r/pppath/actions/workflows/ci.yml/badge.svg)](https://github.com/a5ob7r/pppath/actions/workflows/ci.yml)

A pretty printer for $PATH written in Bash.

![screenshot01](etc/screenshot01.png)

## Usage

### As a Shell Function

1. Close this repository.

2. Source `./pppath` on your .bashrc.

3. Call `pppath`. For more detail, see `pppath --help`.

For example,

```sh
# Clone this repository into your home directory.
cd
git clone https://github.com/a5ob7r/pppath.git

# Append a config to your .bashrc to load pppath.
echo 'source ~/pppath/pppath' >> ~/.bashrc

# Reload the .bashrc in the current session.
source ~/.bashrc

# Call pppath.
pppath
```

### As a standalone script

You can also run `pppath` as a standalone script even if you use another shell except bash.

1. Download `./pppath` and deploy it into a directory which is contained in your $PATH.

2. Add executable permission(s) to it.

3. Call `pppath`. For more detail, see `pppath --help`.

For example,

```sh
# Download './pppath' onto /usr/local/bin, which we assume that your $PATH contains it.
curl -L https://raw.githubusercontent.com/a5ob7r/pppath/master/pppath > /usr/local/bin/pppath
# Or maybe need to run this instead if you have no permissions to write /usr/local/bin.
curl -L https://raw.githubusercontent.com/a5ob7r/pppath/master/pppath | sudo tee /usr/local/bin/pppath

# Add executable permissions to it.
chmod +x ~/bin/pppath
# Or
sudo chmod +x ~/bin/pppath

# Run it.
pppath
```
