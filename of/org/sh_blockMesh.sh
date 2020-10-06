#!/bin/bash

declare -a arr=(
"yjn2_deck_lower_000"
"yjn2_deck_lower_m25"
"yjn2_deck_lower_p25"
"yjn2_deck_upper_000"
"yjn2_deck_upper_m25"
"yjn2_deck_upper_p25"
"yjn2_rib_lower"
"yjn2_rib_upper"
)

# yjn2_deck
# yjn2_tower_long
# yjn2_tower_trans

arrlength=${#arr[@]}

ii=0

# for heading in ${arr[@]};
for (( i=1; i<${arrlength}+1; i++ ));
do
    REPO_DIR=${arr[$i-1]}
    echo "$i: ${REPO_DIR}"
    ii=$((ii+1))
    cd $yjn2/${REPO_DIR}/
    # cd yjn2/$heading/
    # echo $heading
    blockMesh >& blockMesh.log&
    cd ..
done