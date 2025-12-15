function mkwd(){
	mkdir -p "$@" && cd "$_"
}

function findeditor(){
	[ "x$EDITOR" != "x" ] && echo "$EDITOR" && return

	[ "x$EDITORPATH" = "x" ] && EDITORPATH="/usr/bin/mcedit /bin/nano /usr/bin/nano /usr/bin/vim /usr/bin/vi /usr/bin/vim.tiny"

	for editor in $EDITORPATH
	do
	[ -x "$editor" ] && echo "$editor" && return
	done
}

function ednote(){
	[ "x$1" == "x" ] && echo "Missing parameter!" >&2 && return 1
	$(findeditor) "$1"_$(date +"%y-%m-%d").md
}

function upg(){
	if [ "x$(id -u)" != "x0" ] && [ -x "/usr/bin/sudo" ]
	then
		SUDO=/usr/bin/sudo
	fi

	if [ -x "/usr/bin/apt-get" ]
	then
		${SUDO} /usr/bin/apt-get update && ${SUDO} /usr/bin/apt-get upgrade -y
	elif [ -x "/usr/bin/pacman" ]
	then
		${SUDO} /usr/bin/pacman -Syu
	else
		echo "Unsupported package manager!" >&2
		return 1
	fi
}

function ask_N(){
	read -p "$1? (y/N) " && [[ "${REPLY,,}" = "y" ]]
}

# Source: https://askubuntu.com/a/1164880
function title() {
	# Set terminal tab title. Usage: title "new tab name"
	prefix=${PS1%%\\a*}                  # Everything before: \a
	search=${prefix##*;}                 # Eeverything after: ;
	esearch="${search//\\/\\\\}"         # Change \ to \\ in old title
	PS1="${PS1/$esearch/$@}"             # Search and replace old with new
}

# Sets title to current dir's name
# Not dynamic, i.e. you can cd away and title will be kept
function dtitle() {
	title "$(basename "${PWD}")"
}
