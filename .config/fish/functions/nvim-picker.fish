function nvim-picker
    set -l config (fd --max-depth 1 --glob 'nvim-*' ~/.config | fzf --prompt="Neovim Configs > " --height=~50% --layout=reverse --border --exit-0)
    
    if test -z "$config"
        echo "No config selected"
        return
    end

    set -l config_name (basename $config)

    switch $config_name
        case 'nvim-stable'
            bob use stable
            env NVIM_APPNAME=nvim-stable nvim $argv
        case 'nvim-nightly'
            bob use nightly
            env NVIM_APPNAME=nvim-nightly nvim $argv
        case '*'
            env NVIM_APPNAME=$config_name nvim $argv
    end
end
