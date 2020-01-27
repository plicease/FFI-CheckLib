use strict;
use warnings;
use lib 't/lib';
use Test::More;
use Test2::Plugin::FauxOS 'linux';
use Test2::Tools::NoteStderr qw( note_stderr );

BEGIN {
  local $@ = '';
  eval { require Test::Exit; Test::Exit->import };
  plan skip_all => 'test requires Test::Exit' if $@;
}

use FFI::CheckLib;

@$FFI::CheckLib::system_path = (
  'corpus/unix/usr/lib',
  'corpus/unix/lib',
);

subtest 'check_lib_or_exit' => sub {

  subtest 'found' => sub {
    never_exits_ok { check_lib_or_exit( lib => 'foo' ) };
  };

  subtest 'not found' => sub {
    exits_zero { note_stderr { check_lib_or_exit( lib => 'foobar') } };
  };

};

subtest 'find_lib_or_exit' => sub {

  subtest 'found' => sub {
    my $path;
    never_exits_ok { $path = find_lib_or_exit( lib => 'foo' ) };
    is $@, '', 'no exit';
    ok $path, "path = $path";
    my $path2 = eval { find_lib_or_exit( lib => 'foo' ) };
    is $path, $path2, 'scalar context';
  };

  subtest 'not found' => sub {
    exits_zero { note_stderr { find_lib_or_exit( lib => 'foobar') } };
  };

};

done_testing;
