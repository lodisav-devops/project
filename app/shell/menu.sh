#!/usr/bin/env bash

menu_process() {
    printf "%b" "${line}\n"\
    "${bpur}Select an action:${rst}\n"\
    "${line}\n"\
    "${bylw}1${rst}) ${wht}install${rst}\n"\
    "${bylw}2${rst}) ${wht}uninstall${rst}\n"\
    "${line}\n"\
    "${bylw}Q${rst}) ${red}Exit${rst}\n"
    while :; do
        echo
        read -rsN1 -p"${ylw}Your choice?${rst} " y
        case $y in
            1)
                echo "${wht}Install...${rst}"
                action install
                break
            ;;
            2)
                echo "${wht}Uninstall...${rst}"
                action uninstall
                break
            ;;
            q|Q)
                echo "${wht}Quiting...${rst}"
                exit 0
            ;;
            *)
                echo "${red}Wrong! Try again?${rst}"
            ;;
        esac
    done
}
