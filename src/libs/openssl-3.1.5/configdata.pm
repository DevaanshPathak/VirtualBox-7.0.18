#! /usr/bin/env perl
# -*- mode: perl -*-

package configdata;

use strict;
use warnings;

use Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw(
    %config %target %disabled %withargs %unified_info
    @disablables @disablables_int
);

our %config = (
    "api" => "10101",
    "b32" => "0",
    "b64" => "0",
    "b64l" => "0",
    "bn_ll" => "0",
    "build_metadata" => "",
    "build_type" => "release",
    "builddir" => ".",
    "dynamic_engines" => "1",
    "engdirs" => [
        "afalg"
    ],
    "ex_libs" => [],
    "full_version" => "3.0.1",
    "libdir" => "",
    "major" => "3",
    "makedep_scheme" => "gcc",
    "minor" => "0",
    "openssl_api_defines" => [
        "OPENSSL_CONFIGURED_API=10101"
    ],
    "openssl_feature_defines" => [
        "OPENSSL_RAND_SEED_OS",
        "OPENSSL_THREADS",
        "OPENSSL_NO_ACVP_TESTS",
        "OPENSSL_NO_ASAN",
        "OPENSSL_NO_CRYPTO_MDEBUG",
        "OPENSSL_NO_CRYPTO_MDEBUG_BACKTRACE",
        "OPENSSL_NO_DEVCRYPTOENG",
        "OPENSSL_NO_EGD",
        "OPENSSL_NO_EC_NISTP_64_GCC_128",
        "OPENSSL_NO_EXTERNAL_TESTS",
        "OPENSSL_NO_FIPS_SECURITYCHECKS",
        "OPENSSL_NO_FUZZ_AFL",
        "OPENSSL_NO_FUZZ_LIBFUZZER",
        "OPENSSL_NO_IDEA",
        "OPENSSL_NO_KTLS",
        "OPENSSL_NO_MSAN",
        "OPENSSL_NO_MD4",
        "OPENSSL_NO_RC2",
        "OPENSSL_NO_RC5",
        "OPENSSL_NO_RMD160",
        "OPENSSL_NO_SCTP",
        "OPENSSL_NO_SM2",
        "OPENSSL_NO_SM4",
        "OPENSSL_NO_WHIRLPOOL",
        "OPENSSL_NO_SSL3",
        "OPENSSL_NO_SSL3_METHOD",
        "OPENSSL_NO_TRACE",
        "OPENSSL_NO_UBSAN",
        "OPENSSL_NO_UNIT_TEST",
        "OPENSSL_NO_UPLINK",
        "OPENSSL_NO_WEAK_SSL_CIPHERS",
        "OPENSSL_NO_STATIC_ENGINE"
    ],
    "openssl_other_defines" => [
        "OPENSSL_NO_KTLS"
    ],
    "openssl_sys_defines" => [],
    "openssldir" => "",
    "options" => " no-acvp-tests no-asan no-buildtest-c++ no-crypto-mdebug no-crypto-mdebug-backtrace no-devcryptoeng no-ec_nistp_64_gcc_128 no-egd no-external-tests no-fips no-fips-securitychecks no-fuzz-afl no-fuzz-libfuzzer no-ktls no-md2 no-msan no-rc5 no-sctp no-ssl3 no-ssl3-method no-trace no-ubsan no-unit-test no-uplink no-weak-ssl-ciphers no-zlib no-zlib-dynamic",
    "patch" => "1",
    "rc4_int" => "unsigned int",
    "release_date" => "14 Dec 2021",
    "shlib_version" => "3",
    "sourcedir" => ".",
    "target" => "linux-x86_64",
    "version" => "3.0.1"
);
our %target = (
    "bn_ops" => "SIXTY_FOUR_BIT_LONG",
);
our @disablables = (
    "acvp-tests",
    "afalgeng",
    "aria",
    "asan",
    "asm",
    "async",
    "autoalginit",
    "autoerrinit",
    "autoload-config",
    "bf",
    "blake2",
    "buildtest-c++",
    "bulk",
    "cached-fetch",
    "camellia",
    "capieng",
    "cast",
    "chacha",
    "cmac",
    "cmp",
    "cms",
    "comp",
    "crypto-mdebug",
    "ct",
    "deprecated",
    "des",
    "devcryptoeng",
    "dgram",
    "dh",
    "dsa",
    "dso",
    "dtls",
    "dynamic-engine",
    "ec",
    "ec2m",
    "ec_nistp_64_gcc_128",
    "ecdh",
    "ecdsa",
    "egd",
    "engine",
    "err",
    "external-tests",
    "filenames",
    "fips",
    "fips-securitychecks",
    "fuzz-afl",
    "fuzz-libfuzzer",
    "gost",
    "idea",
    "ktls",
    "legacy",
    "loadereng",
    "makedepend",
    "md2",
    "md4",
    "mdc2",
    "module",
    "msan",
    "multiblock",
    "nextprotoneg",
    "ocb",
    "ocsp",
    "padlockeng",
    "pic",
    "pinshared",
    "poly1305",
    "posix-io",
    "psk",
    "rc2",
    "rc4",
    "rc5",
    "rdrand",
    "rfc3779",
    "rmd160",
    "scrypt",
    "sctp",
    "secure-memory",
    "seed",
    "shared",
    "siphash",
    "siv",
    "sm2",
    "sm3",
    "sm4",
    "sock",
    "srp",
    "srtp",
    "sse2",
    "ssl",
    "ssl-trace",
    "static-engine",
    "stdio",
    "tests",
    "threads",
    "tls",
    "trace",
    "ts",
    "ubsan",
    "ui-console",
    "unit-test",
    "uplink",
    "weak-ssl-ciphers",
    "whirlpool",
    "zlib",
    "zlib-dynamic",
    "ssl3",
    "ssl3-method",
    "tls1",
    "tls1-method",
    "tls1_1",
    "tls1_1-method",
    "tls1_2",
    "tls1_2-method",
    "tls1_3",
    "dtls1",
    "dtls1-method",
    "dtls1_2",
    "dtls1_2-method"
);
our @disablables_int = (
    "crmf"
);
our %disabled = (
    "acvp-tests" => "cascade",
    "asan" => "default",
    "buildtest-c++" => "default",
    "crypto-mdebug" => "default",
    "crypto-mdebug-backtrace" => "default",
    "devcryptoeng" => "default",
    "ec_nistp_64_gcc_128" => "default",
    "egd" => "default",
    "external-tests" => "default",
    "fips" => "default",
    "fips-securitychecks" => "cascade",
    "fuzz-afl" => "default",
    "fuzz-libfuzzer" => "default",
    "ktls" => "default",
    "md2" => "default",
    "msan" => "default",
    "rc5" => "default",
    "sctp" => "default",
    "ssl3" => "default",
    "ssl3-method" => "default",
    "trace" => "default",
    "ubsan" => "default",
    "unit-test" => "default",
    "uplink" => "no uplink_arch",
    "weak-ssl-ciphers" => "default",
    "zlib" => "default",
    "zlib-dynamic" => "default"
);
