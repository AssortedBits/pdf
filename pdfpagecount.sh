#!/bin/sh

if [ $# -ne 1 ] 
then
        echo "Usage: $(basename $0) <path/to.pdf>"
        exit 1
fi

gs -q -dNODISPLAY -dNOSAFER -c "($1) (r) file runpdfbegin pdfpagecount = quit"
