#!/usr/bin/env bash

# Zenity menu systems and structure brought to you by https://github.com/starcitizen-lug/lug-helper
# License: GPLv3.0
############################################################################

open_prefix_dir() {
    source /app/constants.sh
    xdg-open "$WINEPREFIX/drive_c/Program Files/Roberts Space Industries"
}

launcher_cfg() {
    source /app/constants.sh
    xdg-open "$launcher_cfg_path/$launcher_cfg"
}

display_logs() {
    source /app/constants.sh
    log_list="\n"

    unset game_versions
    while IFS='' read -r line; do
        game_versions+=("$line")
    done < <(find "$WINEPREFIX/drive_c/Program Files/Roberts Space Industries/StarCitizen" -not -path "**/logbackups/*"  -name "Game.log" -exec realpath {} \;)

    if ! [[ -z ${game_versions[@]} ]]; then
        log_list+="Game log:\n"
        for game_version in "${game_versions[@]}"; do
            log_list+="\n\t<a href='file://$game_version'> $(basename "$(dirname "$game_version")") log </a>\n"
        done
    fi

    if [ -f "$WINEPREFIX/drive_c/users/steamuser/AppData/Roaming/rsilauncher/logs/log.log" ]; then
        log_list+="\nLauncher log:\n\n\t <a href='file://$WINEPREFIX/drive_c/users/steamuser/AppData/Roaming/rsilauncher/logs/log.log'>Launcher log</a>\n"
    fi

    # Format the info header
    message_heading="<b>Star Citizen log files</b>"

    message info "$message_heading\n$log_list"
}

run_winecfg() {
    umu-run winecfg
}

run_control() {
    umu-run control
}

run_regedit() {
    umu-run regedit
}

quit() {
    exit 0
}

# Echo a formatted debug message to the terminal and optionally exit
# Accepts either "continue" or "exit" as the first argument
# followed by the string to be echoed
debug_print() {
    # This function expects two string arguments
    if [ "$#" -lt 2 ]; then
        printf "\nScript error:  The debug_print function expects two arguments. Aborting.\n"
        read -n 1 -s -p "Press any key..."
        exit 0
    fi

    # Echo the provided string and, optionally, exit the script
    case "$1" in
        "continue")
            printf "\n%s\n" "$2"
            ;;
        "exit")
            # Write an error to stderr and exit
            printf "%s\n" "rsi-maintenance.sh: $2" 1>&2
            read -n 1 -s -p "Press any key..."
            exit 1
            ;;
        *)
            printf "%s\n" "rsi-maintenance.sh: Unknown argument provided to debug_print function. Aborting." 1>&2
            read -n 1 -s -p "Press any key..."
            exit 0
            ;;
    esac
}

# Display a message to the user.
# Expects the first argument to indicate the message type, followed by
# a string of arguments that will be passed to zenity or echoed to the user.
#
# To call this function, use the following format: message [type] "[string]"
# See the message types below for instructions on formatting the string.
message() {
    # Sanity check
    if [ "$#" -lt 2 ]; then
        debug_print exit "Script error: The message function expects at least two arguments. Aborting."
    fi

    # Use zenity messages if available
    if [ "$use_zenity" -eq 1 ]; then
        case "$1" in
            "info")
                # info message
                # call format: message info "text to display"
                margs=("--info" "--no-wrap" "--text=")
                shift 1   # drop the message type argument and shift up to the text
                ;;
            "warning")
                # warning message
                # call format: message warning "text to display"
                margs=("--warning" "--text=")
                shift 1   # drop the message type argument and shift up to the text
                ;;
            "error")
                # error message
                # call format: message error "text to display"
                margs=("--error" "--text=")
                shift 1   # drop the message type argument and shift up to the text
                ;;
            "question")
                # question
                # call format: if message question "question to ask?"; then...
                margs=("--question" "--text=")
                shift 1   # drop the message type argument and shift up to the text
                ;;
            "options")
                # formats the buttons with two custom options
                # call format: if message options left_button_name right_button_name "which one do you want?"; then...
                # The right button returns 0 (ok), the left button returns 1 (cancel)
                if [ "$#" -lt 4 ]; then
                    debug_print exit "Script error: The options type in the message function expects four arguments. Aborting."
                fi
                margs=("--question" "--cancel-label=$2" "--ok-label=$3" "--text=")
                shift 3   # drop the type and button label arguments and shift up to the text
                ;;
            *)
                debug_print exit "Script Error: Invalid message type passed to the message function. Aborting."
                ;;
        esac

        # Display the message
        zenity "${margs[@]}""$@" --width="420" --title="RSI Launcher Maintenance"
    else
        # Fall back to text-based messages when zenity is not available
        case "$1" in
            "info")
                # info message
                # call format: message info "text to display"
                printf "\n$2\n\n"
                if [ "$cmd_line" != "true" ]; then
                    # Don't pause if we've been invoked via command line arguments
                    read -n 1 -s -p "Press any key..."
                fi
                ;;
            "warning")
                # warning message
                # call format: message warning "text to display"
                printf "\n$2\n\n"
                read -n 1 -s -p "Press any key..."
                ;;
            "error")
                # error message. Does not clear the screen
                # call format: message error "text to display"
                printf "\n$2\n\n"
                read -n 1 -s -p "Press any key..."
                ;;
            "question")
                # question
                # call format: if message question "question to ask?"; then...
                printf "\n$2\n"
                while read -p "[y/n]: " yn; do
                    case "$yn" in
                        [Yy]*)
                            return 0
                            ;;
                        [Nn]*)
                            return 1
                            ;;
                        *)
                            printf "Please type 'y' or 'n'\n"
                            ;;
                    esac
                done
                ;;
            "options")
                # Choose from two options
                # call format: if message options left_button_name right_button_name "which one do you want?"; then...
                printf "\n$4\n1: $3\n2: $2\n"
                while read -p "[1/2]: " option; do
                    case "$option" in
                        1*)
                            return 0
                            ;;
                        2*)
                            return 1
                            ;;
                        *)
                            printf "Please type '1' or '2'\n"
                            ;;
                    esac
                done
                ;;
            *)
                debug_print exit "Script Error: Invalid message type passed to the message function. Aborting."
                ;;
        esac
    fi
}

############################################################################
######## MAIN ##############################################################
############################################################################

# Zenity availability/version check
use_zenity=0
# Initialize some variables
menu_option_height="0"
menu_text_height_zenity4="0"
menu_height_max="0"
if [ -x "$(command -v zenity)" ]; then
    if zenity --version >/dev/null; then
        use_zenity=1
        zenity_version="$(zenity --version)"

        # Zenity 4.0.0 uses libadwaita, which changes fonts/sizing
        # Add pixels to each menu option depending on the version of zenity in use
        # used to dynamically determine the height of menus
        # menu_text_height_zenity4 = Add extra pixels to the menu title/description height for libadwaita bigness
        if [ "$zenity_version" != "4.0.0" ] &&
            [ "$zenity_version" = "$(printf "%s\n%s" "$zenity_version" "4.0.0" | sort -V | head -n1)" ]; then
            # zenity 3.x menu sizing
            menu_option_height="26"
            menu_text_height_zenity4="0"
            menu_height_max="400"
        else
            # zenity 4.x+ menu sizing
            menu_option_height="26"
            menu_text_height_zenity4="0"
            menu_height_max="800"
        fi
    else
        # Zenity is broken
        debug_print continue "Zenity failed to start. Falling back to terminal menus"
    fi
fi

# Display a menu to the user.
# Uses Zenity for a gui menu with a fallback to plain old text.
#
# How to call this function:
#
# Requires the following variables:
# - The array "menu_options" should contain the strings of each option.
# - The array "menu_actions" should contain function names to be called.
# - The strings "menu_text_zenity" and "menu_text_terminal" should contain
#   the menu description formatted for zenity and the terminal, respectively.
#   This text will be displayed above the menu options.
#   Zenity supports Pango Markup for text formatting.
# - The integer "menu_height" specifies the height of the zenity menu.
# - The string "menu_type" should contain either "radiolist" or "checklist".
# - The string "cancel_label" should contain the text of the cancel button.
#
# The final element in each array is expected to be a quit option.
#
# IMPORTANT: The indices of the elements in "menu_actions"
# *MUST* correspond to the indeces in "menu_options".
# In other words, it is expected that menu_actions[1] is the correct action
# to be executed when menu_options[1] is selected, and so on for each element.
#
# See MAIN at the bottom of this script for an example of generating a menu.
menu() {
    # Sanity checks
    if [ "${#menu_options[@]}" -eq 0 ]; then
        debug_print exit "Script error: The array 'menu_options' was not set before calling the menu function. Aborting."
    elif [ "${#menu_actions[@]}" -eq 0 ]; then
        debug_print exit "Script error: The array 'menu_actions' was not set before calling the menu function. Aborting."
    elif [ -z "$menu_text_zenity" ]; then
        debug_print exit "Script error: The string 'menu_text_zenity' was not set before calling the menu function. Aborting."
    elif [ -z "$menu_text_terminal" ]; then
        debug_print exit "Script error: The string 'menu_text_terminal' was not set before calling the menu function. Aborting."
    elif [ -z "$menu_height" ]; then
        debug_print exit "Script error: The string 'menu_height' was not set before calling the menu function. Aborting."
    elif [ "$menu_type" != "radiolist" ] && [ "$menu_type" != "checklist" ]; then
        debug_print exit "Script error: Unknown menu_type in menu() function. Aborting."
    elif [ -z "$cancel_label" ]; then
        debug_print exit "Script error: The string 'cancel_label' was not set before calling the menu function. Aborting."
    fi

    # Use Zenity if it is available
    if [ "$use_zenity" -eq 1 ]; then
        # Format the options array for Zenity by adding
        # TRUE or FALSE to indicate default selections
        # ie: "TRUE" "List item 1" "FALSE" "List item 2" "FALSE" "List item 3"
        unset zen_options
        for (( i=0; i<"${#menu_options[@]}"-1; i++ )); do
            if [ "$i" -eq 0 ]; then
                # Set the first element
                if [ "$menu_type" = "radiolist" ]; then
                    # Select the first radio button by default
                    zen_options=("TRUE")
                else
                    # Don't select the first checklist item
                    zen_options=("FALSE"quit)
                fi
            else
                # Deselect all remaining items
                zen_options+=("FALSE")
            fi
            # Add the menu list item
            zen_options+=("${menu_options[i]}")
        done

        # Display the zenity radio button menu
        choice="$(zenity --list --"$menu_type" --width="510" --height="$menu_height" --text="$menu_text_zenity" --title="RSI Launcher Maintenance" --hide-header --cancel-label "$cancel_label" --column="" --column="Option" "${zen_options[@]}")"

        # Match up choice with an element in menu_options
        matched="false"
        if [ "$menu_type" = "radiolist" ]; then
            # Loop through the options array to match the chosen option
            for (( i=0; i<"${#menu_options[@]}"; i++ )); do
                if [ "$choice" = "${menu_options[i]}" ]; then
                    # Execute the corresponding action for a radiolist menu
                    ${menu_actions[i]}
                    matched="true"
                    break
                fi
            done
        elif [ "$menu_type" = "checklist" ]; then
            # choice will be empty if no selection was made
            # Unfortunately, it's also empty when the user presses cancel
            # so we can't differentiate between those two states

            # Convert choice string to array elements for checklists
            IFS='|' read -r -a choices <<< "$choice"

            # Fetch the function to be called
            function_call="$(echo "${menu_actions[0]}" | awk '{print $1}')"

            # Loop through the options array to match the chosen option(s)
            unset arguments_array
            for (( i=0; i<"${#menu_options[@]}"; i++ )); do
                for (( j=0; j<"${#choices[@]}"; j++ )); do
                    if [ "${choices[j]}" = "${menu_options[i]}" ]; then
                        arguments_array+=("$(echo "${menu_actions[i]}" | awk '{print $2}')")
                        matched="true"
                    fi
                done
            done

            # Call the function with all matched elements as arguments
            if [ "$matched" = "true" ]; then
                $function_call "${arguments_array[@]}"
            fi
        fi

        # If no match was found, the user clicked cancel
        if [ "$matched" = "false" ]; then
            # Execute the last option in the actions array
            "${menu_actions[${#menu_actions[@]}-1]}"
        fi
    else
        # Use a text menu if Zenity is not available
        clear
        printf "\n$menu_text_terminal\n\n"

        PS3="Enter selection number: "
        select choice in "${menu_options[@]}"
        do
            # Loop through the options array to match the chosen option
            matched="false"
            for (( i=0; i<"${#menu_options[@]}"; i++ )); do
                if [ "$choice" = "${menu_options[i]}" ]; then
                    clear
                    # Execute the corresponding action
                    ${menu_actions[i]}
                    matched="true"
                    break
                fi
            done

            # Check if we're done looping the menu
            if [ "$matched" = "true" ]; then
                # Match was found and actioned, so exit the menu
                break
            else
                # If no match was found, the user entered an invalid option
                printf "\nInvalid selection.\n"
                continue
            fi
        done
    fi
}

# Called when the user clicks cancel on a looping menu
# Causes a return to the main menu
menu_loop_done() {
    looping_menu="false"
}

# If invoked with command line arguments, process them and exit
if [ "$#" -gt 0 ]; then
    while [ "$#" -gt 0 ]
    do
        case "$1" in
            --help | -h )
                printf "RSI Launcher Maintenance
Usage: lug-helper <options>
  -e, --edit            Edit config file
  -l, --logs            View logs
  -w, --winecfg         Run winecfg
  -c, --control         Run wine control panel
  -r, --regedit         Run regedit
  -g, --no-gui          Use terminal menus instead of a Zenity GUI
"
                exit 0
                ;;
            --edit | -e )
                cargs+=("launcher_cfg")
                ;;
            --logs | -l )
                cargs+=("display_logs")
                ;;
            --winecfg | -w )
                cargs+=("run_winecfg")
                ;;
            --control | -c )
                cargs+=("run_control")
                ;;
            --regedit | -r )
                cargs+=("run_regedit")
                ;;
            --no-gui | -g )
                # If zenity is unavailable, it has already been set to 0
                # and this setting has no effect
                use_zenity=0
                ;;
            * )
                printf "$0: Invalid option '%s'\n" "$1"
                exit 0
                ;;
        esac
        # Shift forward to the next argument and loop again
        shift
    done

    # Call the requested functions and exit
    if [ "${#cargs[@]}" -gt 0 ]; then
        cmd_line="true"
        for (( x=0; x<"${#cargs[@]}"; x++ )); do
            ${cargs[x]}
        done
        exit 0
    fi
fi

# LUG Wiki
lug_wiki="https://starcitizen-lug.github.io"
rsi_flatpak="https://github.com/mactan-sc/rsilauncher"

# Set up the main menu heading
menu_heading_zenity="<b><big>Greetings, Space Penguin!</big>\n\nFor help with the game, refer to the LUG Org's wiki <a href='$lug_wiki'>$lug_wiki</a></b>\n\n<b>For help with this tool, refer to the readme: <a href='$rsi_flatpak'>$rsi_flatpak</a></b>"
menu_heading_terminal="Greetings, Space Penguin!\n\nPlease enjoy this selection of maintenance tools\nFor help, refer to the readme: $rsi_flatpak"

while true; do
    # Configure the menu
    menu_text_zenity="$menu_heading_zenity"
    menu_text_terminal="$menu_heading_terminal"
    menu_text_height="320"
    menu_type="radiolist"

    # Configure the menu options
    launcher_cfg_msg="Open config file"
    open_prefix_dir_msg="Open game directory"
    display_logs_msg="Display logs"
    winecfg_msg="Launch winecfg"
    control_msg="Launch wine control panel"
    regedit_msg="Launch regedit"
    quit_msg="Quit"

    # Set the options to be displayed in the menu
    menu_options=("$launcher_cfg_msg" "$open_prefix_dir_msg" "$display_logs_msg" "$winecfg_msg" "$control_msg" "$regedit_msg" "$quit_msg")
    # Set the corresponding functions to be called for each of the options
    menu_actions=("launcher_cfg" "open_prefix_dir" "display_logs" "run_winecfg" "run_control" "run_regedit" "quit")

    # Calculate the total height the menu should be
    # menu_option_height = pixels per menu option
    # #menu_options[@] = number of menu options
    # menu_text_height = height of the title/description text
    # menu_text_height_zenity4 = added title/description height for libadwaita bigness
    menu_height="$(($menu_option_height * ${#menu_options[@]} + $menu_text_height + $menu_text_height_zenity4))"

    # Set the label for the cancel button
    cancel_label="Quit"

    # Call the menu function.  It will use the options as configured above
    menu
done
