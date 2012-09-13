package JSONY::Grammar;
use base 'Pegex::Grammar';

use constant file => 'share/jsony.pgx';

sub make_tree {
  {
    '+grammar' => 'jsony',
    '+toprule' => 'jsony',
    '+version' => '0.0.1',
    'EOL' => {
      '.rgx' => qr/(?-xism:\G\r?\n)/
    },
    'LCURLY' => {
      '.rgx' => qr/(?-xism:\G\{)/
    },
    'LSQUARE' => {
      '.rgx' => qr/(?-xism:\G\[)/
    },
    'RCURLY' => {
      '.rgx' => qr/(?-xism:\G\})/
    },
    'RSQUARE' => {
      '.rgx' => qr/(?-xism:\G\])/
    },
    'bare' => {
      '.rgx' => qr/(?-xism:\G([^\s\{\}\[\]'",]*[^\s\{\}\[\]'",:]))/
    },
    'comment' => {
      '.rgx' => qr/(?-xism:\G\# .*\n)/
    },
    'double' => {
      '.rgx' => qr/(?-xism:\G"([^"]*)")/
    },
    'jsony' => {
      '.any' => [
        {
          '.ref' => 'seq'
        },
        {
          '.ref' => 'map'
        },
        {
          '.ref' => 'top_seq'
        },
        {
          '.ref' => 'top_map'
        },
        {
          '.ref' => 'list'
        }
      ]
    },
    'list' => {
      '+min' => 0,
      '.ref' => 'node',
      '.sep' => {
        '+eok' => 1,
        '.rgx' => qr/(?-xism:\G(?:\s|\# .*\n)*,?(?:\s|\# .*\n)*)/
      }
    },
    'map' => {
      '.all' => [
        {
          '.rgx' => qr/(?-xism:\G(?:\s|\# .*\n)*)/
        },
        {
          '.ref' => 'LCURLY'
        },
        {
          '.rgx' => qr/(?-xism:\G(?:\s|\# .*\n)*)/
        },
        {
          '+min' => 0,
          '.ref' => 'pair'
        },
        {
          '.rgx' => qr/(?-xism:\G(?:\s|\# .*\n)*)/
        },
        {
          '.ref' => 'RCURLY'
        },
        {
          '.rgx' => qr/(?-xism:\G(?:\s|\# .*\n)*)/
        }
      ]
    },
    'node' => {
      '.any' => [
        {
          '.ref' => 'map'
        },
        {
          '.ref' => 'seq'
        },
        {
          '.ref' => 'scalar'
        }
      ]
    },
    'pair' => {
      '.all' => [
        {
          '.ref' => 'string'
        },
        {
          '.rgx' => qr/(?-xism:\G(?:\s|\# .*\n)*:?(?:\s|\# .*\n)*)/
        },
        {
          '.ref' => 'node'
        },
        {
          '.rgx' => qr/(?-xism:\G(?:\s|\# .*\n)*,?(?:\s|\# .*\n)*)/
        }
      ]
    },
    'scalar' => {
      '.any' => [
        {
          '.ref' => 'double'
        },
        {
          '.ref' => 'single'
        },
        {
          '.ref' => 'bare'
        }
      ]
    },
    'seq' => {
      '.all' => [
        {
          '.rgx' => qr/(?-xism:\G(?:\s|\# .*\n)*)/
        },
        {
          '.ref' => 'LSQUARE'
        },
        {
          '.rgx' => qr/(?-xism:\G(?:\s|\# .*\n)*)/
        },
        {
          '+min' => 0,
          '.ref' => 'node',
          '.sep' => {
            '+eok' => 1,
            '.rgx' => qr/(?-xism:\G(?:\s|\# .*\n)*,?(?:\s|\# .*\n)*)/
          }
        },
        {
          '.rgx' => qr/(?-xism:\G(?:\s|\# .*\n)*)/
        },
        {
          '.ref' => 'RSQUARE'
        },
        {
          '.rgx' => qr/(?-xism:\G(?:\s|\# .*\n)*)/
        }
      ]
    },
    'single' => {
      '.rgx' => qr/(?-xism:\G'([^']*)')/
    },
    'string' => {
      '.ref' => 'scalar'
    },
    'top_map' => {
      '+min' => 1,
      '.all' => [
        {
          '.ref' => 'string'
        },
        {
          '.rgx' => qr/(?-xism:\G(?:\s|\# .*\n)*:(?:\s|\# .*\n)*)/
        },
        {
          '.ref' => 'node'
        },
        {
          '.rgx' => qr/(?-xism:\G(?:\s|\# .*\n)*)/
        }
      ]
    },
    'top_seq' => {
      '+min' => 1,
      '.ref' => 'top_seq_entry'
    },
    'top_seq_entry' => {
      '.all' => [
        {
          '.rgx' => qr/(?-xism:\G(?:\s|\# .*\n)*\- +)/
        },
        {
          '.all' => [
            {
              '+min' => 0,
              '.ref' => 'node',
              '.sep' => {
                '+eok' => 1,
                '.rgx' => qr/(?-xism:\G +)/
              }
            },
            {
              '.any' => [
                {
                  '.ref' => 'comment'
                },
                {
                  '.ref' => 'EOL'
                }
              ]
            }
          ]
        }
      ]
    }
  }
}

1;
