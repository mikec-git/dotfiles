#!/bin/bash

# Superwhisper settings installation script
# Merges settings.json with interactive prompts for conflicts, then creates symlink
#
# Usage: ./install.sh
#
# This script handles two scenarios:
#   1. Clean install (no existing settings or already symlinked) - just creates symlink
#   2. Existing settings found - interactively merges with repo settings, then symlinks
#
# The end result is always a symlink from Superwhisper's settings location to the
# dotfiles repo, keeping settings version-controlled.

set -e  # Exit immediately if any command fails

# ============================================================================
# Configuration
# ============================================================================

# Get the directory where this script lives (resolves symlinks)
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Path to the settings file in the dotfiles repo (source of truth)
REPO_SETTINGS="$SCRIPT_DIR/settings.json"

# Where Superwhisper expects to find its settings
TARGET_DIR="$HOME/Documents/superwhisper/settings"
TARGET_SETTINGS="$TARGET_DIR/settings.json"

# Timestamped backup location for existing settings
BACKUP_DIR="$HOME/.dotfiles-backup/superwhisper/$(date +%Y%m%d_%H%M%S)"

# ============================================================================
# Dependency Check
# ============================================================================

# jq is required for JSON parsing and merging
if ! command -v jq &> /dev/null; then
    echo "Error: jq is required but not installed."
    echo "Install it with: brew install jq"
    exit 1
fi

echo "Installing Superwhisper settings..."

# Create target directory if it doesn't exist
mkdir -p "$TARGET_DIR"

# ============================================================================
# Simple Path: Clean Install or Re-link
# ============================================================================

# If no existing settings file OR it's already a symlink, we can just create/update
# the symlink without needing to merge anything.
# -f checks if file exists, -L checks if it's a symlink
if [ ! -f "$TARGET_SETTINGS" ] || [ -L "$TARGET_SETTINGS" ]; then
    # Remove existing symlink if present (ln -s fails if target exists)
    if [ -L "$TARGET_SETTINGS" ]; then
        echo "Removing existing symlink: $TARGET_SETTINGS"
        rm "$TARGET_SETTINGS"
    else
        echo "No existing settings found."
    fi

    echo "Creating symlink: $TARGET_SETTINGS -> $REPO_SETTINGS"
    ln -s "$REPO_SETTINGS" "$TARGET_SETTINGS"

    echo ""
    echo "Done! Settings symlinked to $REPO_SETTINGS"
    exit 0
fi

# ============================================================================
# Complex Path: Merge Existing Settings
# ============================================================================

# If we reach here, there's a real settings file (not a symlink) that needs
# to be merged with the repo settings before we can create the symlink.

echo "Found existing Superwhisper settings."
echo ""

# Always backup existing settings before modifying anything
echo "Creating backup at $BACKUP_DIR"
mkdir -p "$BACKUP_DIR"
cp "$TARGET_SETTINGS" "$BACKUP_DIR/settings.json"

# ============================================================================
# Helper Functions
# ============================================================================

# Extract array items from a JSON file and return as sorted, newline-separated list
# Args: $1 = file path, $2 = JSON key name
# Example: get_array_items "settings.json" "vocabulary" -> "word1\nword2\nword3"
get_array_items() {
    local file="$1"
    local key="$2"
    jq -r --arg key "$key" '.[$key] // [] | .[]' "$file" 2>/dev/null | sort
}

# Extract the "original" field from each object in the replacements array
# Used to identify unique replacements for comparison
# Args: $1 = file path
get_replacement_items() {
    local file="$1"
    jq -r '.replacements // [] | .[].original' "$file" 2>/dev/null | sort
}

# Display merge options and get user's choice
# Args: $1 = section name (for display)
# Returns: user's choice letter (defaults to 'A' if empty)
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

# Interactively select which items to include from a list
# Args: $1 = section name (unused, for context), $@ = items to choose from
# Returns: newline-separated list of selected items
select_items() {
    local section="$1"
    shift
    local items=("$@")
    local selected=()

    echo ""
    echo "Select items to include (y/n for each):"
    for item in "${items[@]}"; do
        read -p "  Include '$item'? [Y/n]: " yn
        # Include by default (only exclude if explicitly 'n' or 'N')
        if [[ ! "$yn" =~ ^[Nn]$ ]]; then
            selected+=("$item")
        fi
    done

    printf '%s\n' "${selected[@]}"
}

# ============================================================================
# Merge Functions
# ============================================================================

# Merge a simple string array (like vocabulary, modeKeys, favoriteModelIDs)
# Compares repo vs existing, shows differences, prompts user for merge strategy
# Args: $1 = JSON key name
# Returns: merged array as newline-separated list
merge_simple_array() {
    local key="$1"

    echo "=== $key ==="

    # Get items from both files
    local repo_items=$(get_array_items "$REPO_SETTINGS" "$key")
    local existing_items=$(get_array_items "$TARGET_SETTINGS" "$key")

    # Use 'comm' to compare sorted lists and find differences:
    #   comm -23: items only in first list (repo)
    #   comm -13: items only in second list (existing)
    #   comm -12: items in both lists
    local only_in_repo=$(comm -23 <(echo "$repo_items") <(echo "$existing_items") | grep -v '^$' || true)
    local only_in_existing=$(comm -13 <(echo "$repo_items") <(echo "$existing_items") | grep -v '^$' || true)
    local in_both=$(comm -12 <(echo "$repo_items") <(echo "$existing_items") | grep -v '^$' || true)

    # If no differences, skip the prompt
    if [ -z "$only_in_repo" ] && [ -z "$only_in_existing" ]; then
        echo "  No differences found."
        echo "$existing_items"
        return
    fi

    # Show what's different to help user decide
    if [ -n "$only_in_repo" ]; then
        echo "  Items in repo not in existing:"
        echo "$only_in_repo" | sed 's/^/    - /'
    fi

    if [ -n "$only_in_existing" ]; then
        echo "  Items in existing not in repo:"
        echo "$only_in_existing" | sed 's/^/    - /'
    fi

    local choice=$(prompt_merge_choice "$key")

    # ${choice^^} converts to uppercase for case-insensitive matching
    case "${choice^^}" in
        A)
            # Union: combine both and deduplicate
            { echo "$repo_items"; echo "$existing_items"; } | sort -u | grep -v '^$'
            ;;
        R)
            echo "$repo_items"
            ;;
        E)
            echo "$existing_items"
            ;;
        S)
            # Let user pick individual items from the combined list
            local all_items=$(printf '%s\n' "$in_both" "$only_in_repo" "$only_in_existing" | sort -u | grep -v '^$')
            select_items "$key" $all_items
            ;;
        *)
            # Default to union if invalid input
            { echo "$repo_items"; echo "$existing_items"; } | sort -u | grep -v '^$'
            ;;
    esac
}

# Merge the replacements array (array of objects with "original" and "with" fields)
# These are text replacement rules, more complex than simple string arrays
# Args: none (uses global REPO_SETTINGS and TARGET_SETTINGS)
# Returns: merged JSON array
merge_replacements() {
    echo "=== replacements ==="

    # Compare by the "original" field (the key that identifies each replacement)
    local repo_originals=$(get_replacement_items "$REPO_SETTINGS")
    local existing_originals=$(get_replacement_items "$TARGET_SETTINGS")

    local only_in_repo=$(comm -23 <(echo "$repo_originals") <(echo "$existing_originals") | grep -v '^$' || true)
    local only_in_existing=$(comm -13 <(echo "$repo_originals") <(echo "$existing_originals") | grep -v '^$' || true)

    # If no differences, skip the prompt
    if [ -z "$only_in_repo" ] && [ -z "$only_in_existing" ]; then
        echo "  No differences found."
        jq '.replacements // []' "$TARGET_SETTINGS"
        return
    fi

    # Show replacement rules that differ (display as 'original' -> 'replacement')
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
            # Merge both arrays, deduplicate by "original" field (existing wins on conflicts)
            jq -s '.[0].replacements + .[1].replacements | unique_by(.original)' "$TARGET_SETTINGS" "$REPO_SETTINGS"
            ;;
        R)
            jq '.replacements // []' "$REPO_SETTINGS"
            ;;
        E)
            jq '.replacements // []' "$TARGET_SETTINGS"
            ;;
        S)
            # Individual selection not implemented for objects - fall back to union
            echo "  (For replacements, selecting 'All from both' - individual selection not supported for objects)"
            jq -s '.[0].replacements + .[1].replacements | unique_by(.original)' "$TARGET_SETTINGS" "$REPO_SETTINGS"
            ;;
        *)
            jq -s '.[0].replacements + .[1].replacements | unique_by(.original)' "$TARGET_SETTINGS" "$REPO_SETTINGS"
            ;;
    esac
}

# Convert newline-separated list to JSON array
# Args: $1 = newline-separated string
# Returns: JSON array (e.g., ["item1", "item2"])
to_json_array() {
    local items="$1"
    if [ -z "$items" ]; then
        echo "[]"
    else
        # -R: read raw strings, -s: slurp into single string
        # Split by newlines, filter out empty strings
        echo "$items" | jq -R -s 'split("\n") | map(select(length > 0))'
    fi
}

# ============================================================================
# Main Execution: Interactive Merge
# ============================================================================

# Process each settings section interactively
echo ""
favoriteModelIDs=$(merge_simple_array "favoriteModelIDs")
echo ""
modeKeys=$(merge_simple_array "modeKeys")
echo ""
vocabulary=$(merge_simple_array "vocabulary")
echo ""
replacements=$(merge_replacements)

# ============================================================================
# Write Merged Settings
# ============================================================================

# Build the final JSON structure and write to the repo settings file
# This updates the dotfiles repo with the merged result
echo ""
echo "Writing merged settings to repo..."

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
    }' > "$REPO_SETTINGS"

# ============================================================================
# Create Symlink
# ============================================================================

# Replace the original settings file with a symlink to the repo
# This ensures future changes by Superwhisper are saved to the dotfiles repo
echo "Removing original settings file..."
rm "$TARGET_SETTINGS"

echo "Creating symlink: $TARGET_SETTINGS -> $REPO_SETTINGS"
ln -s "$REPO_SETTINGS" "$TARGET_SETTINGS"

echo ""
echo "Installation complete!"
echo "Backup saved to: $BACKUP_DIR/settings.json"
echo "Settings merged and symlinked to: $REPO_SETTINGS"
