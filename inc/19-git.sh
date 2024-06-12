alias commitln="git log --abbrev=12 --pretty=format:'%h (\"%s\")' -1 --decorate=no"
alias gdiff="git diff -w --no-index"
alias chdiff="gdiff --color-words=."
alias gitaa="git commit -a --amend"

function gitmail(){
	mkdir -p sent
	# Thanks https://www.marcusfolkesson.se/blog/get_maintainers-and-git-send-email/
	git send-email --to-cmd="./scripts/get_maintainer.pl --nogit --nogit-fallback --norolestats --nom --nor" --cc-cmd="./scripts/get_maintainer.pl --nogit --nogit-fallback --norolestats --nol" out/* &&
	ask_N "Move out to sent" && mv -vi out/* sent
}

function gitfm(){
	git format-patch --output-directory=out $@ && ./scripts/checkpatch.pl out/* && gitmail
}
