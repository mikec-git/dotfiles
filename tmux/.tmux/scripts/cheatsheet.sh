#!/bin/bash
# Tmux Cheatsheet - Color-coded reference
# Prefix: Ctrl+a

# Colors
R='\033[1;31m'    # Red - headers
G='\033[1;32m'    # Green - keys
Y='\033[1;33m'    # Yellow - important
C='\033[1;36m'    # Cyan - sections
W='\033[1;37m'    # White - text
D='\033[0;37m'    # Dim - descriptions
N='\033[0m'       # Reset

# Function to generate cheatsheet content
generate_content() {
echo -e "${Y}━━━━━━━━━━━━━━━━━━━━━━━━━━━${N}"
echo -e "${Y}   TMUX CHEATSHEET${N}"
echo -e "${Y}   Prefix: Ctrl+a${N}"
echo -e "${Y}━━━━━━━━━━━━━━━━━━━━━━━━━━━${N}"

echo -e "${C}┌─────────────────────────┐${N}"
echo -e "${C}│${N} ${W}SESSIONS${N}               ${C}│${N}"
echo -e "${C}├─────────────────────────┤${N}"
echo -e "${C}│${N} ${G}d${N}       ${D}Detach${N}         ${C}│${N}"
echo -e "${C}│${N} ${G}s${N}       ${D}List sessions${N}  ${C}│${N}"
echo -e "${C}│${N} ${G}\$${N}       ${D}Rename session${N} ${C}│${N}"
echo -e "${C}│${N} ${G}(${N}       ${D}Prev session${N}   ${C}│${N}"
echo -e "${C}│${N} ${G})${N}       ${D}Next session${N}   ${C}│${N}"
echo -e "${C}└─────────────────────────┘${N}"

echo -e "${C}┌─────────────────────────┐${N}"
echo -e "${C}│${N} ${W}WINDOWS${N}                ${C}│${N}"
echo -e "${C}├─────────────────────────┤${N}"
echo -e "${C}│${N} ${G}c${N}       ${D}Create window${N}  ${C}│${N}"
echo -e "${C}│${N} ${G},${N}       ${D}Rename window${N}  ${C}│${N}"
echo -e "${C}│${N} ${G}&${N}       ${D}Close window${N}   ${C}│${N}"
echo -e "${C}│${N} ${G}n${N}       ${D}Next window${N}    ${C}│${N}"
echo -e "${C}│${N} ${G}p${N}       ${D}Prev window${N}    ${C}│${N}"
echo -e "${C}│${N} ${G}0-9${N}     ${D}Go to window #${N} ${C}│${N}"
echo -e "${C}│${N} ${G}w${N}       ${D}List windows${N}   ${C}│${N}"
echo -e "${C}└─────────────────────────┘${N}"

echo -e "${C}┌─────────────────────────┐${N}"
echo -e "${C}│${N} ${W}PANES${N}                  ${C}│${N}"
echo -e "${C}├─────────────────────────┤${N}"
echo -e "${C}│${N} ${G}|${N}       ${D}Split vertical${N} ${C}│${N}"
echo -e "${C}│${N} ${G}-${N}       ${D}Split horiz${N}    ${C}│${N}"
echo -e "${C}│${N} ${G}x${N}       ${D}Close pane${N}     ${C}│${N}"
echo -e "${C}│${N} ${G}o${N}       ${D}Next pane${N}      ${C}│${N}"
echo -e "${C}│${N} ${G};${N}       ${D}Last pane${N}      ${C}│${N}"
echo -e "${C}│${N} ${G}arrows${N}  ${D}Navigate${N}       ${C}│${N}"
echo -e "${C}│${N} ${G}z${N}       ${D}Toggle zoom${N}    ${C}│${N}"
echo -e "${C}│${N} ${G}!${N}       ${D}Pane to window${N} ${C}│${N}"
echo -e "${C}│${N} ${G}@${N}       ${D}Window to pane${N} ${C}│${N}"
echo -e "${C}│${N} ${G}Space${N}   ${D}Cycle layouts${N}  ${C}│${N}"
echo -e "${C}└─────────────────────────┘${N}"

echo -e "${C}┌─────────────────────────┐${N}"
echo -e "${C}│${N} ${W}RESIZE PANES${N}           ${C}│${N}"
echo -e "${C}├─────────────────────────┤${N}"
echo -e "${C}│${N} ${G}H${N}       ${D}Resize left${N}    ${C}│${N}"
echo -e "${C}│${N} ${G}L${N}       ${D}Resize right${N}   ${C}│${N}"
echo -e "${C}│${N} ${G}K${N}       ${D}Resize up${N}      ${C}│${N}"
echo -e "${C}│${N} ${G}J${N}       ${D}Resize down${N}    ${C}│${N}"
echo -e "${C}│${N} ${G}=${N}       ${D}Equal sizes${N}    ${C}│${N}"
echo -e "${C}└─────────────────────────┘${N}"

echo -e "${C}┌─────────────────────────┐${N}"
echo -e "${C}│${N} ${W}COPY MODE${N}              ${C}│${N}"
echo -e "${C}├─────────────────────────┤${N}"
echo -e "${C}│${N} ${G}[${N}       ${D}Enter copy${N}     ${C}│${N}"
echo -e "${C}│${N} ${G}q${N}       ${D}Exit copy${N}      ${C}│${N}"
echo -e "${C}│${N} ${G}/${N}       ${D}Search fwd${N}     ${C}│${N}"
echo -e "${C}│${N} ${G}?${N}       ${D}Search back${N}    ${C}│${N}"
echo -e "${C}│${N} ${G}Space${N}   ${D}Start select${N}   ${C}│${N}"
echo -e "${C}│${N} ${G}Enter${N}   ${D}Copy${N}           ${C}│${N}"
echo -e "${C}│${N} ${G}]${N}       ${D}Paste${N}          ${C}│${N}"
echo -e "${C}└─────────────────────────┘${N}"

echo -e "${C}┌─────────────────────────┐${N}"
echo -e "${C}│${N} ${W}MISC${N}                   ${C}│${N}"
echo -e "${C}├─────────────────────────┤${N}"
echo -e "${C}│${N} ${G}:${N}       ${D}Run tmux cmd${N}   ${C}│${N}"
echo -e "${C}│${N} ${G}r${N}       ${D}Reload config${N}  ${C}│${N}"
echo -e "${C}│${N} ${G}t${N}       ${D}Show clock${N}     ${C}│${N}"
echo -e "${C}└─────────────────────────┘${N}"

echo -e "${C}┌─────────────────────────┐${N}"
echo -e "${C}│${N} ${W}LINE EDITING${N}           ${C}│${N}"
echo -e "${C}├─────────────────────────┤${N}"
echo -e "${C}│${N} ${G}C-a C-a${N} ${D}Start of line${N} ${C}│${N}"
echo -e "${C}│${N} ${G}C-e${N}     ${D}End of line${N}   ${C}│${N}"
echo -e "${C}└─────────────────────────┘${N}"
echo -e "${D}↑/↓/j/k scroll │ q/Esc quit${N}"
}

# Display with scroll support, exit on q or Escape
display_content() {
    local content
    content=$(generate_content)
    local lines
    IFS=$'\n' read -r -d '' -a lines <<< "$content"
    local total=${#lines[@]}
    local offset=0
    local visible=$(($(tput lines) - 1))

    # Hide cursor and setup terminal
    tput civis
    stty -echo
    trap 'tput cnorm; stty echo; exit' EXIT INT TERM

    while true; do
        clear
        for ((i=offset; i<offset+visible && i<total; i++)); do
            echo -e "${lines[$i]}"
        done

        # Read single keypress
        IFS= read -rsn1 key
        case "$key" in
            q|Q) break ;;
            $'\x1b')  # Escape sequence
                # Check if it's just Escape or an arrow key
                read -rsn1 -t 0.01 seq1
                if [[ -z "$seq1" ]]; then
                    break  # Just Escape, exit
                fi
                read -rsn1 -t 0.01 seq2
                case "$seq2" in
                    A) ((offset > 0)) && ((offset--)) ;;  # Up
                    B) ((offset < total - visible)) && ((offset++)) ;;  # Down
                esac
                ;;
            k) ((offset > 0)) && ((offset--)) ;;  # vim up
            j) ((offset < total - visible)) && ((offset++)) ;;  # vim down
        esac
    done
}

display_content
