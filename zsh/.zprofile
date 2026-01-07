# Only run Homebrew setup on macOS
if [[ "$OSTYPE" == "darwin"* ]] && [[ -f /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Only add Python framework paths if they exist (macOS-specific)
for pyver in 3.13 3.8 2.7; do
    pypath="/Library/Frameworks/Python.framework/Versions/$pyver/bin"
    [[ -d "$pypath" ]] && PATH="$pypath:$PATH"
done
export PATH
