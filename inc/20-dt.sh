dtdiffer() {
	SOURCE="$1"
	DEST="$2"

	WORKDIR=$(mktemp -d)
	trap -- "rm -rf $WORKDIR; trap -- - RETURN" RETURN
	mkdir -p -- $WORKDIR/{src,dst}

	if [ -d "$SOURCE" ]
	then
		for dtb in "$SOURCE"/*.dtb
		do
			dts="$(basename ${dtb/dtb/dts})"
			dtc -sq "$dtb" >"$WORKDIR/src/$dts"
			dtc -sq "$DEST/$(basename "$dtb")" >"$WORKDIR/dst/$dts"
		done
		isdts=
	else
		dtc -sq "$SOURCE" >"$WORKDIR/src.dts"
		dtc -sq "$DEST" >"$WORKDIR/dst.dts"
		isdts=.dts
	fi

	gdiff $WORKDIR/{src,dst}$isdts
}
