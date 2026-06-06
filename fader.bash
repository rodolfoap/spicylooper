#!/bin/bash
cd $(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
[ -z "$1" ] && { echo "Usage: $0 [ SPL_DIRECTORY/ ]"; exit; }
export SOURCE=$(basename ${1})
export TARGET=$(basename ${1})_faded
mkdir -p ${TARGET}
fadein() { (set -x; ffmpeg -loglevel quiet -stats -y -i ${SOURCE}/${1} -af "afade=in:d=0.001" ${TARGET}/${1};); }
fadeall(){ (set -x; ffmpeg -loglevel quiet -stats -y -i ${SOURCE}/${1} -af "afade=in:d=0.001,areverse,afade=in:d=0.001,areverse" ${TARGET}/${1};); }
fadeout(){ (set -x; ffmpeg -loglevel quiet -stats -y -i ${SOURCE}/${1} -af "areverse,afade=in:d=0.001,areverse" ${TARGET}/${1};); }
for a in $(cd ${SOURCE}; ls   intro.*); do fadeout $a; done
for a in $(cd ${SOURCE}; ls [abcde].*); do fadeall $a; done
for a in $(cd ${SOURCE}; ls     end.*); do fadein  $a; done
