# GetKeysFromOpenSSL

Attempts to retrieve RSA keys from as many OpenSSL versions as possible

# Note

Only edit and run the `generateKeys.sh` script. It takes care of everything else by itself.

# generateKeys.sh

This script fetches a list of all OpenSSL releases (referred to as versions),
attempts to install each one of them and on success compiles mains into binaries
(until sucess), then runs the created binary (or continues on to the next release
if neither of the 4 mains compiles successfully), which attempts to extract 
$COUNT of $BITS-bit keys in a given time ($TIMEOUT). 
If not enough time is given, the created files might be incomplete!
On the other hand, some binaries might loop when run.
 
Details:
1) Check for existence of "openssl" dir, if it doesn't exist, create it and clone OpenSSL from GitHub in it.
2) Use "git tag" in it to fetch all OpenSSL tags (releases, versions)
3) For each release:
	3.1) download it from https://github.com/openssl/openssl/archive/$RELEASE
		(downloaded into `$VERSIONS_FOLDER`)
	3.2) extract it, configure and install
	3.3) use Makefile and attempt to install all 4 given mains, one by one,
	     attempts to run it to generate keys in $KEY_FOLDER/$RELEASE.txt file,
	     on success continues onto the next release (doesn't use all mains -
	     stops at the first successful one)