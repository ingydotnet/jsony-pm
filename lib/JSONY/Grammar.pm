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
      '.rgx' => qr/(?-xism:\G(?:\#\ .*\r?\n|\#\ *\r?\n|\ *\r?\n))/
    },
    'double' => {
      '.rgx' => qr/(?-xism:\G"((?:\\(?:["\\\/bfnrt]|u[0-9a-fA-F]{4})|[^"\x00-\x1f])*)")/
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
        '.rgx' => qr/(?-xism:\G(?:\s|(?:\#\ .*\r?\n|\#\ *\r?\n|\ *\r?\n))*,?(?:\s|(?:\#\ .*\r?\n|\#\ *\r?\n|\ *\r?\n))*)/
      }
    },
    'map' => {
      '.all' => [
        {
          '.rgx' => qr/(?-xism:\G(?:\s|(?:\#\ .*\r?\n|\#\ *\r?\n|\ *\r?\n))*)/
        },
        {
          '.ref' => 'LCURLY'
        },
        {
          '.rgx' => qr/(?-xism:\G(?:\s|(?:\#\ .*\r?\n|\#\ *\r?\n|\ *\r?\n))*)/
        },
        {
          '+min' => 0,
          '.ref' => 'pair'
        },
        {
          '.rgx' => qr/(?-xism:\G(?:\s|(?:\#\ .*\r?\n|\#\ *\r?\n|\ *\r?\n))*)/
        },
        {
          '.ref' => 'RCURLY'
        },
        {
          '.rgx' => qr/(?-xism:\G(?:\s|(?:\#\ .*\r?\n|\#\ *\r?\n|\ *\r?\n))*)/
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
          '.rgx' => qr/(?-xism:\G(?:\s|(?:\#\ .*\r?\n|\#\ *\r?\n|\ *\r?\n))*:?(?:\s|(?:\#\ .*\r?\n|\#\ *\r?\n|\ *\r?\n))*)/
        },
        {
          '.ref' => 'node'
        },
        {
          '.rgx' => qr/(?-xism:\G(?:\s|(?:\#\ .*\r?\n|\#\ *\r?\n|\ *\r?\n))*,?(?:\s|(?:\#\ .*\r?\n|\#\ *\r?\n|\ *\r?\n))*)/
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
          '.rgx' => qr/(?-xism:\G(?:\s|(?:\#\ .*\r?\n|\#\ *\r?\n|\ *\r?\n))*)/
        },
        {
          '.ref' => 'LSQUARE'
        },
        {
          '.rgx' => qr/(?-xism:\G(?:\s|(?:\#\ .*\r?\n|\#\ *\r?\n|\ *\r?\n))*)/
        },
        {
          '+min' => 0,
          '.ref' => 'node',
          '.sep' => {
            '+eok' => 1,
            '.rgx' => qr/(?-xism:\G(?:\s|(?:\#\ .*\r?\n|\#\ *\r?\n|\ *\r?\n))*,?(?:\s|(?:\#\ .*\r?\n|\#\ *\r?\n|\ *\r?\n))*)/
          }
        },
        {
          '.rgx' => qr/(?-xism:\G(?:\s|(?:\#\ .*\r?\n|\#\ *\r?\n|\ *\r?\n))*)/
        },
        {
          '.ref' => 'RSQUARE'
        },
        {
          '.rgx' => qr/(?-xism:\G(?:\s|(?:\#\ .*\r?\n|\#\ *\r?\n|\ *\r?\n))*)/
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
          '.rgx' => qr/(?-xism:\G(?:\s|(?:\#\ .*\r?\n|\#\ *\r?\n|\ *\r?\n))*:(?:\s|(?:\#\ .*\r?\n|\#\ *\r?\n|\ *\r?\n))*)/
        },
        {
          '.ref' => 'node'
        },
        {
          '.rgx' => qr/(?-xism:\G(?:\s|(?:\#\ .*\r?\n|\#\ *\r?\n|\ *\r?\n))*)/
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
          '.rgx' => qr/(?-xism:\G(?:\s|(?:\#\ .*\r?\n|\#\ *\r?\n|\ *\r?\n))*\-\ +)/
        },
        {
          '.all' => [
            {
              '+min' => 0,
              '.ref' => 'node',
              '.sep' => {
                '+eok' => 1,
                '.rgx' => qr/(?-xism:\G(?:\ *,\ *\r?\n(?:\s|(?:\#\ .*\r?\n|\#\ *\r?\n|\ *\r?\n))*|\ +))/
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
