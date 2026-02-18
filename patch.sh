#!/usr/bin/env sh

set -e pipefail

SCRIPT_DIR="$(readlink -f "$0")"
SCRIPT_DIR="${SCRIPT_DIR%/*}"
PATCH_DIR="$SCRIPT_DIR/patches"
SRC="$SCRIPT_DIR/src"
PATCHED="$SCRIPT_DIR/patched"

mkdir -p "$PATCHED"
rm -fr "${PATCHED:?}"/*
cp -r "$SRC"/* "$PATCHED"
cd "$PATCHED"

for patch in \
    st-anysize-20220718-baa9357.diff \
    st-scrollback-ringbuffer-0.9.2.diff \
    st-scrollback-mouse-0.9.2.diff \
    st-desktopentry-0.8.5.diff \
    st-boxdraw_v2-0.8.5.diff \
    st-paste_controls-0.9.2.diff \
    st-xresources-20230320-45a15676.diff \
    # st-colorschemes-0.8.5.diff \

do
    echo "Applying $patch"
    patch -p1 <"$PATCH_DIR/$patch"
done

cp "$SCRIPT_DIR/config.h" "$PATCHED"
cp "$SCRIPT_DIR/st.1" "$PATCHED"
if [ "$(uname)" = "FreeBSD" ]; then
    cp "$SCRIPT_DIR/config.freebsd.mk" "$PATCHED/config.mk"
else
    if [ -e "$SCRIPT_DIR/config.mk" ]; then
        cp "$SCRIPT_DIR/config.mk" "$PATCHED/"
    fi
fi
