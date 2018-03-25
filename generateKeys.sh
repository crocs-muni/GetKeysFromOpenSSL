#!/bin/bash

BITS=1024
COUNT=10
TIMEOUT=5s

REMOVE_OPENSSL=false
REMOVE_VERSIONS=false

KEY_FOLDER=keys
VERSIONS_FOLDER=versions

if ! [ -d "$VERSIONS_FOLDER" ]
then
	mkdir $VERSIONS_FOLDER
fi

if ! [ -d "$KEY_FOLDER" ]
then
	mkdir $KEY_FOLDER
fi

# download OpenSSL if needed
if [ ! -d openssl ]
then
	git clone https://github.com/openssl/openssl.git
fi

( cd openssl; git tag; ) | while read TAG # for each tag
do	
	if ! bash generateKeysForVersion.sh $VERSIONS_FOLDER $TAG $BITS $COUNT $TIMEOUT > $KEY_FOLDER/$TAG.txt
	then
		rm $KEY_FOLDER/$TAG.txt
	fi
done

if "$REMOVE_OPENSSL"
then
	rm -r openssl
fi

if "$REMOVE_VERSIONS"
then
	rm -r $VERSIONS_FOLDER
fi


