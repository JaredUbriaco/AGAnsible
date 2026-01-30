#!/bin/bash
# AGAnsible Text Menu - Pick one option at a time (run a single playbook, run all localhost tests, etc.)
# In this project, each "test" is an Ansible playbook (a YAML file that runs tasks).
#
# Usage: ./menu.sh   or   agansible menu

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# Build list of runnable playbooks (category:path), excluding templates
PLAYBOOKS=()
while IFS= read -r -d '' f; do
    name=$(basename "$f" .yml)
    dir=$(basename "$(dirname "$f")")
    [[ "$name" == "playbook_template" ]] && continue
    PLAYBOOKS+=("$dir/$name|$f")
done < <(find playbooks -maxdepth 2 -name "*.yml" -print0 2>/dev/null | sort -z)
# Sort by category then name
PLAYBOOKS=($(printf '%s\n' "${PLAYBOOKS[@]}" | sort -t'|' -k1,1))

run_one_playbook() {
    local path="$1"
    if [[ ! -f "$path" ]]; then
        echo -e "${RED}Playbook not found: $path${NC}"
        return 1
    fi
    echo -e "${BLUE}Running: $path${NC} (inventory: default, e.g. localhost)${NC}"
    ANSIBLE_FORKS=1 ansible-playbook --forks 1 "$path"
}

run_all_localhost() {
    if [[ -f ./test_localhost.sh ]]; then
        ./test_localhost.sh
    else
        echo -e "${RED}test_localhost.sh not found${NC}"
        return 1
    fi
}

run_all_tests() {
    if [[ -f ./test_all.sh ]]; then
        ./test_all.sh
    else
        echo -e "${RED}test_all.sh not found${NC}"
        return 1
    fi
}

do_verify() {
    if [[ -f ./verify.sh ]]; then
        ./verify.sh
    else
        echo -e "${RED}verify.sh not found${NC}"
        return 1
    fi
}

show_playbook_submenu() {
    local n=${#PLAYBOOKS[@]}
    echo ""
    echo -e "${CYAN}── Run one playbook (choose a number) ──${NC}"
    echo -e "   ${BOLD}In this project, each test is a playbook.${NC} Pick one to run against localhost."
    echo ""
    local i=1
    for entry in "${PLAYBOOKS[@]}"; do
        label="${entry%%|*}"
        path="${entry##*|}"
        echo -e "   ${GREEN} $i)${NC} $label"
        ((i++)) || true
    done
    echo -e "   ${YELLOW} 0)${NC} Back to main menu"
    echo ""
    read -rp "Choice [0-$n]: " choice
    if [[ -z "$choice" || "$choice" == "0" ]]; then
        return 0
    fi
    if [[ "$choice" =~ ^[0-9]+$ ]] && (( choice >= 1 && choice <= n )); then
        entry="${PLAYBOOKS[$((choice-1))]}"
        path="${entry##*|}"
        run_one_playbook "$path"
    else
        echo -e "${RED}Invalid choice.${NC}"
    fi
}

main_menu() {
    while true; do
        echo ""
        echo -e "${BOLD}═══════════════════════════════════════${NC}"
        echo -e "${BOLD}  AGAnsible Menu${NC}  (tests = playbooks)"
        echo -e "${BOLD}═══════════════════════════════════════${NC}"
        echo ""
        echo "  1) Run one playbook (e.g. ping test on localhost)"
        echo "  2) Run all localhost tests"
        echo "  3) Run all tests"
        echo "  4) Verify installation"
        echo "  0) Quit"
        echo ""
        read -rp "Choice [0-4]: " main_choice

        case "$main_choice" in
            1) show_playbook_submenu ;;
            2) run_all_localhost ;;
            3) run_all_tests ;;
            4) do_verify ;;
            0|q|Q) echo "Bye."; exit 0 ;;
            *) echo -e "${RED}Invalid choice.${NC}" ;;
        esac

        if [[ "$main_choice" != "0" && "$main_choice" != "q" && "$main_choice" != "Q" ]]; then
            echo ""
            read -rp "Press Enter to return to menu..."
        fi
    done
}

# Ensure we're in project root and have playbooks
if [[ ! -d "playbooks" ]]; then
    echo -e "${RED}Error: run this script from the AGAnsible project root (where playbooks/ is).${NC}"
    exit 1
fi

main_menu
