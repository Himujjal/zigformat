# Zig Format

Not production ready. Just to be used for [NeoFormat](https://github.com/sbdchd/neoformat)

## Install

```sh
SOME_DIR_IN_PATH=~/.local/bin

git clone https://github.com/Himujjal/zigformat
cd zigformat
zig build -Drelease-safe=true
cp zig-out/bin/zigformat $SOME_DIR_IN_PATH
chmod u+x $SOME_DIR_IN_PATH/zigformat
```

## Run

```
zigformat test.zig
```
