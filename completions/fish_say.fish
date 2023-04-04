complete -x -c fish_say -s h -l help
complete -x -c fish_say -s o -l outer --exclusive -a '(set_color --print-colors)'
complete -x -c fish_say -s m -l middle --exclusive -a '(set_color --print-colors)'
complete -x -c fish_say -s i -l inner --exclusive -a '(set_color --print-colors)'
complete -x -c fish_say -s t -l text --exclusive -a '(set_color --print-colors)'
complete -x -c fish_say -s b -l bubble --exclusive -a '(set_color --print-colors)'
complete -x -c fish_say -s e -l eye --exclusive -a 'O 0 @ X'
complete -x -c fish_say -s M -l mouth --exclusive -a '[ L \> /<'
complete -f -c fish_say -l save
complete -f -c fish_say -l delete

