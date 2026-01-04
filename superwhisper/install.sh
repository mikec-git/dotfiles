#!/bin/bash

# Superwhisper settings installation script
# Merges settings.json with interactive prompts for conflicts

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
REPO_SETTINGS="$SCRIPT_DIR/settings.json"
TARGET_DIR="$HOME/Documents/superwhisper/settings"
TARGET_SETTINGS="$TARGET_DIR/settings.json"
BACKUP_DIR="$HOME/.dotfiles-backup/superwhisper/$(date +%Y%m%d_%H%M%S)"

# Check for jq dependency
if ! command -v jq &> /dev/null; then
    echo "Error: jq is required but not installed."
    echo "Install it with: brew install jq"
    exit 1
fi

echo "Installing Superwhisper settings..."

# Create target directory if it doesn't exist
mkdir -p "$TARGET_DIR"

# If no existing settings, just copy
if [ ! -f "$TARGET_SETTINGS" ]; then
    echo "No existing settings found. Copying from repo..."
    cp "$REPO_SETTINGS" "$TARGET_SETTINGS"
    echo "Done! Settings installed to $TARGET_SETTINGS"
    exit 0
fi

echo "Found existing Superwhisper settings."
echo ""

# Create backup
echo "Creating backup at $BACKUP_DIR"
mkdir -p "$BACKUP_DIR"
cp "$TARGET_SETTINGS" "$BACKUP_DIR/settings.json"

# Function to get array items as newline-separated list
get_array_items() {
    local file="$1"
    local key="$2"
    jq -r --arg key "$key" '.[$key] // [] | .[]' "$file" 2>/dev/null | sort
}

# Function to get array items for replacements (use original field)
get_replacement_items() {
    local file="$1"
    jq -r '.replacements // [] | .[].original' "$file" 2>/dev/null | sort
}

# Function to prompt user for merge choice
prompt_merge_choice() {
    local section="$1"
    echo ""
    echo "How to merge $section?"
    echo "  [A] All from both (union)"
    echo "  [R] Repo only"
    echo "  [E] Existing only"
    echo "  [S] Select items individually"
    read -p "Choice [A/R/E/S]: " choice
    echo "${choice:-A}"
}

# Function to select individual items
select_items() {
    local section="$1"
    shift
    local items=("$@")
    local selected=()

    echo ""
    echo "Select items to include (y/n for each):"
    for item in "${items[@]}"; do
        read -p "  Include '$item'? [Y/n]: " yn
        if [[ ! "$yn" =~ ^[Nn]$ ]]; then
            selected+=("$item")
        fi
    done

    printf '%s\n' "${selected[@]}"
}

# Function to merge simple string arrays
merge_simple_array() {
    local key="$1"

    echo "=== $key ==="

    # Get items from both files
    local repo_items=$(get_array_items "$REPO_SETTINGS" "$key")
    local existing_items=$(get_array_items "$TARGET_SETTINGS" "$key")

    # Find unique items
    local only_in_repo=$(comm -23 <(echo "$repo_items") <(echo "$existing_items") | grep -v '^$' || true)
    local only_in_existing=$(comm -13 <(echo "$repo_items") <(echo "$existing_items") | grep -v '^$' || true)
    local in_both=$(comm -12 <(echo "$repo_items") <(echo "$existing_items") | grep -v '^$' || true)

    if [ -z "$only_in_repo" ] && [ -z "$only_in_existing" ]; then
        echo "  No differences found."
        echo "$existing_items"
        return
    fi

    if [ -n "$only_in_repo" ]; then
        echo "  Items in repo not in existing:"
        echo "$only_in_repo" | sed 's/^/    - /'
    fi

    if [ -n "$only_in_existing" ]; then
        echo "  Items in existing not in repo:"
        echo "$only_in_existing" | sed 's/^/    - /'
    fi

    local choice=$(prompt_merge_choice "$key")

    case "${choice^^}" in
        A)
            # Union of both
            { echo "$repo_items"; echo "$existing_items"; } | sort -u | grep -v '^$'
            ;;
        R)
            echo "$repo_items"
            ;;
        E)
            echo "$existing_items"
            ;;
        S)
            local all_items=$(printf '%s\n' "$in_both" "$only_in_repo" "$only_in_existing" | sort -u | grep -v '^$')
            select_items "$key" $all_items
            ;;
        *)
            # Default to union
            { echo "$repo_items"; echo "$existing_items"; } | sort -u | grep -v '^$'
            ;;
    esac
}

# Function to merge replacements array (objects with id, original, with)
merge_replacements() {
    echo "=== replacements ==="

    local repo_originals=$(get_replacement_items "$REPO_SETTINGS")
    local existing_originals=$(get_replacement_items "$TARGET_SETTINGS")

    local only_in_repo=$(comm -23 <(echo "$repo_originals") <(echo "$existing_originals") | grep -v '^$' || true)
    local only_in_existing=$(comm -13 <(echo "$repo_originals") <(echo "$existing_originals") | grep -v '^$' || true)

    if [ -z "$only_in_repo" ] && [ -z "$only_in_existing" ]; then
        echo "  No differences found."
        jq '.replacements // []' "$TARGET_SETTINGS"
        return
    fi

    if [ -n "$only_in_repo" ]; then
        echo "  Replacements in repo not in existing:"
        echo "$only_in_repo" | while read -r orig; do
            local with=$(jq -r --arg orig "$orig" '.replacements[] | select(.original == $orig) | .with' "$REPO_SETTINGS")
            echo "    - '$orig' -> '$with'"
        done
    fi

    if [ -n "$only_in_existing" ]; then
        echo "  Replacements in existing not in repo:"
        echo "$only_in_existing" | while read -r orig; do
            local with=$(jq -r --arg orig "$orig" '.replacements[] | select(.original == $orig) | .with' "$TARGET_SETTINGS")
            echo "    - '$orig' -> '$with'"
        done
    fi

    local choice=$(prompt_merge_choice "replacements")

    case "${choice^^}" in
        A)
            # Merge both, existing wins on conflicts
            jq -s '.[0].replacements + .[1].replacements | unique_by(.original)' "$TARGET_SETTINGS" "$REPO_SETTINGS"
            ;;
        R)
            jq '.replacements // []' "$REPO_SETTINGS"
            ;;
        E)
            jq '.replacements // []' "$TARGET_SETTINGS"
            ;;
        S)
            echo "  (For replacements, selecting 'All from both' - individual selection not supported for objects)"
            jq -s '.[0].replacements + .[1].replacements | unique_by(.original)' "$TARGET_SETTINGS" "$REPO_SETTINGS"
            ;;
        *)
            jq -s '.[0].replacements + .[1].replacements | unique_by(.original)' "$TARGET_SETTINGS" "$REPO_SETTINGS"
            ;;
    esac
}

# Convert array to JSON array
to_json_array() {
    local items="$1"
    if [ -z "$items" ]; then
        echo "[]"
    else
        echo "$items" | jq -R -s 'split("\n") | map(select(length > 0))'
    fi
}

# Merge each section
echo ""
favoriteModelIDs=$(merge_simple_array "favoriteModelIDs")
echo ""
modeKeys=$(merge_simple_array "modeKeys")
echo ""
vocabulary=$(merge_simple_array "vocabulary")
echo ""
replacements=$(merge_replacements)

# Build final JSON
echo ""
echo "Writing merged settings..."

jq -n \
    --argjson favoriteModelIDs "$(to_json_array "$favoriteModelIDs")" \
    --argjson modeKeys "$(to_json_array "$modeKeys")" \
    --argjson replacements "$replacements" \
    --argjson vocabulary "$(to_json_array "$vocabulary")" \
    '{
        favoriteModelIDs: $favoriteModelIDs,
        modeKeys: $modeKeys,
        replacements: $replacements,
        vocabulary: $vocabulary
    }' > "$TARGET_SETTINGS"

echo ""
echo "Installation complete!"
echo "Backup saved to: $BACKUP_DIR/settings.json"
echo "Settings installed to: $TARGET_SETTINGS"
