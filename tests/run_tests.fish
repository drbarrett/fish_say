#!/usr/bin/env fish

for f in t*.txt
    echo $f
    cat $f | fish_say
end
