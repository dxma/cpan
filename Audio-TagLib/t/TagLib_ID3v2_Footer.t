# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as
# `perl TagLib_ID3v2_Footer.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More q(no_plan);
#use Test::More tests => 1;
BEGIN { use_ok('Audio::TagLib::ID3v2::Footer') };

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

my @methods = qw(new DESTROY render size);
can_ok("Audio::TagLib::ID3v2::Footer", @methods) 							or
	diag("can_ok failed");

my $i = Audio::TagLib::ID3v2::Footer->new();
isa_ok($i, "Audio::TagLib::ID3v2::Footer") 								or
	diag("method new failed");
SKIP: {
skip "more test needed", 1 if 1;
ok(1);
}