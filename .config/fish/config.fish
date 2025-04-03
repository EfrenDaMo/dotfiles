if status is-interactive
    # Commands to run in interactive sessions can go here
end

set fish_greeting

alias ls="lsd -A"

fastfetch

oh-my-posh init fish --config ~/.config/ohmyposh/zen.toml | source
zoxide init --cmd cd fish | source
