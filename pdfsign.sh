#!/bin/bash

# pdfsign
#

if [ $# -ne 3 ] 
then
        echo "Usage: $(basename $0) <unsigned_pdf> <signed_sig_page_pdf> <output_pdf>"
        exit 1
fi

UNSIGNED="$1"
SIG_PAGE="$2"
SIGNED="$3"

uuidfile=/proc/sys/kernel/random/uuid

UUID=$(cat "$uuidfile")
if [ $? -ne 0 ]
then
	echo "failed to read file '$uuidfile'"
	exit 1
fi

outdir="$(dirname "$SIGNED")"
if [ $? -ne 0 ]
then
	echo "failed to resolve parent dir of outfile '$SIGNED'"
	exit 1
fi


tempfile="$outdir/$UUID".pdf

pdfpagecount_exe=pdfpagecount.sh
npages=$("$pdfpagecount_exe" "$UNSIGNED")
if [ $? -ne 0 ]
then
	echo "error calling '$pdfpagecount_exe'"
	exit 1
fi

let "npages_minus_last = $npages - 1"

pdfsplit_exe=pdfsplit.sh
"$pdfsplit_exe" "$UNSIGNED" 1 $npages_minus_last "$tempfile"
if [ $? -ne 0 ]
then
	echo "error calling '$pdfsplit_exe'"
	exit 1
fi

pdfmerge_exe=pdfmerge.sh
"$pdfmerge_exe" "$SIGNED" "$tempfile" "$SIG_PAGE"
if [ $? -ne 0 ]
then
	echo "error calling '$pdfmerge_exe'"
	exit 1
fi

rm -f "$tempfile"

echo "wrote output to '$SIGNED'"

