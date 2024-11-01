#!/usr/bin/env bash
#
# Rosé Pine - tmux theme
#
# A personalized fork configuration taken from github.com/rose-pine/tmux

export TMUX_ROSEPINE_DIR="$( cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)"

get_tmux_option() {
    local option value default
    option="$1"
    default="$2"
    value="$(tmux show-option -gqv "$option")"

    if [ -n "$value" ]; then
        echo "$value"
    else
        echo "$default"
    fi
}

set() {
    local option=$1
    local value=$2
    tmux_commands+=(set-option -gq "$option" "$value" ";")
}

setw() {
    local option=$1
    local value=$2
    tmux_commands+=(set-window-option -gq "$option" "$value" ";")
}

unset_option() {
    local option=$1
    local value=$2
    tmux_commands+=(set-option -gu "$option" ";")
}


main() {
    local theme
    theme="$(get_tmux_option "@rose_pine_variant" "main")"

    if [[ $theme == main ]]; then
        thm_base="#191724";
        thm_surface="#1f1d2e";
        thm_overlay="#26233a";
        thm_muted="#6e6a86";
        thm_subtle="#908caa";
        thm_text="#e0def4";
        thm_love="#eb6f92";
        thm_gold="#f6c177";
        thm_rose="#ebbcba";
        thm_pine="#31748f";
        thm_foam="#9ccfd8";
        thm_iris="#c4a7e7";
        thm_hl_low="#21202e";
        thm_hl_med="#403d52";
        thm_hl_high="#524f67";
    elif [[ $theme == dawn ]]; then
        thm_base="#faf4ed";
        thm_surface="#fffaf3";
        thm_overlay="#f2e9e1";
        thm_muted="#9893a5";
        thm_subtle="#797593";
        thm_text="#575279";
        thm_love="#b4367a";
        thm_gold="#ea9d34";
        thm_rose="#d7827e";
        thm_pine="#286983";
        thm_foam="#56949f";
        thm_iris="#907aa9";
        thm_hl_low="#f4ede8";
        thm_hl_med="#dfdad9";
        thm_hl_high="#cecacd";
    elif [[ $theme == moon ]]; then
        thm_base="#232136";
        thm_surface="#2a273f";
        thm_overlay="#393552";
        thm_muted="#6e6a86";
        thm_subtle="#908caa";
        thm_text="#e0def4";
        thm_love="#eb6f92";
        thm_gold="#f6c177";
        thm_rose="#ea9a97";
        thm_pine="#3e8fb0";
        thm_foam="#9ccfd8";
        thm_iris="#c4a7e7";
        thm_hl_low="#2a283e";
        thm_hl_med="#44415a";
        thm_hl_high="#56526e";
    fi

    # Aggregating all commands into a single array
    local tmux_commands=()

    # Status bar
    set "status" "on"
    set status-style "fg=$thm_pine,bg=$thm_base"
    # set monitor-activity "on"
    # Leave justify option to user
    # set status-justify "left"
    set status-left-length "200"
    set status-right-length "200"


    # Theoretically messages (need to figure out color placement)
    set message-style "fg=$thm_muted,bg=$thm_base"
    set message-command-style "fg=$thm_base,bg=$thm_gold"

    # Pane styling
    set pane-border-style "fg=$thm_hl_high"
    set pane-active-border-style "fg=$thm_gold"
    set display-panes-active-colour "${thm_text}"
    set display-panes-colour "${thm_gold}"

    # Windows
    setw window-status-style "fg=${thm_iris},bg=${thm_base}"
    setw window-status-activity-style "fg=${thm_base},bg=${thm_rose}"
    setw window-status-current-style "fg=${thm_gold},bg=${thm_base}"

    # Statusline base command configuration: No need to touch anything here
    # Placement is handled below
    # Shows truncated current working directory
    local window_separator 
    window_separator="$(get_tmux_option "@rose_pine_window_separator" "")"
    readonly window_separator 

    # Allows user to set a few custom sections (for integration with other plugins)
    # Before the plugin's left section
    local status_left_prepend_section
    status_left_prepend_section="$(get_tmux_option "@rose_pine_status_left_prepend_section" "")"
    readonly status_left_prepend_section
    #
    # after the plugin's left section
    local status_left_append_section
    status_left_append_section="$(get_tmux_option "@rose_pine_status_left_append_section" "")"
    readonly status_left_append_section
    # Before the plugin's right section
    local status_right_prepend_section
    status_right_prepend_section="$(get_tmux_option "@rose_pine_status_right_prepend_section" "")"
    readonly status_right_prepend_section
    #
    # after the plugin's right section
    local status_right_append_section
    status_right_append_section="$(get_tmux_option "@rose_pine_status_right_append_section" "")"
    readonly status_right_append_section

    # Settings that allow user to choose their own icons and status bar behaviour
    # START
    local current_window_icon
    current_window_icon="$(get_tmux_option "@rose_pine_current_window_icon" "")"
    readonly current_window_icon

    local current_session_icon
    current_session_icon="$(get_tmux_option "@rose_pine_session_icon" "")"
    readonly current_session_icon

    local current_folder_icon
    current_folder_icon="$(get_tmux_option "@rose_pine_folder_icon" "")"
    readonly current_folder_icon

    # Changes the icon / character that goes between each window's name in the bar
    local window_status_separator
    window_status_separator="$(get_tmux_option "@rose_pine_window_status_separator" " ")"

    local field_separator
    # NOTE: Don't remove
    field_separator="$(get_tmux_option "@rose_pine_field_separator" " | " )"
     
    # "│"
    # END

    local spacer
    spacer=" "
    # I know, stupid, right? For some reason, spaces aren't consistent

    # These variables are the defaults so that the setw and set calls are easier to parse

    local show_window_in_window_status
    show_window_in_window_status="#[fg=$thm_iris]#I#[fg=$thm_iris,]$left_separator#[fg=$thm_iris]#W"

    local show_window_in_window_status_current
    show_window_in_window_status_current="#I#[fg=$thm_gold,bg=""]$left_separator#[fg=$thm_gold,bg=""]#W"

    local show_session
    readonly show_session=" #[fg=#{?client_prefix,$thm_love,$thm_text}]$current_session_icon #[fg=#{?client_prefix,$thm_love,$thm_text}]#S$spacer"

    local show_directory
    readonly show_directory="$spacer#[fg=$thm_subtle]$current_folder_icon #[fg=$thm_foam]#{b:pane_current_path} "

    local show_directory_in_window_status
    # BUG: It doesn't let the user pass through a custom window name
    show_directory_in_window_status="#I$left_separator#[fg=$thm_gold,bg=""]#{b:pane_current_path}"

    local show_directory_in_window_status_current
    show_directory_in_window_status_current="#I$left_separator#[fg=$thm_gold,bg=""]#{b:pane_current_path}"

    local left_column
    local right_column

    # TEST: This needs to be tested further
    # TODO: cleanup this thing.
    set status-style "fg=$thm_pine,bg=default"
    show_window_in_window_status="#[fg=$thm_rose,bg=default] #I#[fg=$thm_rose,bg=default]:#[fg=$thm_rose,bg=default]#W"
    show_window_in_window_status_current="#[fg=$thm_pine,bg=default] #I#[fg=$thm_pine,bg=default]:#[fg=$thm_pine,bg=default]#W*"
    show_directory_in_window_status="#[fg=$thm_rose,bg=default]#I#[fg=$thm_rose,bg=default]$left_separator#[fg=$thm_rose,bg=default]#{b:pane_current_path}"
    show_directory_in_window_status_current="#[fg=$thm_pine,bg=default]#I#[fg=$thm_pine,bg=default]:#[fg=$thm_pine,bg=default]#{b:pane_current_path}"
    set window-status-style "fg=$thm_rose,bg=default"
    set window-status-current-style "fg=$thm_pine,bg=default"
    set window-status-activity-style "fg=$thm_rose,bg=default"
    set message-style "fg=$thm_gold,bg=default"


    window_status_format=$show_window_in_window_status
    window_status_current_format=$show_window_in_window_status_current
    setw window-status-format "$window_status_format"
    setw window-status-current-format "$window_status_current_format"

    right_column=$right_colum$show_directory
    left_column=$show_session

    set status-left "$left_column"
    set status-right "$right_column"

    # Variable logic for the window prioritization
    local current_window_count

    current_window_count=$(tmux list-windows | wc -l)
    
    # NOTE: Dont remove this, it can be useful for references
    # setw window-status-format "$window_status_format"
    # setw window-status-current-format "$window_status_current_format"

    # tmux integrated modes
    # setw clock-mode-colour "${thm_love}"
    setw mode-style "fg=${thm_gold}"

    # Call everything to action
    tmux "${tmux_commands[@]}"

}

main "$@"
