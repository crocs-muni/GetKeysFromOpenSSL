INSTALLDIR = $(shell pwd)/library

LDFLAGS = -I$(INSTALLDIR)/include -L$(INSTALLDIR)/lib -lcrypto -ldl -pthread # removed -static flag
CFLAGS = -g -Wall -Wextra -Wl,-rpath,$(INSTALLDIR)/lib
CC = gcc

OpenSSL3: OpenSSL3.c
	$(CC) $(CFLAGS) OpenSSL3.c -o OpenSSL3 $(LDFLAGS)

OpenSSL2: OpenSSL2.c
	$(CC) $(CFLAGS) OpenSSL2.c -o OpenSSL2 $(LDFLAGS)

OpenSSL1: OpenSSL1.c
	$(CC) $(CFLAGS) OpenSSL1.c -o OpenSSL1 $(LDFLAGS)

OpenSSL: OpenSSL.c
	$(CC) $(CFLAGS) OpenSSL.c -o OpenSSL $(LDFLAGS)

SharedLibraryTest: sharedLibraryTest.c
	$(CC) $(CFLAGS) -O1 sharedLibraryTest.c -o SharedLibraryTest $(LDFLAGS)

clean:
	rm -f *.o $(BINS)
