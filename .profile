# Include local profile settings (especially PATH customisations).
[[ -r "$HOME/.profile.local" ]] && source "$HOME/.profile.local"

# Set PATH by prepending some extra paths and stripping duplicates.
IFS=:
newpath="$HOME/bin:$HOME/.local/bin"
for dir in $PATH
do
    [[ :$newpath: != *":$dir:"* && -n "$dir" ]] && newpath+=:$dir
done
PATH=$newpath
unset IFS newpath dir
