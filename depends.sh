#!/bin/bash
exeFile=$1;
outdir=$2;
if [[ -f $exeFile ]]; then
    echo "Using $exeFile as the exe file";
else
    echo "Usage ./depends.sh path/to/exe/file path/to/output/dir";
    exit 1;
fi

if [[ -d $outdir ]]; then
    echo "Using $outdir as the output directory";
else
    echo "Usage ./depends.sh path/to/exe/file path/to/output/dir";
    exit 1;
fi
DEPENDENCIES=$(ldd $exeFile);
LINECOUNT="$(ldd $exeFile | wc -l)";
if [ $LINECOUNT == 1 ] ; then
    echo "$(ldd $exeFile)";
    exit 1
fi

LINECOUNT="$(($LINECOUNT-1))";
echo "Found $LINECOUNT dependencies";
echo "Copying ....";
while read -r line; do
    # SUBSTRING=$(echo $line| cut -d'>' -f 2)
    SUBSTRING=$(echo $(echo $line| cut -d'>' -f 2) | cut -d'(' -f 1);
    if [ -e $SUBSTRING ]
    then
        echo -e "\033[0;33mCopying \033[0;32m$SUBSTRING \033[0;0mto \033[0;34m$outdir";
        $(cp $SUBSTRING $outdir);
    fi
done <<< "$DEPENDENCIES";
printf "\nCopying exe file\n"
echo -e "\033[0;33mCopying \033[0;32m$exeFile \033[0;0mto \033[0;34m$outdir";
$(cp $exeFile $outdir);
printf "\n";
echo -e "\033[0;32mCopied dependencies to $outdir";
echo "$(tput sgr0)";
