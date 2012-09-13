use strict;
use warnings FATAL => 'all';
use ExtUtils::MakeMaker;

WriteMakefile(
  NAME => 'JSONY',
  VERSION => '0.0.1',
  PREREQ_PM => {
    'Pegex' => 0,
  },
  BUILD_REQUIRES => {
    'TestML' => 0,
    'YAML' => 0,
    'JSON' => 0,
  },
  clean => { FILES => 'MANIFEST JSONY' },
);
