function clear
    set terminal_type (fastfetch | rg "Terminal" | sed -n 's/.*Terminal => //p')
    
    command clear

    if test "$terminal_type" != "tmux"
        fastfetch
    end
end
