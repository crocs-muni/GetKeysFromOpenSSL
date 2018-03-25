/*
 *  Copyright (C) 2016, Matus Nemec, All Rights Reserved
 *  SPDX-License-Identifier: Apache-2.0
 *
 *  Licensed under the Apache License, Version 2.0 (the "License"); you may
 *  not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 *  WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */
/*
 * OpenSSL FIPS 140-2 variant
 * 
 * RSA_X931_generate_key_ex is used in FIPS 140-2 mode
 * 
 * Requried steps:
 * - build and install the OpenSSL FIPS module
 * - build and install OpenSSL that is configured to use the FIPS module
 * - activate the FIPS mode FIPS_mode_set(1)
 * - generate keys as usual
 */

#include <stdio.h>
#include <string.h>
#include <time.h>
#include <openssl/err.h>
#include <openssl/bn.h>
#include <openssl/rsa.h>
#include <openssl/pem.h>
#include <openssl/crypto.h>
#include <ctype.h>
#include <stdlib.h>
#include <unistd.h>

#include "keygen_options.h"

int generate_key(int bits, int count)
{
    int             ret = 0;
    RSA             *r = NULL;
    BIGNUM          *bne = NULL; 
    unsigned long   e = RSA_F4;

    clock_t start, end;

    bne = BN_new();
    ret = BN_set_word(bne,e);
    if (ret != 1){
    	BN_free(bne);
	return 1;
    }

    fprintf(stdout, "id;n;e;p;q;d;t\n");

    for (int i = 0; i < count; i++) {
        start = clock();
 	
	r = RSA_new();
        r = RSA_generate_key(bits, e, NULL, NULL);
        if (ret != 1){
            goto free_all;
        }

        end = clock();
	
	const BIGNUM *n = r->n;
	const BIGNUM *d = r->d;

	const BIGNUM *p = r->p;
	const BIGNUM *q = r->q;
        
        fprintf(stdout, "%d;", i);
        BN_print_fp(stdout, n);
        fprintf(stdout, ";");
        BN_print_fp(stdout, bne);
        fprintf(stdout, ";");
        BN_print_fp(stdout, p);
        fprintf(stdout, ";");
        BN_print_fp(stdout, q);
        fprintf(stdout, ";");
        BN_print_fp(stdout, d);
        fprintf(stdout, ";%ld\n", end - start);

free_all:
        RSA_free(r);

        if (ret != 1) {
	    BN_free(bne);
            ERR_load_crypto_strings();
            ERR_print_errors_fp(stderr);
            break;
        }      
        
    }   
 
    BN_free(bne);
    return (ret == 1);
}
 
int main (int argc, char **argv)
{
  int bitlength = 512;
  int count = 1;
  int fips = 0;
    
    if(keygen_options_fips(argc, argv, &bitlength, &count, &fips)) {
       return EXIT_FAILURE;
    }

    if(fips)
    {
        ERR_load_crypto_strings();
        ERR_print_errors_fp(stderr);
        exit(5);
    }

    generate_key(bitlength, count);
        return 0;
}
