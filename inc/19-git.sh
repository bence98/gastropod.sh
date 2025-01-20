alias commitln="git log --abbrev=12 --pretty=format:'%h (\"%s\")' -1 --decorate=no"
alias gdiff="git diff -w --no-index"
alias chdiff="gdiff --color-words=."
alias gitaa="git commit -a --amend"
alias isgitwd="git rev-parse --is-inside-work-tree >/dev/null 2>&1"
alias pgitwd="git rev-parse --show-toplevel 2>/dev/null"

function mbsweep(){
	if isgitwd
	then
		VER=1
		case "$1" in
			-v*)
				VER=$((${1#-v}))
				shift
			;;
		esac
		TARGETDIR="sent/$(git branch --show-current)/v${VER}"
	else
		TARGETDIR="sent"
	fi

	MBOXES=${@:-sent/*.patch}
	mkdir -p "${TARGETDIR}" && mv -vi ${MBOXES} "${TARGETDIR}"
}

function gitmail(){
	MBOXES=${@:-out/*}
	mkdir -p sent
	# Thanks https://www.marcusfolkesson.se/blog/get_maintainers-and-git-send-email/
	git send-email --to-cmd="./scripts/get_maintainer.pl --nogit --nogit-fallback --norolestats --nom --nor" --cc-cmd="./scripts/get_maintainer.pl --nogit --nogit-fallback --norolestats --nol" ${MBOXES} &&
	ask_N "Move out to sent" && mv -vi ${MBOXES} sent && return 0
	ask_N "Clear out" && rm -vf ${MBOXES}
}

function gitfm(){
	git format-patch --notes --output-directory=out "$@" &&
	{
		if [ -z "${CHECKPATCH_NO_STRICT}" ]
		then
			STRICT=--strict
		else
			STRICT=
		fi

		[ ! -x ./scripts/checkpatch.pl ] || ./scripts/checkpatch.pl ${STRICT} out/*
	} && {
		[ ! -x ./scripts/get_maintainer.pl ] || gitmail
	}
}

function gitchg(){
	git diff --exit-code $@ && git reset --hard "${@: -1}"
}

# Reset Branch (to remote-tracked upstream)
# Arg: branch name
function gitrb(){
	local _branch="$1"
	local _upstream="$(git for-each-ref --format='%(upstream:short)' "refs/heads/${_branch}")"

	git branch -f "${_branch}" "${_upstream}"
}
