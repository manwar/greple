# NAME

greple - extensible grep with lexical expression and region handling

# VERSION

Version 8.30

# SYNOPSIS

**greple** \[**-M**_module_\] \[ **-options** \] pattern \[ file... \]

    PATTERN
      pattern              'and +must -not ?alternative &function'
      -e pattern           pattern match across line boundary
      -r pattern           pattern cannot be compromised
      -v pattern           pattern not to be matched
      --le pattern         lexical expression (same as bare pattern)
      --re pattern         regular expression
      --fe pattern         fixed expression
      --file file          file contains search pattern
    MATCH
      -i                   ignore case
      --need=[+-]n         required positive match count
      --allow=[+-]n        acceptable negative match count
      --matchcount=n[,m]   specify required match count for each block
    STYLE
      -l                   list filename only
      -c                   print count of matched block only
      -n                   print line number
      -H, -h               do or do not display filenames
      -o                   print only the matching part
      -m n[,m]             max count of blocks to be shown
      -A,-B,-C [n]         after/before/both match context
      --join               delete newline in the matched part
      --joinby=string      replace newline in the matched text by string
      --nonewline          do not add newline character at block end
      --filestyle=style    how filename printed (once, separate, line)
      --linestyle=style    how line number printed (separate, line)
      --separate           set filestyle and linestyle both "separate"
      --format LABEL=...   define line number and file name format
    FILE
      --glob=glob          glob target files
      --chdir=dir          change directory before search
      --readlist           get filenames from stdin
    COLOR
      --color=when         use terminal color (auto, always, never)
      --nocolor            same as --color=never
      --colormap=color     R, G, B, C, M, Y etc.
      --colorful           use default multiple colors
      --colorindex=flags   color index method: Ascend/Descend/Block/Random
      --ansicolor=s        ANSI color 16, 256 or 24bit
      --[no]256            same as --ansicolor 256 or 16
      --regioncolor        use different color for inside/outside regions
      --uniqcolor          use different color for unique string
      --random             use random color each time
      --face               set/unset visual effects
    BLOCK
      -p                   paragraph mode
      --all                print whole data
      --block=pattern      specify the block of records
      --blockend=s         specify the block end mark (Default: "--\n")
    REGION
      --inside=pattern     select matches inside of pattern
      --outside=pattern    select matches outside of pattern
      --include=pattern    reduce matches to the area
      --exclude=pattern    reduce matches to outside of the area
      --strict             strict mode for --inside/outside --block
    CHARACTER CODE
      --icode=name         specify file encoding
      --ocode=name         specify output encoding
    FILTER
      --if,--of=filter     input/output filter command
      --pf=filter          post process filter command
      --noif               disable default input filter
    RUNTIME FUNCTION
      --print=func         print function
      --continue           continue after print function
      --begin=func         call function before search
      --end=func           call function after search
      --prologue=func      call function before command execution
      --epilogue=func      call function after command execution
    OTHER
      --norc               skip reading startup file
      --man                display command or module manual page
      --show               display module file
      --require=file       include perl program
      --conceal=type       conceal run time errors
      --persist            continue even after encoding error
      -d flags             display info (f:file d:dir c:color m:misc s:stat)

# DESCRIPTION

## MULTIPLE KEYWORDS

**greple** has almost the same function as Unix command [egrep(1)](http://man.he.net/man1/egrep) but
the search is done in a manner similar to Internet search engine.
For example, next command print lines those contain all of \`foo' and
bar' and \`baz'.

    greple 'foo bar baz' ...

Each word can be found in any order and/or any place in the string.
So this command find all of following texts.

    foo bar baz
    baz bar foo
    the foo, bar and baz

If you want to use OR syntax, prepend question (\`?') mark on each
token, or use regular expression.

    greple 'foo bar baz ?yabba ?dabba ?doo'
    greple 'foo bar baz yabba|dabba|doo'

This command will print the line which contains all of \`foo', \`bar'
and \`baz' and one or more of \`yabba', \`dabba' or \`doo'.

NOT operator can be specified by prefixing the token by minus (\`-')
sign.  Next example will show the line which contain both \`foo' and
bar' but none of \`yabba' or \`dabba' or \`doo'.

    greple 'foo bar -yabba -dabba -doo'

This can be written as this using **-e** and **-v** option.

    greple -e foo -e bar -v yabba -v dabba -v doo
    greple -e foo -e bar -v 'yabba|dabba|doo'

If \`+' is placed to positive matching pattern, that pattern is marked
as required, and required match count is automatically set to the
number of required patterns.  So

    greple '+foo bar baz'

commands implicitly set the option `--need 1`, and consequently print
all lines including \`foo'.  In other words, it makes other patterns
optional.  If you want to search lines which includes either or both
of \`bar' and \`baz', use like this:

    greple '+foo bar baz' --need 2
    greple '+foo bar baz' --need +1

## FLEXIBLE BLOCKS

Default data block **greple** search and print is a line.  Using
**--paragraph** (or **-p** in short) option, series of text separated
by empty line is taken as a record block.  So next command will print
whole paragraph which contains the word \`foo', \`bar' and \`baz'.

    greple -p 'foo bar baz'

Option **--all** takes whole file as a single block.  So next command
find files which contains these strings, and print the all contents.

    greple --all 'foo bar baz'

Block also can be defined as pattern.  Next command search and print
mail header, ignoring mail body text.

    greple --block '\A(.+\n)+'

You can also define arbitrary complex blocks by writing script.

    greple --block '&your_original_function' ...

## MATCH AREA CONTROL

Using option **--inside** and **--outside**, you can specify text area
the match should be occurred.  Next commands search only in mail header
and body area respectively.  In these case, data block is not changed,
then print lines which contains the pattern in the specified area.

    greple --inside '\A(.+\n)+' pattern

    greple --outside '\A(.+\n)+' pattern

Option **--inside**/**--outside** can be used repeatedly to enhance the
area to be matched.  There are similar option
**--include**/**--exclude**, but they are used to trim down the area.

Those four options also takes user defined function and any complex
region can be used.

## LINE ACROSS MATCH

**greple** search the pattern across the line boundaries.  This is
especially useful to handle Asian multi-byte text, more specifically
Japanese.  Japanese text can be separated by newline almost any place
in the text.  So the search pattern may spread out on multiple lines.

As for ascii word list, space character in the pattern matches any
kind of space including newline.  Next example will search the word
sequence of \`foo', \`bar' and 'baz', even they spread out to multiple
lines.

    greple -e 'foo bar baz'

Option **-e** is necessary because space is taken as a token separator
in the bare or **--le** pattern.

## MODULE AND CUSTOMIZATION

User can define default and original options in `~/.greplerc`.  Next
example enables color output always, and define new option using
macro processing.

    option default --color=always

    define :re1 complex-regex-1
    define :re2 complex-regex-2
    define :re3 complex-regex-3
    option --newopt --inside :re1 --exclude :re2 --re :re3

Specific set of function and option interface can be implemented as
module.  Modules are invoked by **-M** option immediately after command
name.

For example, **greple** does not have recursive search option, but it
can be implemented by **--readlist** option which accept target file
list from standard input.  Using **find** module, it can be written
like this:

    greple -Mfind . -type f -- pattern

Also **dig** module implements more complex search.  It can be used
simple as this:

    greple -Mdig pattern --dig .

but this command finally translated into following option list.

    greple -Mfind . ( -name .git -o -name .svn -o -name RCS ) -prune -o 
        -type f ! -name .* ! -name *,v ! -name *~ 
        ! -iname *.jpg ! -iname *.jpeg ! -iname *.gif ! -iname *.png 
        ! -iname *.tar ! -iname *.tbz  ! -iname *.tgz ! -iname *.pdf 
        -print -- pattern

# OPTIONS

## PATTERNS

If no specific option is given, **greple** takes the first argument as
a search pattern specified by **--le** option.  All of these patterns
can be specified multiple times.

Command itself is written in Perl, and any kind of Perl style regular
expression can be used in patterns.  See [perlre(1)](http://man.he.net/man1/perlre) for detail.

Note that multiple line modifier (`m`) is set when executed, so put
`(?-m)` at the beginning of regex if you want to explicitly disable
it.

Order of capture group in the pattern is not guaranteed.  Please avoid
to use direct index, and use relative or named capture group instead.
For example, repeated character can be written as `(\w)\g{-1}`
or `(?<c>\w)\g{c}`.

- **--le**=_pattern_

    Treat the string as a collection of tokens separated by spaces.  Each
    token is interpreted by the first character.  Token start with \`-'
    means negative pattern, \`?' means alternative, and \`+' does required.

    Next example print lines which contains \`foo' and \`bar', and one or
    more of \`yabba' and 'dabba', and none of \`baz' and \`doo'.

        greple --le='foo bar -baz ?yabba ?dabba -doo'

    Multiple \`?' preceded tokens are treated all mixed together.  That
    means \`?A|B ?C|D' is equivalent to \`?A|B|C|D'.  If you want to mean
    \`(A or B) and (C or D)', use AND syntax instead: \`A|B C|D'.

    If the pattern start with ampersand (\`&'), it is treated as a
    function, and the function is called instead of searching pattern.
    Function call interface is same as the one for block/region options.

    If you have a definition of _odd\_line_ function in you `.greplerc`,
    which is described in this manual later, you can print odd number
    lines like this:

        greple -n '&odd_line' file

    This is the summary of start character for **--le** option:

        +  Required pattern
        -  Negative match pattern
        ?  Alternative pattern
        &  Function call

- **-e** _pattern_, **--and**=_pattern_

    Specify positive match token.  Next two commands are equivalent.

        greple 'foo bar baz'
        greple -e foo -e bar -e baz

    First character is not interpreted, so next commands will search the
    pattern \`-baz'.

        greple -e -baz

    Space characters are treated specially by **-e** and **-v** options.
    They are replaced by the pattern which matches any number of
    white spaces including newline.  So the pattern can be expand to
    multiple lines.  Next commands search the series of word \`foo', \`bar'
    and \`baz' even if they are separated by newlines.

        greple -e 'foo bar baz'

- **-r** _pattern_, **--must**=_pattern_

    Specify required match token.  Next two commands are equivalent.

        greple '+foo bar baz'
        greple -r foo -e bar -e baz

- **-v** _pattern_, **--not**=_pattern_

    Specify negative match token.  Because it does not affect to the bare
    pattern argument, you can narrow down the search result like this.

        greple foo file
        greple foo file -v bar
        greple foo file -v bar -v baz

- **--re**=_pattern_

    Specify regular expression.  No special treatment for space and wide
    characters.

- **--fe**=_pattern_

    Specify fixed string pattern, like fgrep.

- **-i**, **--ignore-case**

    Ignore case.

- **--need**=_n_
- **--allow**=_n_

    Option to compromise matching condition.  Option **--need** specifies
    the required match count, and **--allow** the number of negative
    condition to be overlooked.

        greple --need=2 --allow=1 'foo bar baz -yabba -dabba -doo'

    Above command prints the line which contains two or more from \`foo',
    \`bar' and \`baz', and does not include more than one of \`yabba',
    \`dabba' or \`doo'.

    Using option **--need**=_1_, **greple** produces same result as **grep**
    command.

        grep   -e foo -e bar -e baz
        greple -e foo -e bar -e baz --need=1

    When the count _n_ is negative value, it is subtracted from default
    value.

- **--matchcount**=_min_\[,_max_\], **--mc**=_min_\[,_max_\]

    When option **--matchcount** is specified, only blocks which have given
    match count will be shown.  Count _min_ and _max_ can be omitted,
    and single number is taken as _min_.  Next commands print lines
    including semicolons; 3 or more, exactly 3, and 3 or less,
    respectively.

        greple --matchcount=3 ';' file

        greple --matchcount=3,3 ';' file

        greple --matchcount=,3 ';' file

- **-f** _file_, **--file**=_file_

    Specify the file which contains search pattern.  When file contains
    multiple lines, patterns on each lines are mixed together by OR
    context.

    Blank line and the line starting with sharp (#) character is ignored.
    Two slashes (//) and following string are taken as a comment and
    removed with preceding spaces.

    When multiple files specified, each file produces individual pattern.

    See **-Msubst** module.

## STYLES

- **-l**

    List filename only.

- **-c**, **--count**

    Print count of matched block.

- **-n**, **--line-number**

    Show line number.

- **-h**, **--no-filename**

    Do not display filename.

- **-H**

    Display filename always.

- **-o**, **--only-matching**

    Print matched string only.

- **-m** _n_\[,_m_\], **--max-count**=_n_\[,_m_\]

    Set the maximum count of blocks to be shown to _n_.

    Actually _n_ and _m_ are simply passed to perl [splice](https://metacpan.org/pod/splice) function as
    _offset_ and _length_.  Works like this:

        greple -m  10      # get first 10 blocks
        greple -m   0,-10  # get last 10 blocks
        greple -m   0,10   # remove first 10 blocks
        greple -m -10      # remove last 10 blocks
        greple -m  10,10   # remove 10 blocks from 10th (10-19)

    This option does not affect to search performance and command exit
    status.

    Note that **grep** command also has same option, but it's behavior is
    different when invoked to multiple files.  **greple** produces given
    number of output for each files, while **grep** takes it as a total
    number of output.

- **-A**\[_n_\], **--after-context**\[=_n_\]
- **-B**\[_n_\], **--before-context**\[=_n_\]
- **-C**\[_n_\], **--context**\[=_n_\]

    Print _n_-blocks before/after matched string.  The value _n_ can be
    omitted and the default is 2.  When used with **--paragraph** or
    **--block** option, _n_ means number of paragraph or block.

    Actually, these options expand the area of logical operation.  It
    means

        grep -C1 'foo bar baz'

    matches following text.

        foo
        bar
        baz

    Moreover

        greple -C1 'foo baz'

    also matches this text, because matching blocks around \`foo' and \`bar'
    overlaps each other and makes single block.

- **--join**
- **--joinby**=_string_

    Convert newline character found in matched string to empty or specified
    _string_.  Using **--join** with **-o** (only-matching) option, you can
    collect searching sentence list in one per line form.  This is
    sometimes useful for Japanese text processing.  For example, next
    command prints the list of KATAKANA words, including those spread
    across multiple lines.

        greple -ho --join '\p{InKatakana}+(\n\p{InKatakana}+)*'

    Space separated word sequence can be processed with **--joinby**
    option.  Next example prints all \`for \*something\*' pattern in pod
    documents within Perl script.

        greple -Mperl --pod -ioe '\bfor \w+' --joinby ' '

- **--\[no\]newline**

    Since **greple** can handle arbitrary blocks other than normal text
    lines, they sometimes do not end by newline character.  In that case,
    extra newline is appended at the end of block to be shown.  Option
    **--nonewline** disables this behavior.

- **--filestyle**=_line_|_once_|_separate_, **--fs**

    Default style is _line_, and **greple** prints filename at the
    beginning of each line.  Style _once_ prints the filename only once
    at the first time.  Style _separate_ prints filename in the separate
    line before each line or block.

- **--linestyle**=_line_|_separate_, **--ls**

    Default style is _line_, and **greple** prints line numbers at the
    beginning of each line.  Style _separate_ prints line number in the
    separate line before each line or block.

- **--separate**

    Shortcut for **--filestyle**=_separate_ **--linestyle**=_separate_.
    This is convenient to use block mode search and visiting each location
    from supporting tool, such as Emacs.

- **--format** **LABEL**=_format_

    Define the format string of line number (LINE) and file name (FILE) to
    be displayed.  Default is:

        --format LINE='%d:' --format FILE='%s:'

## FILES

- **--glob**=_pattern_

    Get files matches to specified pattern and use them as a target files.
    Using **--chdir** and **--glob** makes easy to use **greple** for fixed
    common job.

- **--chdir**=_directory_

    Change directory before processing files.  When multiple directories
    are specified in **--chdir** option, by using wildcard form or
    repeating option, **--glob** file expansion will be done for every
    directories.

        greple --chdir '/usr/man/man?' --glob '*.[0-9]' ...

- **--readlist**

    Get filenames from standard input.  Read standard input and use each
    line as a filename for searching.  You can feed the output from other
    command like [find(1)](http://man.he.net/man1/find) for **greple** with this option.  Next example
    searches string from files modified within 7 days:

        find . -mtime -7 -print | greple --readlist pattern

    Using **find** module, this can be done like:

        greple -Mfind . -mtime -7 -- pattern

## COLORS

- **--color**=_auto_|_always_|_never_, **--nocolor**

    Use terminal color capability to emphasize the matched text.  Default
    is \`auto': effective when STDOUT is a terminal and option **-o** is not
    given, not otherwise.  Option value \`always' and \`never' will work as
    expected.

    Option **--nocolor** is alias for **--color**=_never_.

- **--colormap**=_spec_

    Specify color map.

    Color specification is combination of single uppercase character
    representing basic colors, and (usually brighter) alternative colors in
    lowercase :

        R  r   Red
        G  g   Green
        B  b   Blue
        C  c   Cyan
        M  m   Magenta
        Y  y   Yellow
        K  k   Black
        W  w   White

    or RGB value and 24 grey levels if using ANSI 256 color terminal :

        000000 .. FFFFFF : 24bit RGB colors
        000 .. 555       : 6x6x6 RGB 216 colors
        L00 .. L23       : 24 grey levels

    >     Note that, when values are all same in 24bit RGB, it is converted to
    >     24 grey level, otherwise 6x6x6 216 color.

    with other special effects :

        Z  0 Zero (reset)
        D  1 Double-struck (boldface)
        P  2 Pale (dark)
        I  3 Italic
        U  4 Underline
        F  5 Flash (blink: slow)
        Q  6 Quick (blink: rapid)
        S  7 Stand-out (reverse video)
        V  8 Vanish (concealed)
        J  9 Junk (crossed out)
        E    Erase Line

        ;  No effect
        X  No effect

    If the spec includes `/`, left side is considered to be as foreground
    color and right side as background.  If multiple colors are given in
    same spec, all indicators are produced in the order of their presence.
    As a result, the last one takes effect.

    Effect characters are case insensitive, and can be found anywhere and
    in any order in color spec string.  Because `X` and `;` takes no
    effect, you can use them to improve readability, like `SxD;K/544`.

    Example:

        RGB  6x6x6    24bit           color
        ===  =======  =============   ==================
        B    005      0000FF        : blue foreground
         /M     /505        /FF00FF : magenta background
        K/W  000/555  000000/FFFFFF : black on white
        R/G  500/050  FF0000/00FF00 : red on green
        W/w  L03/L20  303030/c6c6c6 : grey on grey

    Multiple colors can be specified separating by white space or comma,
    or by repeating options.  Those colors will be applied for each
    pattern keywords.  Next command will show word \`foo' in red, \`bar' in
    green and \`baz' in blue.

        greple --colormap='R G B' 'foo bar baz'

        greple --cm R -e foo --cm G -e bar --cm B -e baz

    Coloring capability is implemented in [Getopt::EX::Colormap](https://metacpan.org/pod/Getopt::EX::Colormap) module.

- **--colormap**=_field_=_spec_,...

    Another form of colormap option to specify the color for fields:

        FILE      File name
        LINE      Line number
        TEXT      Unmatched normal text
        BLOCKEND  Block end mark

    In current release, `BLOCKEND` mark is colored with `E` effect
    recently implemented in [Getopt::EX](https://metacpan.org/pod/Getopt::EX) module, which allows to fill up
    the line with background color.  This effect uses irregular escape
    sequence, and you may need to define `LESSANSIENDCHARS` environment
    as "mK" to see the result with [less](https://metacpan.org/pod/less) command.

- **--colormap**=_&func_
- **--colormap**=_sub{...}_

    You can also set the name of perl subroutine name or definition to be
    called handling matched words.  Target word is passed as variable
    `$_`, and the return value of the subroutine will be displayed.

    Next command convert all words in C comment to upper case.

        greple --all '/\*(?s:.*?)\*/' --cm 'sub{uc}'

    You can quote matched string instead of coloring (this emulates
    deprecated option **--quote**):

        greple --cm 'sub{"<".$_.">"}' ...

    It is possible to use this definition with field names.  Next example
    print line numbers in seven digits.

        greple -n --cm 'LINE=sub{s/(\d+)/sprintf("%07d",$1)/e;$_}'

    Experimentally, function can be combined with other normal color
    specifications.  Also the form _&amp;func;_ can be repeated.

        greple --cm 'BF/544;sub{uc}'

        greple --cm 'R;&func1;&func2;&func3'

    When color for 'TEXT' field is specified, whole text including matched
    part is passed to the function, exceptionally.  It is not recommended
    to use user defined function for 'TEXT' field.

- **--\[no\]colorful**

    Shortcut for **--colormap**='_RD GD BD CD MD YD_' in ANSI 16 colors
    mode, and **--colormap**='_D/544 D/454 D/445 D/455 D/454 D/554_' and
    other combination of 3, 4, 5 for 256 colors mode.  Enabled by default.

    When single pattern is specified, first color in colormap is used for
    the pattern.  If multiple patterns and multiple colors are specified,
    each patterns are colored with corresponding colors cyclically.

    Option **--regioncolor**, **--uniqcolor** and **--colorindex** change
    this behavior.

- **--colorindex**=_spec_, **--ci**=_spec_

    Specify color index method by combination of spec characters.
    Meaningful combinations are **A**, **D**, **AB**, **DB** and **R**.

    - A (Ascending)

        Apply different color sequentially according to the order of
        appearance.

    - D (Descending)

        Apply different color sequentially according to the reversed order of
        appearance.

    - B (Block)

        Reset sequential index on every block.

    - R (Random)

        Apply random color.

- **--random**

    Shortcut for **--colorindex=R**.

- **--ansicolor**=_16_|_256_|_24bit_

    If set as _16_, use ANSI 16 colors as a default color set, otherwise
    ANSI 256 colors.  When set as _24bit_, 6 hex digits notation produces
    24bit color sequence.  Default is _256_.

- **--\[no\]256**

    Shortcut for **--ansicolor**=_256_ or _16_.

- **--\[no\]regioncolor**, **--\[no\]rc**

    Use different colors for each **--inside**/**outside** regions.

    Disabled by default, but automatically enabled when only single search
    pattern is specified.  Because there is no way to explicitly disable
    this action, use **--nocolorful** option to use single color.

- **--\[no\]uniqcolor**, **--\[no\]uc**

    Use different colors for different string matched.
    Disabled by default.

    Next example prints all words start by \`color' and display them all in
    different colors.

        greple --uniqcolor 'colou?r\w*'

    When used with option **-i**, color is selected in case-insensitive
    fashion.  If you want case-insensitive match and case-sensitive color
    selection, indicate insensitiveness in the pattern rather than command
    option (e.g. '_(?i)pattern_').

- **--face**=\[-+\]_effect_

    Set or unset specified _effect_ for all color specs.  Use \`+'
    (optional) to set, and \`-' to unset.  Effect is a single character
    expressing: S (Stand-out), U (Underline), D (Double-struck), F (Flash)
    or E (Erase Line).

    Next example remove D (double-struck) effect.

        greple --face -D

    Multiple effects can be set/unset at once.

        greple --face SF-D

    Use \`/' to set effect to background.  Only \`E' makes sense to use in
    background, though.

        greple --face /E

## BLOCKS

- **-p**, **--paragraph**

    Print the paragraph which contains the pattern.  Each paragraph is
    delimited by two or more successive newline characters by default.  Be
    aware that an empty line is not paragraph delimiter if which contains
    space characters.  Example:

        greple -np 'setuid script' /usr/man/catl/perl.l

        greple -pe '^struct sockaddr' /usr/include/sys/socket.h

    It changes the unit of context specified by **-A**, **-B**, **-C**
    options.

- **--all**

    Treat entire file contents as a single block.  This is almost
    identical to following command.

        greple --block='(?s).*'

- **--block**=_pattern_
- **--block**=_&sub_

    Specify the record block to display.  Default block is a single line.

    Next example behave almost same as **--paragraph** option, but is less
    efficient.

        greple --block='(.+\n)+'

    Next command treat the data as a series of 10-line blocks.

        greple -n --block='(.*\n){1,10}'

    When blocks are not continuous and there are gaps between them, the
    match occurred outside blocks are ignored.

    If multiple block options are supplied, overlapping blocks are merged
    into single block.

    Please be aware that this option is sometimes quite time consuming,
    because it finds all blocks before processing.

- **--blockend**=_string_

    Change the end mark displayed after **-pABC** or **--block** options.
    Default value is "--\\n".

## REGIONS

- **--inside**=_pattern_
- **--outside**=_pattern_

    Option **--inside** and **--outside** limit the text area to be matched.
    For simple example, if you want to find string \`and' not in the word
    \`command', it can be done like this.

        greple --outside=command and

    The block can be larger and expand to multiple lines.  Next command
    searches from C source, excluding comment part.

        greple --outside '(?s)/\*.*?\*/'

    Next command searches only from POD part of the perl script.

        greple --inside='(?s)^=.*?(^=cut|\Z)'

    When multiple **inside** and **outside** regions are specified, those
    regions are mixed up in union way.

    In multiple color environment, and if single keyword is specified,
    matches in each **--inside**/**outside** regions are printed in
    different colors.  Forcing this operation with multiple keywords, use
    **--regioncolor** option.

- **--inside**=_&function_
- **--outside**=_&function_

    If the pattern name begins by ampersand (&) character, it is treated
    as a name of subroutine which returns a list of blocks.  Using this
    option, user can use arbitrary function to determine from what part of
    the text they want to search.  User defined function can be defined in
    `.greplerc` file or by module option.

- **--include**=_pattern_
- **--exclude**=_pattern_
- **--include**=_&function_
- **--exclude**=_&function_

    **--include**/**exclude** option behave exactly same as
    **--inside**/**outside** when used alone.

    When used in combination, **--include**/**exclude** are mixed in AND
    manner, while **--inside**/**outside** are in OR.

    Thus, in the next example, first line prints all matches, and second
    does none.

        greple --inside PATTERN --outside PATTERN

        greple --include PATTERN --exclude PATTERN

    You can make up desired matches using **--inside**/**outside** option,
    then remove unnecessary part by **--include**/**exclude**

- **--strict**

    Limit the match area strictly.

    By default, **--block**, **--inside**/**outside**,
    **--include**/**exclude** option allows partial match within the
    specified area.  For instance,

        greple --inside and command

    matches pattern `command` because the part of matched string is
    included in specified inside-area.  Partial match fails when option
    **--strict** provided, and longer string never matches within shorter
    area.

    Interestingly enough, above example

        greple --include PATTERN --exclude PATTERN

    produces output, as a matter of fact.  Think of the situation
    searching, say, `' PATTERN '` with this condition.  Matched area
    includes surrounding spaces, and satisfies both conditions partially.
    This match does not occur when option **--strict** is given, either.

## CHARACTER CODE

- **--icode**=_code_

    Target file is assumed to be encoded in utf8 by default.  Use this
    option to set specific encoding.  When handling Japanese text, you may
    choose from 7bit-jis (jis), euc-jp or shiftjis (sjis).  Multiple code
    can be supplied using multiple option or combined code names with
    space or comma, then file encoding is guessed from those code sets.
    Use encoding name \`guess' for automatic recognition from default code
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

    If the string "**binary**" is given as encoding name, no character
    encoding is expected and all files are processed as binary data.

- **--ocode**=_code_

    Specify output code.  Default is utf8.

## FILTER

- **--if**=_filter_, **--if**=_EXP_:_filter_

    You can specify filter command which is applied to each files before
    search.  If only one filter command is specified, it is applied to all
    files.  If filter information include colon, first field will be perl
    expression to check the filename saved in variable $\_.  If it
    successes, next filter command is pushed.

        greple --if=rev perg
        greple --if='/\.tar$/:tar tvf -'

    If the command doesn't accept standard input as processing data, you
    may be able to use special device:

        greple --if='nm /dev/stdin' crypt /usr/lib/lib*

    Filters for compressed and gzipped file is set by default unless
    **--noif** option is given.  Default action is like this:

        greple --if='s/\.Z$//:zcat' --if='s/\.g?z$//:gunzip -c'

    File with _.gpg_ suffix is filtered by **gpg** command.  In that case,
    pass-phrase is asked for each file.  If you want to input pass-phrase
    only once to find from multiple files, use **-Mpgp** module.

    If the filter start with `&`, perl subroutine is called instead of
    external command.  You can define the subroutine in `.greplerc` or
    modules.  **Greple** simply call the subroutine, so it should be
    responsible for process control.

- **--noif**

    Disable default input filter.  Which means compressed files will not
    be decompressed automatically.

- **--of**=_filter_
- **--of**=_&func_

    Specify output filter which process the output of **greple** command.
    Filter command can be specified in multiple times, and they are
    invoked for each file to be processed.  So next command reset the line
    number for each files.

        greple --of 'cat -n' string file1 file2 ...

    If the filter start with `&`, perl subroutine is called instead of
    external command.  You can define the subroutine in `.greplerc` or
    modules.

    Output filter command is executed only when matched string exists to
    avoid invoking many unnecessary processes.  No effect for option
    **-l** and **-c**.

- **--pf**=_filter_
- **--pf**=_&func_

    Similar to **--of** filter but invoked just once and takes care of
    entire output from **greple** command.

## RUNTIME FUNCTIONS

- **--print**=_function_
- **--print**=_sub{...}_

    Specify user defined function executed before data print.  Text to be
    printed is replaced by the result of the function.  Arbitrary function
    can be defined in `.greplerc` file.  Matched data is placed in
    variable `$_`.  Other information is passed by key-value pair in the
    arguments.  Filename is passed by `&FILELABEL` key, as described
    later.  Matched information is passed by `matched` key, in the form
    of perl array reference: `[[start,end],[start,end]...]`.

    Simplest function is **--print**='_sub{$\_}_'.  Coloring capability can
    be used like this:

        # ~/.greplerc
        __PERL__
        sub print_simple {
            my %attr = @_;
            for my $r (reverse @{$attr{matched}}) {
                my($s, $e) = @$r;
                substr($_, $s, $e - $s, main::color('B', substr($_, $s, $e - $s)));
            }
            $_;
        }

    Then, you can use this function in the command line.

        greple --print=print_simple ...

    It is possible to use multiple **--print** options.  In that case,
    second function will get the result of the first function.  The
    command will print the final result of the last function.

- **--continue**

    When **--print** option is given, **greple** will immediately print the
    result returned from print function and finish the cycle.  Option
    **--continue** forces to continue normal printing process after print
    function called.  So please be sure that all data being consistent.

- **--begin**=_function_(_..._)
- **--begin**=_function_=_..._

    Option **--begin** specify the function executed at the beginning of
    each file processing.  This _function_ have to be called from **main**
    package.  So if you define the function in the module package, use the
    full package name or export properly.

- **--end**=_function_(_..._)
- **--end**=_function_=_..._

    Option **--end** is almost same as **--begin**, except that the function
    is called after the file processing.

- **--prologue**=_function_(_..._)
- **--prologue**=_function_=_..._
- **--epilogue**=_function_(_..._)
- **--epilogue**=_function_=_..._

    Option **--prologue** and **--epilogue** specify functions called before
    and after processing.  During the execution, file is not opened and
    therefore, file name is not given to those functions.

- **-M**_module_::_function(...)_
- **-M**_module_::_function=..._

    Function can be given with module option, following module name.  In
    this form, the function will be called with module package name.  So
    you don't have to export it.  Because it is called only once at the
    beginning of command execution, before starting file processing,
    `FILELABEL` parameter is not given exceptionally.

For these run-time functions, optional argument list can be set in the
form of `key` or `key=value`, connected by comma.  These arguments
will be passed to the function in key => value list.  Sole key will
have the value one.  Also processing file name is passed with the key
of `FILELABEL` constant.  As a result, the option in the next form:

    --begin function(key1,key2=val2)
    --begin function=key1,key2=val2

will be transformed into following function call:

    function(&FILELABEL => "filename", key1 => 1, key2 => "val2")

As described earlier, `FILELABEL` parameter is not given to the
function specified with module option. So

    -Mmodule::function(key1,key2=val2)
    -Mmodule::function=key1,key2=val2

simply becomes:

    function(key1 => 1, key2 => "val2")

The function can be defined in `.greplerc` or modules.  Assign the
arguments into hash, then you can access argument list as member of
the hash.  It's safe to delete FILELABEL key if you expect random
parameter is given.  Content of the target file can be accessed by
`$_`.  Ampersand (`&`) is required to avoid the hash key is
interpreted as a bare word.

    sub function {
        my %arg = @_;
        my $filename = delete $arg{&FILELABEL};
        $arg{key1};             # 1
        $arg{key2};             # "val2"
        $_;                     # contents
    }

## OTHERS

- **--norc**

    Do not read startup file: `~/.greplerc`.

- **--usage**

    **Greple** print usage and exit with option **--usage**, or no valid
    parameter is not specified.  In this case, module option is displayed
    with help information if available.  If you want to see how they are
    expanded, supply something not empty to **--usage** option, like:

        greple -Mmodule --usage=expand

- **--man**

    Show manual page.
    Display module's manual page when used with **-M** option.

- **--show**

    Show module file contents.  Use with **-M** option.

- **--path**

    Show module file path.  Use with **-M** option.

- **--require**=_filename_

    Include arbitrary perl program.

- **--conceal** _type_=_val_

    Conceal runtime errors.  Repeatable.  Types are:

    - **read**

        (Default 1) Errors occurred during file read.  Mainly unicode related
        errors when reading binary or ambiguous text file.

    - **skip**

        (Default 0) File skip warnings produced when fatal error was occurred
        during file read.  Occurs when reading binary files with automatic
        character code recognition.

    - **all**

        Set same value for all types.

- **--persist**

    As **greple** tries to read data as a character string, sometimes fails
    to convert them into internal representation, and the file is skipped
    without processing.  When option **--persist** is specified, command
    does not give up the file, and tries to read as binary data.

    Next command will show strings in binary file.

        greple -o --re '(?a)\w{4,}' --persist --uc /bin/*

    When processing all files as binary data, use **--icode=binary**
    instead.

# ENVIRONMENT and STARTUP FILE

Environment variable GREPLEOPTS is used as a default options.  They
are inserted before command line options.

Before starting execution, _greple_ reads the file named `.greplerc`
on user's home directory.  Following directives can be used.

- **option** _name_ string

    Argument _name_ of \`option' directive is user defined option name.
    The rest are processed by _shellwords_ routine defined in
    Text::ParseWords module.  Be sure that this module sometimes requires
    escape backslashes.

    Any kind of string can be used for option name but it is not combined
    with other options.

        option --fromcode --outside='(?s)\/\*.*?\*\/'
        option --fromcomment --inside='(?s)\/\*.*?\*\/'

    If the option named **default** is defined, it will be used as a
    default option.

    For the purpose to include following arguments within replaced
    strings, two special notations can be used in option definition.
    String `$<n>` is replaced by the _n_th argument after the
    substituted option, where _n_ is number start from one.  String
    `$<shift>` is replaced by following command line argument and
    the argument is removed from option list.

    For example, when

        option --line --le &line=$<shift>

    is defined, command

        greple --line 10,20-30,40

    will be evaluated as this:

        greple --le &line=10,20-30,40

- **expand** _name_ _string_

    Define local option _name_.  Command **expand** is almost same as
    command **option** in terms of its function.  However, option defined
    by this command is expanded in, and only in, the process of
    definition, while option definition is expanded when command arguments
    are processed.

    This is similar to string macro defined by following **define**
    command.  But macro expansion is done by simple string replacement, so
    you have to use **expand** to define option composed by multiple
    arguments.

- **define** _name_ string

    Define macro.  This is similar to **option**, but argument is not
    processed by _shellwords_ and treated just a simple text, so
    meta-characters can be included without escape.  Macro expansion is
    done for option definition and other macro definition.  Macro is not
    evaluated in command line option.  Use option directive if you want to
    use in command line,

        define (#kana) \p{InKatakana}
        option --kanalist --nocolor -o --join --re '(#kana)+(\n(#kana)+)*'
        help   --kanalist List up Katakana string

- **help** _name_

    If \`help' directive is used for same option name, it will be printed
    in usage message.  If the help message is \`ignore', corresponding line
    won't show up in the usage.

- **builtin** _spec_ _variable_

    Define built-in option which should be processed by option parser.
    Arguments are assumed to be [Getopt::Long](https://metacpan.org/pod/Getopt::Long) style spec, and
    _variable_ is string start with `$`, `@` or `%`.  They will be
    replaced by a reference to the object which the string represent.

    See **pgp** module for example.

- **autoload** _module_ _options_ ...

    Define module which should be loaded automatically when specified
    option is found in the command arguments.

    For example,

        autoload -Mdig --dig

    replaces option "_--dig_" to "_-Mdig --dig_", and _dig_ module is
    loaded before processing _--dig_ option.

Environment variable substitution is done for string specified by
\`option' and \`define' directives.  Use Perl syntax **$ENV{NAME}** for
this purpose.  You can use this to make a portable module.

When _greple_ found `__PERL__` line in `.greplerc` file, the rest
of the file is evaluated as a Perl program.  You can define your own
subroutines which can be used by **--inside**/**outside**,
**--include**/**exclude**, **--block** options.

For those subroutines, file content will be provided by global
variable `$_`.  Expected response from the subroutine is the list of
array references, which is made up by start and end offset pairs.

For example, suppose that the following function is defined in your
`.greplerc` file.  Start and end offset for each pattern match can be
taken as array element `$-[0]` and `$+[0]`.

    __PERL__
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

    % greple --inside '&odd_line' pattern files...

# MODULE

You can expand the **greple** command using module.  Module files are
placed at `App/Greple/` directory in Perl library, and therefor has
**App::Greple::module** package name.

In the command line, module have to be specified preceding any other
options in the form of **-M**_module_.  However, it also can be
specified at the beginning of option expansion.

If the package name is declared properly, `__DATA__` section in the
module file will be interpreted same as `.greplerc` file content.  So
you can declare the module specific options there.  Functions declared
in the module can be used from those options, it makes highly
expandable option/programming interaction possible.

Using **-M** without module argument will print available module list.
Option **--man** will display module document when used with **-M**
option.  Use **--show** option to see the module itself.  Option
**--path** will print the path of module file.

See this sample module code.  This sample defines options to search
from pod, comment and other segment in Perl script.  Those capability
can be implemented both in function and macro.

    package App::Greple::perl;

    use Exporter 'import';
    our @EXPORT      = qw(pod comment podcomment);
    our %EXPORT_TAGS = ( );
    our @EXPORT_OK   = qw();
    
    use App::Greple::Common;
    use App::Greple::Regions;
    
    my $pod_re = qr{^=\w+(?s:.*?)(?:\Z|^=cut\s*\n)}m;
    my $comment_re = qr{^(?:[ \t]*#.*\n)+}m;
    
    sub pod {
        match_regions(pattern => $pod_re);
    }
    sub comment {
        match_regions(pattern => $comment_re);
    }
    sub podcomment {
        match_regions(pattern => qr/$pod_re|$comment_re/);
    }
    
    1;
    
    __DATA__
    
    define :comment: ^(\s*#.*\n)+
    define :pod: ^=(?s:.*?)(?:\Z|^=cut\s*\n)
    
    #option --pod --inside :pod:
    #option --comment --inside :comment:
    #option --code --outside :pod:|:comment:
    
    option --pod --inside '&pod'
    option --comment --inside '&comment'
    option --code --outside '&podcomment'

You can use the module like this:

    greple -Mperl --pod default greple

    greple -Mperl --colorful --code --comment --pod default greple

If special subroutine **initialize()** is defined in the module, it is
called at the beginning with `Getopt::EX::Module` object as a
first argument.  Second argument is the reference to `@ARGV`, and you
can modify actual `@ARGV` using it.  See **find** module as a sample.

# HISTORY

Most capability of **greple** is derived from **mg** command, which has
been developing from early 1990's by the same author.  Because modern
standard **grep** family command becomes to have similar capabilities,
it is a time to clean up entire functionalities, totally remodel the
option interfaces, and change the command name. (2013.11)

# SEE ALSO

[grep(1)](http://man.he.net/man1/grep), [perl(1)](http://man.he.net/man1/perl)

[github](http://kaz-utashiro.github.io/greple/)

[Getopt::EX](https://metacpan.org/pod/Getopt::EX)

# AUTHOR

Kazumasa Utashiro

# LICENSE

Copyright 1991-2018 Kazumasa Utashiro

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.
