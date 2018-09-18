# GetKeysFromOpenSSL

Attempts to retrieve RSA keys from as many OpenSSL versions as possible

# Note

Only edit and run the `generateKeys.sh` script. It takes care of everything else by itself.

Unless modified, you will find the generated keys in the `keys` folder (created automatically). 

All files with RSA keys within the `keys` folder follow the `<OpenSSL_release>.txt` naming pattern.  

# Key File

Each key file follows the following format. The first line is always exactly the same: `id;n;e;p;q;d;t`. Then there are the RSA keys (one per line) having the particular information in the proper column delimited by `;` (as the first line suggests). 

# generateKeys.sh

This script fetches a list of all OpenSSL releases (referred to as versions),
attempts to install each one of them and on success compiles mains into binaries
(until sucess), then runs the created binary (or continues on to the next release
if neither of the 4 mains compiles successfully), which attempts to extract 
`$COUNT` of `$BITS`-bit keys in a given time (`$TIMEOUT`). 

If not enough time is given, the created files might be incomplete! On the other hand, some binaries might loop when run for certain releases.
 
Details:
1) Check for existence of the `openssl` dir, if it doesn't exist, create it and clone OpenSSL from GitHub in it.
2) Use `git tag` in it to fetch all OpenSSL tags (releases, versions)
3) For each release:
	1) download it from https://github.com/openssl/openssl/archive/`$RELEASE` (downloaded into `$VERSIONS_FOLDER`)
	2) extract it, configure and install
	3) use `Makefile` and attempt to install all 4 given mains, one by one, attempts to run it to generate keys in `$RELEASE`.txt file, on success continues onto the next release (doesn't use all mains - stops at the first successful one)
