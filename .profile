# Set PATH by prepending some extra paths and stripping duplicates.
IFS=:
newpath="$HOME/.npm-global/bin:$HOME/bin:$HOME/.local/bin"
for dir in $PATH
do
    [[ :$newpath: != *:$dir:* && -n $dir ]] && newpath=$newpath:$dir
done
PATH=$newpath
unset IFS newpath dir
