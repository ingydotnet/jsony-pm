use strict;
use warnings FATAL => 'all';
use ExtUtils::MakeMaker;

WriteMakefile(
  NAME => 'JSONY',
  VERSION => '0.0.5',
  PREREQ_PM => {
    'Pegex' => '0.20',
    'boolean' => '0.28',
  },
  BUILD_REQUIRES => {
    'TestML' => '0.27',
    'YAML' => '0.84',
    'JSON' => '2.53',
  },
  clean => { FILES => 'MANIFEST JSONY*' },
);
