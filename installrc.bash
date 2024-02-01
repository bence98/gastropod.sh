#!/bin/bash

DIR="$(dirname "$(realpath "$0")")"

cat <<EOF >>~/.bashrc
#######################
# Added by gastropod.sh
#######################

for _inc_sh in "${DIR}/inc"/*.sh
do
	. "\${_inc_sh}"
done
#PATH="${DIR}/bin":$PATH

#######################
# / End of gastropod.sh
#######################
EOF
