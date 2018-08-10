#!/bin/sh 

# usage
if [ $# -eq 0 ]; then
  echo "Usage: $0 dose"
  echo "Example: $0 45.6";
  exit;
fi

#ctffindoption.txt
FILE=ctffindoptions.txt     
if [ -f $FILE ]; then
   echo "File $FILE exists."
else
   echo "File $FILE does not exist."
   echo "copy $FILE from /usr/local/ctffindPlot/tests/$FILE and re-run."
   exit;
fi

# directory
for dir in rawTIFF alignedMRC alignedJPG ;
  do
    if [ ! -d "$dir" ]; then
      mkdir $dir
    fi
  done
  
# run them in tmux 
tmux new-session -d -s framewatcher "framewatcher -gpu 0 -bin 2 -pr $PWD/rawTIFF \ 
             -after 'mv %{rootName}_powpair.jpg $PWD/alignedJPG' \
             -kV 200 -dtotal $1"
tmux new-window -n ctffindPlot "ctffindPlot"
echo
echo A tmux session and window are created. To attach, type \"tmux a\"
echo
