package JSONY::Grammar;
use base 'Pegex::Grammar';

use constant file => '../jsony-pgx/jsony.pgx';

sub make_tree {
  {
    '+grammar' => 'jsony',
    '+toprule' => 'jsony',
    '+version' => '0.0.1',
    'EOL' => {
      '.rgx' => qr/\G\r?\n/
    },
    '_' => {
      '.rgx' => qr/\G(?:\s|(?:\#\ .*\r?\n|\#\r?\n|\ *\r?\n))*/
    },
    'bare' => {
      '.rgx' => qr/\G([^\s\{\}\[\]'",]*[^\s\{\}\[\]'",:])/
    },
    'comment' => {
      '.rgx' => qr/\G(?:\#\ .*\r?\n|\#\r?\n|\ *\r?\n)/
    },
    'double' => {
      '.rgx' => qr/\G"((?:\\(?:["\\\/bfnrt]|u[0-9a-fA-F]{4})|[^"\x00-\x1f])*)"/
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
      '+max' => 1,
      '.all' => [
        {
          '.ref' => 'node'
        },
        {
          '+min' => 0,
          '-flat' => 1,
          '.all' => [
            {
              '.rgx' => qr/\G(?:\s|(?:\#\ .*\r?\n|\#\r?\n|\ *\r?\n))*,?(?:\s|(?:\#\ .*\r?\n|\#\r?\n|\ *\r?\n))*/
            },
            {
              '.ref' => 'node'
            }
          ]
        },
        {
          '+max' => 1,
          '.rgx' => qr/\G(?:\s|(?:\#\ .*\r?\n|\#\r?\n|\ *\r?\n))*,?(?:\s|(?:\#\ .*\r?\n|\#\r?\n|\ *\r?\n))*/
        }
      ]
    },
    'map' => {
      '.all' => [
        {
          '.rgx' => qr/\G(?:\s|(?:\#\ .*\r?\n|\#\r?\n|\ *\r?\n))*\{(?:\s|(?:\#\ .*\r?\n|\#\r?\n|\ *\r?\n))*/
        },
        {
          '+min' => 0,
          '.ref' => 'pair'
        },
        {
          '.rgx' => qr/\G(?:\s|(?:\#\ .*\r?\n|\#\r?\n|\ *\r?\n))*\}(?:\s|(?:\#\ .*\r?\n|\#\r?\n|\ *\r?\n))*/
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
          '.rgx' => qr/\G(?:\s|(?:\#\ .*\r?\n|\#\r?\n|\ *\r?\n))*:?(?:\s|(?:\#\ .*\r?\n|\#\r?\n|\ *\r?\n))*/
        },
        {
          '.ref' => 'node'
        },
        {
          '.rgx' => qr/\G(?:\s|(?:\#\ .*\r?\n|\#\r?\n|\ *\r?\n))*,?(?:\s|(?:\#\ .*\r?\n|\#\r?\n|\ *\r?\n))*/
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
          '.rgx' => qr/\G(?:\s|(?:\#\ .*\r?\n|\#\r?\n|\ *\r?\n))*\[(?:\s|(?:\#\ .*\r?\n|\#\r?\n|\ *\r?\n))*/
        },
        {
          '+max' => 1,
          '.all' => [
            {
              '.ref' => 'node'
            },
            {
              '+min' => 0,
              '-flat' => 1,
              '.all' => [
                {
                  '.rgx' => qr/\G(?:\s|(?:\#\ .*\r?\n|\#\r?\n|\ *\r?\n))*,?(?:\s|(?:\#\ .*\r?\n|\#\r?\n|\ *\r?\n))*/
                },
                {
                  '.ref' => 'node'
                }
              ]
            },
            {
              '+max' => 1,
              '.rgx' => qr/\G(?:\s|(?:\#\ .*\r?\n|\#\r?\n|\ *\r?\n))*,?(?:\s|(?:\#\ .*\r?\n|\#\r?\n|\ *\r?\n))*/
            }
          ]
        },
        {
          '.rgx' => qr/\G(?:\s|(?:\#\ .*\r?\n|\#\r?\n|\ *\r?\n))*\](?:\s|(?:\#\ .*\r?\n|\#\r?\n|\ *\r?\n))*/
        }
      ]
    },
    'single' => {
      '.rgx' => qr/\G'([^']*)'/
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
          '.rgx' => qr/\G(?:\s|(?:\#\ .*\r?\n|\#\r?\n|\ *\r?\n))*:(?:\s|(?:\#\ .*\r?\n|\#\r?\n|\ *\r?\n))*/
        },
        {
          '.ref' => 'node'
        },
        {
          '.ref' => '_'
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
          '.rgx' => qr/\G(?:\s|(?:\#\ .*\r?\n|\#\r?\n|\ *\r?\n))*\-\ +/
        },
        {
          '.all' => [
            {
              '+max' => 1,
              '.all' => [
                {
                  '.ref' => 'node'
                },
                {
                  '+min' => 0,
                  '-flat' => 1,
                  '.all' => [
                    {
                      '.rgx' => qr/\G(?:\ *,\ *\r?\n(?:\s|(?:\#\ .*\r?\n|\#\r?\n|\ *\r?\n))*|\ +)/
                    },
                    {
                      '.ref' => 'node'
                    }
                  ]
                },
                {
                  '+max' => 1,
                  '.rgx' => qr/\G(?:\ *,\ *\r?\n(?:\s|(?:\#\ .*\r?\n|\#\r?\n|\ *\r?\n))*|\ +)/
                }
              ]
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
