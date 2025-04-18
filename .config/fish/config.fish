# Disable the gretting
set fish_greeting

# Define colors
set -l foreground c8d3f5
set -l selection 2d3f76
set -l comment 636da6
set -l red ff757f
set -l orange ff966c
set -l yellow ffc777
set -l green c3e88d
set -l purple fca7ea
set -l cyan 86e1fc
set -l pink c099ff

# Set colors
set -g fish_color_normal $foreground
set -g fish_color_command $cyan
set -g fish_color_keyword $pink
set -g fish_color_quote $yellow
set -g fish_color_redirection $foreground
set -g fish_color_end $orange
set -g fish_color_option $pink
set -g fish_color_error $red
set -g fish_color_param $purple
set -g fish_color_comment $comment
set -g fish_color_selection --background=$selection
set -g fish_color_search_match --background=$selection
set -g fish_color_operator $green
set -g fish_color_escape $pink
set -g fish_color_autosuggestion $comment

# Set pager colors
set -g fish_pager_color_progress $comment
set -g fish_pager_color_prefix $cyan
set -g fish_pager_color_completion $foreground
set -g fish_pager_color_description $comment
set -g fish_pager_color_selected_background --background=$selection

# Set key binds
bind \ef accept-autosuggestion

# Set abbreviations
abbr -a g git
abbr -a gst "git status"
abbr -a gc "git commit"
abbr -a gp "git push"
abbr -a gl "git pull"
abbr -a gf "git fetch"

# Set envs
set -Ux EDITOR nvim

# Set aliases
alias ls="lsd -A"

# Init the apps
oh-my-posh init fish --config ~/.config/ohmyposh/zen.toml | source
fzf --fish | source
zoxide init --cmd cd fish | source

if status is-interactive
	# Run on start up
	fastfetch
end
