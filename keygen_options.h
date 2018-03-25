#include <stdio.h>
#include <unistd.h>
#include <ctype.h>

int keygen_options_fips(int argc, char **argv, int *bitlength, int *count, int *fips)
{
    int c;
    opterr = 0;
    
    if (fips != NULL && (argc < 5 || argc > 6)) {
        fprintf (stderr, "Usage: %s -b bit-length -c key-count [-f]\n", argv[0]);
        fprintf (stderr, "          -f enables FIPS mode\n");
        return(1);
    } else if (fips == NULL && argc != 5) {
        fprintf (stderr, "Usage: %s -b bit-length -c key-count\n", argv[0]);
        return(1);
    }

    while ((c = getopt (argc, argv, "b:c:f")) != -1)
        switch (c)
        {
            case 'b':
                *bitlength = atoi(optarg);
                break;
            case 'c':
                *count = atoi(optarg);
                break;
            case 'f':
                if (fips != NULL) {
                    *fips = 1;
                    break;
                }
            case '?':
                if (optopt == 'c' || optopt == 'b')
                    fprintf (stderr, "Option -%c requires a numerical argument.\n", optopt);
                else if (isprint (optopt))
                    fprintf (stderr, 
                    "Unknown option `-%c'. Valid options are -b \
                    for bit length and -c for key count.\n", optopt);
                else
                    fprintf (stderr,
                    "Unknown option character `\\x%x'. Valid options are -b \
                    for bit length and -c for key count.\n", optopt);
                return(1);
            default:
                return(1);
        }
    return 0;
}

int keygen_options(int argc, char **argv, int *bitlength, int *count)
{
    return keygen_options_fips(argc, argv, bitlength, count, NULL);
}

