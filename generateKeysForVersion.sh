#!/bin/bash

VERSIONS_FOLDER=$1
VERSION=$2
BITS=$3
COUNT=$4
TIMEOUT=${5:-5s}

INSTALLDIR=`pwd`/library
OPENSSLDIR=$INSTALLDIR/openssl
mkdir -p $OPENSSLDIR

MAINDIR=`pwd`

cd $VERSIONS_FOLDER
if ! [ -e "$VERSION.tar.gz" ]
then 
	wget --tries=0 --read-timeout=10 https://github.com/openssl/openssl/archive/$VERSION.tar.gz &> /dev/null
fi
cd ..

mkdir $MAINDIR/$VERSION
tar -xf $VERSIONS_FOLDER/$VERSION.tar.gz -C $MAINDIR/$VERSION --strip-components 1
cd $MAINDIR

cd $VERSION
if ! ./config --prefix=$INSTALLDIR --openssldir=$OPENSSLDIR &> /dev/null #removed no-asm
then
	cd ..
	rm -r $VERSION
	exit -1
fi
sed -i 's/-m486//g' Makefile
if ! (make --quiet &> /dev/null && make test &> /dev/null && make --quiet install_sw &> /dev/null)
then
	cd ..
	rm -r $VERSION
	exit -2
fi

cd ..
rm -r $VERSION

MAINS=(OpenSSL OpenSSL1 OpenSSL2 OpenSSL3)
for MAIN in ${MAINS[@]}
do
	make --quiet "$MAIN" >& /dev/null && timeout $5 ./"$MAIN" -b $3 -c $4
	if [ -e $MAIN ]
	then 
		rm "$MAIN"
		exit 0
	fi
done

exit 1 #couldn't compile any main
