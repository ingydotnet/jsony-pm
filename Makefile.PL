use strict;
use warnings FATAL => 'all';
use ExtUtils::MakeMaker;

WriteMakefile(
  NAME => 'JSONY',
  VERSION => '0.0.7',
  PREREQ_PM => {
    'Pegex' => '0.21',
    'boolean' => '0.28',
  },
  BUILD_REQUIRES => {
    'TestML' => '0.28',
    'YAML' => '0.84',
    'JSON' => '2.53',
  },
  clean => { FILES => 'MANIFEST JSONY*' },
);
