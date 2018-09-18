#!/bin/bash

# This script fetches a list of all OpenSSL releases (referred to as versions),
# attempts to install each one of them and on success compiles mains into binaries
# (until sucess), then runs the created binary (or continues on to the next release
# if neither of the 4 mains compiles successfully), which attempts to extract 
# $COUNT of $BITS-bit keys in a given time ($TIMEOUT). 
# If not enough time is given, the created files might be incomplete!
# On the other hand, some binaries might loop when run.
# 
# Details:
# 1) Check for existence of "openssl" dir, if it doesn't exist, create it
# and clone OpenSSL from GitHub in it.
# 2) Use "git tag" in it to fetch all OpenSSL tags (releases, versions)
# 3) For each release:
#	3.1) download it from https://github.com/openssl/openssl/archive/$RELEASE
#		(downloaded into $VERSIONS_FOLDER)
#	3.2) extract it, configure and install
#	3.3) use Makefile and attempt to install all 4 given mains, one by one,
#	     attempts to run it to generate keys in $KEY_FOLDER/$RELEASE.txt file,
#	     on success continues onto the next release (doesn't use all mains -
#	     stops at the first successful one)

BITS=1024	# key length
COUNT=10	# number of keys per version
TIMEOUT=5s	# max time of run of main (binary)

KEY_FOLDER=keys			# folder for files of generated keys
VERSIONS_FOLDER=versions	# folder for downloaded OpenSSL releases (tar.gz)

# Setting these options to false speeds up following runs.
REMOVE_OPENSSL=false	# remove "openssl" dir when done
REMOVE_VERSIONS=false	# remove $VERSIONS_FOLDER when done

########################
# END OF EDITABLE AREA #
########################

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


