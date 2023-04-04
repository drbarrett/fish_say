function fish_say --description="A talking fish!"

  set -l options (fish_opt --short=h --long=help)
  set options $options (fish_opt --short=o --long=outer  --required-val)
  set options $options (fish_opt --short=m --long=middle --required-val)
  set options $options (fish_opt --short=i --long=inner  --required-val)
  set options $options (fish_opt --short=t --long=text   --required-val)
  set options $options (fish_opt --short=b --long=bubble --required-val)
  set options $options (fish_opt --short=M --long=mouth  --required-val)
  set options $options (fish_opt --short=e --long=eye    --required-val)
  set options $options (fish_opt --short=s --long=save   --long-only)
  set options $options (fish_opt --short=d --long=delete   --long-only)
  argparse --name=fish_say $options -- $argv

  if set -q _flag_help
      __fs_usage
      return 0
  end

  # get colors in order, cmd line, global, or default
  set outer  (__fs_choose_opt "$_flag_outer"  "$_fish_say_outer_color"  "red")
  set middle (__fs_choose_opt "$_flag_middle" "$_fish_say_middle_color" "f70")
  set inner  (__fs_choose_opt "$_flag_inner"  "$_fish_say_inner_color"  "yellow")
  set text   (__fs_choose_opt "$_flag_text"   "$_fish_say_text_color"   "white")
  set bubble (__fs_choose_opt "$_flag_bubble" "$_fish_say_bubble_color" "green")

   if set -q _flag_save
       echo saving global colors
       set -U _fish_say_outer_color  $outer
       set -U _fish_say_middle_color $middle
       set -U _fish_say_inner_color  $inner
       set -U _fish_say_text_color   $text
       set -U _fish_say_bubble_color $bubble
       return 0
   else if set -q _flag_delete
       echo clearing global colors
       set -eU _fish_say_outer_color
       set -eU _fish_say_middle_color
       set -eU _fish_say_inner_color
       set -eU _fish_say_text_color
       set -eU _fish_say_bubble_color
       return 0
   end

   # make drawing shortcuts
   set o (set_color $outer)
   set m (set_color $middle)
   set i (set_color $inner)
   set t (set_color $text)
   set b (set_color $bubble)
   set eye (__fs_choose_opt "$_flag_eye" "O" )
   set mouth (__fs_choose_opt "$_flag_mouth" "[" )

   # get the message text
   set msg
   if test -z "$argv"
       # nothing on the command line, use stdin instead
       while read -a -d '\n' stdin
           # expand tabs to 4 spaces, and replace dashes with emdashes to avoid
           #  functions wanting to treat leading dashes as options
           set -a msg (echo $stdin | expand -t4 | sed -E 's/-/—/g')

       end
   else
       set msg $argv
   end

    # find the longest line length
   set max (__fs_max_length $msg)

   # draw the box
   set edge (string pad -c "─" -w $max "─")
   echo "$b┌─$edge─┐"
   for line in $msg
       set line (string pad -r -w $max $line)
       echo "$b│ $t$line $b│"
   end
   echo "$b└─$edge─┘"

    # and now the fish
   echo $b"   \\
   "$b"\\"$o"    ___======____="$m"-"$i"-"$m"-="$o")
    "$b"\\"$o" /T            \_"$i"--="$m"=="$o")
      "$mouth" \ "$m"("$i$eye$m")   "$o"\~    \_"$i"-="$m"="$o")
       \      / )J"$m"~~    "$o"\\"$i"-="$o")
        \\\\___/  )JJ"$m"~"$i"~~   "$o"\)
         \_____/JJJ"$m"~~"$i"~~    "$o"\\
         "$m"/ "$o"\  "$i", \\"$o"J"$m"~~~"$i"~~     "$m"\\
        (-"$i"\)"$o"\="$m"|"$i"\\\\\\"$m"~~"$i"~~       "$m"L_"$i"_
        "$m"("$o"\\"$m"\\)  ("$i"\\"$m"\\\)"$o"_           "$i"\=="$m"__
         "$o"\V    "$m"\\\\"$o"\) =="$m"=_____   "$i"\\\\\\\\"$m"\\\\
                "$o"\V)     \_) "$m"\\\\"$i"\\\\JJ\\"$m"J\)
                            "$o"/"$m"J"$i"\\"$m"J"$o"T\\"$m"JJJ"$o"J)
                            (J"$m"JJ"$o"| \UUU)
                             (UU)"(set_color normal)
end


function __fs_usage
   set helptext 'fish_say - a fish logo / cowsay mashup
usage:
   fish_say [-h] [-omitbMe] [message test]
   command | fish_say [-omitbMe]
   fish_say --save [-omitb]
   fish_say --delete
options:
   -o, --outer=     outer fish color
   -m, --middle=    middle fish color
   -i, --inner=     inner fish color
   -t, --text=      text color
   -b  --bubble=    bubble color
   -M, --mouth=     mouth character
   -e, --eye=       eye character
       --save       save colorscheme
       --delete     delete saved colorscheme

See set_color --help for info on available colors.'

  echo $helptext | fish_say
  return 0
end

function __fs_max_length
  set max 0
  for l in $argv
      set cur (string length "$l")
      if test $cur -gt $max
          set max $cur
      end
  end
  echo $max
end

function __fs_choose_opt -a flag global default
  # pick one of the 3 options in order of presentation
  if test -n $flag
      set color $flag
  else if test -n $global
      set color $global
  else
      set color $default
  end
  echo $color
end
