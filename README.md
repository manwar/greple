# NAME

greple - grep with multiple keywords

# SYNOPSIS

__greple__ [ __-options__ ] pattern [ file... ]

    pattern           'positive -negative ?alternative'

    -e pattern        regex pattern match across line boundary
    -v pattern        regex pattern not to be matched
    --le pattern      lexical expression (same as bare pattern)
    --re pattern      regular expression
    --fe pattern      fixed expression

## __OPTIONS__

    -i                ignore case
    -l                list filename only
    -c                print count of matched block only
    -o                print only the matching part
    -n                print line number
    -h                do not display filenames
    -H                always display filenames
    -p                paragraph mode
    -A[n]             after match context
    -B[n]             before match context
    -C[n]             after and before match context
    -f file           file contains search pattern
    -d flags          display info (f:file d:dir c:count m:misc s:stat)

    --man             show manual page
    --color=when      use termninal color (auto, always, never)
    --colormode=mode  Red, Green, Blue, Cyan, Magenta, Yellow, White,
                      Standout, bolD, Underline
    --nocolor         Same as --color=never
    --icode=name      specify file encoding
    --ocode=name      specify output encoding
    --block=pattern   specify the block of records
    --blockend=s      specify the block end mark (Default: "--\n")
    --inside=pattern  limit matching area
    --outside=pattern opposite of --inside
    --strict          strict mode for --inside/outside --block
    --join            delete newline in the matched part
    --joinby=string   replace newline in the matched text by string
    --if=filter       set filter command
    --of=filter       output filter command
    --[no]pgp         decrypt and find PGP file (Default: false)
    --pgppass=phrase  pgp passphrase
    --[no]decompress  process compressed data (Default: true)
    --readlist        get filenames from stdin
    --glob=glob       glob target files
    --norc            skip reading startup file

# DESCRIPTION

__greple__ has almost the same function as Unix command [egrep(1)](http://man.he.net/man1/egrep) but
the search is done in the manner similar to search engine.  For
example, next command print lines those contain all of 'foo' and 'bar'
and 'baz'.

    greple 'foo bar baz' ...

Each word can be found in any order and/or any place in the string.
So this command find all of following texts.

    foo bar baz
    baz bar foo
    the foo, bar and baz

If you want to use OR syntax, prepend question ('?') mark on each
token, or use regular expression.

    greple 'foo bar baz ?yabba ?dabba ?doo'
    greple 'foo bar baz yabba|dabba|doo'

This command will print the line which contains all of 'foo', 'bar'
and 'baz' and one or more from 'yabba', 'dabba' or 'doo'.

NOT operator can be specified by prefixing the token by minus ('-')
sign.  Next example will show the line which contain both 'foo' and
bar' but none of 'yabba' or 'dabba' or 'doo'.  It is ok to put '+'
mark for positive matching pattern.

    greple 'foo bar -yabba -dabba -doo'
    greple '+foo +bar -yabba|dabba|doo'

This can be written as this using __-e__ and __-v__ option.

    greple -e foo -e bar -v yabba -v dabba -v doo
    greple -e foo -e bar -v 'yabba|dabba|doo'

## __LINE ACROSS MATCH__

__greple__ also search the pattern across the line boundaries.  This is
especially useful to handle Asian multi-byte text.  Japanese text can
be separated by newline almost any place of the text.  So the search
pattern may spread out on multiple lines.  As for ascii text, space
character in the pattern matches any kind of space including newline.
Use __-e__ option to use this capability because space is taken as a
token separator in the bare pattern.



# OPTIONS

## __PATTERNS__

If specific option is not provided, __greple__ takes the first argument
as a search pattern specified by __-le__ option.  All of these patterns
can be specified multiple times.

Command itself is written in Perl, and any kind of Perl style regular
expression can be used in patterns.

#### __--le__=_pattern_

Treat the string as a collection of tokens separated by spaces.  Each
token is interpreted by the first character.  Token start with '-'
means negative pattern, '?' means alternative, optional '+' and
anything other means positive match.

Next example print lines which contains 'foo' and 'bar', and one or
more of 'yabba' and 'dabba', and none of 'bar' and 'doo'.

    greple --le='foo bar -baz ?yabba ?dabba -doo'

Multiple '?' preceded tokens are treated all mixed together.  That
means '?A|B ?C|D' is equivalent to '?A|B|C|D'.  If you want to mean
'(A or B) and (C or D)', use AND syntax instead: 'A|B C|D'.

#### __-e__ _pattern_, __--and__=_pattern_

Specify positive match token.  Next two commands are equivalent.

    greple 'foo bar baz'
    greple -e foo -e bar -e baz

First character is not interpreted, so next commands will search the
pattern '-baz'.

    greple -e -baz

Space characters are treated specially by __-e__ and __-v__ options.
They are replaced by the pattern which matches any number of
white spaces including newline.  So the pattern can be expand to
multiple lines.  Next commands search the series of word 'foo', 'bar'
and 'baz' even if they are separated by newlines.

    greple -e 'foo bar baz'

#### __-v__ _pattern_, __--not__=_pattern_

Specify negative match token.  Because it does not affect to the bare
pattern argument, you can narrow down the search result like this.

    greple foo pattern file
    greple foo pattern file -v bar
    greple foo pattern file -v bar -v baz

#### __--re__=_pattern_

Specify regular expression.  No special treatment for space and wide
characters.

#### __--fe__=_pattern_

Specify fixed string pattern, like fgrep.



## __GREP LIKE OPTIONS__

#### __-i__

Ignore case.

#### __-l__

List filename only.

#### __-c__, __--count__

Print count of matched block.

#### __-n__

Show line number.

#### __-h__, __--no-filename__

Do not display filename.

#### __-H__

Display filename always.

#### __-o__

Print matched string only.

#### __-A__[_n_], __--after-context__[=_n_]

#### __-B__[_n_], __--before-context__[=_n_]

#### __-C__[_n_], __--context__[=_n_]

Print _n_-blocks before/after matched string.  The value _n_ can be
omitted and the default is 2.  When used with paragraph option __-p__,
_n_ means number of paragraphs.

Actually, these options expand the area of logical operation.  It
means

    grep -C1 'foo bar baz'

matches following text.

    foo
    bar
    baz

Moreover

    greple -C1 'foo baz'

also matches this text, because matching blocks around 'foo' and 'bar'
overlaps each other and makes single block.

#### __-f__ _file_, __--file__=_file_

Specify the file which contains search pattern.  When file contains
multiple lines, patterns on each lines are search in OR context.  The
line starting with sharp (#) character is ignored.

#### __--__[__no__]__decompress__

Switch for handling compressed files.  Default is true.

#### __--color__=_auto_|_always_|_never_, __--nocolor__

Use terminal color capability to emphasize the matched text.  Default
is 'auto': effective when STDOUT is a terminal and option __-o__ is not
given, not otherwise.  Option value 'always' and 'never' will work as
expected.

Option __--nocolor__ is alias for __--color__=_never_.

#### __--colormode__=_RGBCYMWrgbcymwUBR_, __--quote__=_start_,_end_

Specify color mode.  Use combination string from R(ed), G(reen),
B(lue), C(yan), M(agenta), Y(ellow), W(hite), U(nderline), (bol)D,
S(tandout).  Lowercase form of RGBW means background color.  Default
is RD: RED and BOLD.

If the mode string contains comma ',' character, they are used to
quote the matched string.  If you want to quote the pattern by angle
bracket, use like this.

    greple --quote='<,>' pattern



## __OTHER OPTIONS__

#### __-p__, __--paragraph__

Print the paragraph which contains the pattern.  Each paragraph is
delimited by two or more successive newline characters by default.  Be
aware that an empty line is not paragraph delimiter if which contains
space characters.  Example:

    greple -np 'setuid script' /usr/man/catl/perl.l

    greple -pe '^struct sockaddr' /usr/include/sys/socket.h

It changes the unit of context specified by __-A__, __-B__, __-C__
options.

#### __--block__=_pattern_, __--block__=_&sub_

Specify the record block to display.

Next command prints entire file because it handles the whole text as a
single large block.

    greple --block='(?s).*'

Next is almost same as __--paragraph__ option.

    greple --block='(.+\n)+'

Next command treat the data as a series of 10-line blocks.

    greple -n --block='(.*\n){1,10}'

When blocks are not continuous and there are gaps between them, the
match occurred outside blocks are ignored.

If multiple block options are supplied, overlapping blocks are merged
into single block.

Please be aware that this option is sometimes quite time consuming,
because it finds all blocks before processing.

#### __--blockend__=_string_

Change the end mark displayed after __-pABC__ or __--block__ options.
Default value is "--\n".

#### __--inside__=_pattern_

#### __--outside__=_pattern_

Option __--inside__ and __--outside__ limit the text area to be matched.
For simple example, if you want to find string 'and' not in the word
'command', it can be done like this.

    greple --outside=command and

The block can be larger and expand to multiple lines.  Next command
searches from C source, excluding comment part.

    greple --outside '(?s)/\*.*?\*/'

Next command searches only from POD part of the perl script.

    greple --inside='(?s)^=.*?(^=cut|\Z)'

#### __--inside__=_&function_

#### __--outside__=_&function_

If the pattern name begins by ampersand (&) character, it is treated
as a name of subroutine which returns a list of blocks to exclude.
Using this option, user can use arbitrary function to determine from
what part of the text they want to search.  User defined function is
written in `.greplerc` file or explicitly included by __--require__
option.

    greple --require mycode.pl --outside '&myfunc' pattern *

Argument can be specified after function name with '=' character.
Next example is equivalent to the above example.

    sub myfunc {
        my($pattern) = @_;
        my @matched;
        my $re = qr/$pattern/m;
        while (/$re/g) {
            push(@matched, [ $-[0], $+[0] ]);
        }
        @matched;
    }

    greple --outside '&myfunc=(?s)/\*.*?\*/' if *.c

__--outside__ and __--inside__ option can be specified mixed together
and multiple times.

#### __--strict__

Limit the match area strictly.

By default, __--block__, __--inside__, __--outside__ option allows
partial match within the specified area.  For example,

    greple --inside and command

matches pattern `command` because the part of matched string is
included in specified inside-area.  Partial match failes when option
__--strict__ provided, and longer string never matches within shorter
area.

#### __--join__

#### __--joinby__=_string_

Convert newline character found in matched string to empty or specifed
_string_.  Using __--join__ with __-o__ (only-matching) option, you can
collect searching sentence list in one per line form.  This is almost
useless for English text but sometimes useful for Japanese text.  For
example next command prints the list of KATAKANA words.

    greple -ho --join '\p{utf8::InKatakana}[\n\p{utf8::InKatakana}]*'

#### __--icode__=_code_

Target file is assumed to be encoded in utf8 by default.  Use this
option to set specific encoding.  When handling Japanese text, you may
choose from 7bit-jis (jis), euc-jp or shiftjis (sjis).  Multiple code
can be supplied using multiple option or combined code names with
space or comma, then file encoding is guessed from those code sets.
Use encoding name 'guess' for automatic recognition from default code
list which is euc-jp and 7bit-jis.  Following commands are all
equivalent.

    greple --icode=guess ...
    greple --icode=euc-jp,7bit-jis ...
    greple --icode=euc-jp --icode=7bit-jis ...

Default code set are always included suspect code list.  If you have
just one code adding to suspect list, put + mark before the code name.
Next example does automatic code detection from euc-kr, ascii, utf8
and UTF-16/32.

    greple --icode=+euc-kr ...

#### __--ocode__=_code_

Specify output code.  Default is utf8.

#### __--cut__=_n_, __--allow__=_n_

Option to compromize matching condition.  Option __--cut__ specifiy the
number to cut down positive match count, and __--allow__ is the number
of negative condition to be overlooked.

    greple --cut=1 --allow=1 'foo bar baz -yabba -dabba -doo'

Above command prints the line which contains two or more from 'foo',
'bar' and 'baz', and does not include more than one of 'yabba',
'dabba' or 'doo'.

#### __--if__=_filter_, __--if__=_EXP_:_filter_:_EXP_:_filter_:...

You can specify filter command which is applied to each files before
search.  If only one filter command is specified, it is applied to all
files.  If filter information include multiple fields separated by
colons, first field will be perl expression to check the filename
saved in variable $_.  If it successes, next filter command is pushed.
These expression and command list can be repeated.

    greple --if=rev perg
    greple --if='/\.tar$/:tar tvf -'

If the command doesn't accept standard input as processing data, you
may be able to use special device:

    greple --if='nm /dev/stdin' crypt /usr/lib/lib*

Filters for compressed and gzipped file is set by default unless
__--nodecompress__ option is given.  Default action is like this:

    greple --if='s/\.Z$//:zcat:s/\.g?z$//:gunzip -c'

#### __--of__=_filter_

Specify output filter commands.

#### __--require__=_filename_

Include arbitrary perl program.

#### __--pgp__

Invoke PGP decrypt command for files end with .pgp, .gpg or .asc.  PGP
passphrase is asked only once at the beginning of command execution.

#### __--pgppass__=_phrase_

You can specify PGP passphrase by this option.  Generally, it is not
recommended to use.

#### __--chdir__=_directory_

Change directory before processing.

#### __--glob__=_pattern_

Get files matches to specified pattern and use them as a target
files.  Using __--chdir__ and __--glob__ makes easy to use __greple__ for
fixed common job.

#### __--readlist__

Get filenames from standard input.  Read standard input and use each
line as a filename for searching.  You can feed the output from other
command like [find(1)](http://man.he.net/man1/find) for __greple__ with this option.  Next example
searches string from files modified within 7 days:

    find . -mtime -7 -print | greple -S pattern

#### __--man__

Show manual page.

#### __--norc__

Do not read startup file: `~/.greplerc`.

#### __-d__ _flags_

Display informations.  Various kind of debug, diagnostic, monitor
information can be display by giving appropriate flag to -d option.

    f: processing file name
    s: statistic information
    m: misc debug information
    o: option related information
    p: run 'ps' command before termination (on Unix)



# ENVIRONMENT and STARTUP FILE

Environment variable GREPLEOPTS is used as a default options.  They
are inserted before command line options.

Before starting execution, _greple_ reads the file named `.greplerc`
on user's home directory.  In rc file, user can define own options.
There are three directives rc file: 'option', 'define' and 'help'.
First argument of 'option' directive is user defined option name.  The
rest are processed by _shellwords_ routine defined by
Text::ParseWords module.  Be sure that this module sometimes requires
escape backslashes.

Any kind of string can be used for option name but it is not combined
with other options.

    option --fromcode --outside='(?s)\/\*.*?\*\/'
    option --fromcomment --inside='(?s)\/\*.*?\*\/'

Another directive 'define' is almost same as 'option', but argument is
not processed by _shellwords_ and treated just a simple text.
Metacharacters can be included without escaping.  Defined string
replacement is done only in definition in option argument.  If you
want to use the word in command line, use option directive instead.
If 'help' directive is used for same option name, it will be printed
in usage message.

    define :kana: \p{utf8::InKatakana}
    option --kanalist --color=never -o --join --re ':kana:[:kana:\n]+'
    help   --kanalist List up Katakana string

When _greple_ found `__CODE__` line in `.greplerc` file, the rest of
the file is evaluated as a Perl program.  You can define your own
subroutines which can be used by --inside and --outside options.  For
those subroutines, file content will be provided by global variable
$_.  Expected response from the subroutine is the list of numbers,
which is made up by start and end offset pairs.

For example, suppose that the following function is defined in your
`.greplerc` file.

    __CODE__
    sub odd_line {
        my @list;
        my $i;
        while (/.*\n/g) {
            push(@list, [ $-[0], $+[0] ]) if ++$i % 2;
        }
        @list;
    }

You can use next command to search pattern included in odd number
lines.

    % greple --inside &odd_line patten files...

If you do not want to evaluate those programs in all invocation of the
command, use --require option to include arbitrary perl program files.



# HISTORY

Most capability of __greple__ is derived from __mg__ command, which has
been developing from early 1990's by the same author.  Because modern
standard __grep__ family command becomes to have similar capabilities,
it is a time to clean up entire functionarities, totally remodel the
option interfaces, and change the command name. (2013.11)

# AUTHOR

Kazumasa Utashiro



# SEE ALSO

[grep(1)](http://man.he.net/man1/grep), [perl(1)](http://man.he.net/man1/perl)

[github](http://kaz-utashiro.github.io/greple/)



# LICENSE

Copyright (c) 1991-2013 Kazumasa Utashiro

Use and redistribution for ANY PURPOSE are granted as long as all
copyright notices are retained.  Redistribution with modification is
allowed provided that you make your modified version obviously
distinguishable from the original one.  THIS SOFTWARE IS PROVIDED BY
THE AUTHOR ''AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES ARE
DISCLAIMED.