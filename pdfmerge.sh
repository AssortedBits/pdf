#!/bin/sh

# pdfmerge 
#

if [ $# -lt 2 ] 
then
        echo "Usage: $(basename $0) <output_file> <first_input_file> [other_input_files...]"
        exit 1
fi

OUTFILE="$1"
shift

gs -dNOPAUSE -sDEVICE=pdfwrite -sOUTPUTFILE="$OUTFILE" -dBATCH "$@"
