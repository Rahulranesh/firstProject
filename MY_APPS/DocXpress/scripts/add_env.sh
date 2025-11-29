#!/bin/bash
set -e

BASHRC="$HOME/.bashrc"
MARKER_START="# >>> DocXpress environment additions >>>"
MARKER_END="# <<< DocXpress environment additions <<<"

# Paths we want to ensure are in PATH
FLUTTER_HOME="$HOME/development/flutter"
ANDROID_SDK="$HOME/Android/Sdk"

# Create .bashrc if missing
if [ ! -f "$BASHRC" ]; then
  touch "$BASHRC"
fi

# Append marker block only if not present
if ! grep -q "$MARKER_START" "$BASHRC"; then
  cat >> "$BASHRC" <<EOF
$MARKER_START
# DocXpress environment (added by setup script)
export FLUTTER_HOME="$FLUTTER_HOME"
export ANDROID_SDK_ROOT="$ANDROID_SDK"
export ANDROID_HOME="$ANDROID_SDK"
# Add Flutter and Android platform-tools to PATH
export PATH="$FLUTTER_HOME/bin:$ANDROID_SDK/platform-tools:
\$PATH"
# Ensure common system bin dirs exist in PATH
export PATH="/usr/local/bin:/usr/bin:/bin:$PATH"
$MARKER_END
EOF
  echo "Appended DocXpress env to $BASHRC"
else
  echo "DocXpress env already present in $BASHRC"
fi

# Also add to ~/.profile for non-interactive shells if not present
PROFILE="$HOME/.profile"
if [ ! -f "$PROFILE" ]; then
  touch "$PROFILE"
fi
if ! grep -q "$MARKER_START" "$PROFILE"; then
  cat >> "$PROFILE" <<EOF
$MARKER_START
# DocXpress environment (added by setup script)
export FLUTTER_HOME="$FLUTTER_HOME"
export ANDROID_SDK_ROOT="$ANDROID_SDK"
export ANDROID_HOME="$ANDROID_SDK"
export PATH="$FLUTTER_HOME/bin:$ANDROID_SDK/platform-tools:$PATH"
export PATH="/usr/local/bin:/usr/bin:/bin:$PATH"
$MARKER_END
EOF
  echo "Appended DocXpress env to $PROFILE"
else
  echo "DocXpress env already present in $PROFILE"
fi

# Source bashrc in this session (if interactive)
if [ -n "$PS1" ]; then
  # interactive shell
  source "$BASHRC"
else
  # try to source into current shell anyway
  . "$BASHRC" 2>/dev/null || true
fi

echo "Done. Please restart any open terminals or run 'source ~/.bashrc' to apply changes in them."