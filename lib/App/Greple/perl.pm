=head1 NAME

perl - Greple module for perl script

=head1 SYNOPSIS

greple -Mperl [ options ]

=head1 SAMPLES

greple -Mperl option pattern
    --code        search from perl code outisde of pod document
    --pod         search from pod document
    --comment     search from comment part
    --allsection  search from all sections

greple --colordump file

=head1 DESCRIPTION

Sample module for B<greple> command supporting perl script.

=cut

package App::Greple::perl;

use strict;
use warnings;
use Carp;
use App::Greple::Common;
use App::Greple::Regions;

use Exporter 'import';
our @EXPORT      = qw(part pod comment doc code);
our %EXPORT_TAGS = ( );
our @EXPORT_OK   = qw();


my $target = -1;
my %part;

my $pod_re = qr{^=\w+(?s:.*?)(?:\z|^=cut[ \t]*\n)}m;
my $comment_re = qr{^(?:[ \t]*#.*\n)+}m;

sub setup {
    return $target if $target == \$_;
    my @pod     = match_regions(pattern => $pod_re);
    my @comment = match_regions(pattern => $comment_re);
    my @doc     = merge_regions(@pod, @comment);
    my @code    = reverse_regions(\@doc, length);
    %part = (
	pod     => \@pod,
	comment => \@comment,
	doc     => \@doc,
	code    => \@code,
	);
    $target = \$_;
}

sub part {
    my %arg = @_;
    my $file = delete $arg{&FILELABEL} or die;
    setup and merge_regions do {
	map  { @{$part{$_}} }
	grep { exists $part{$_} }
	grep { $arg{$_} }
	keys %arg;
    };
}

sub pod     { setup and @{$part{pod}} }
sub comment { setup and @{$part{comment}} }
sub doc     { setup and @{$part{doc}} }
sub code    { setup and @{$part{code}} }

1;

__DATA__

define :comment: ^([ \t]*#.*\n)+
define :pod: ^=(?s:.*?)(?:\Z|^=cut[ \t]*\n)
define :doc: :pod:|:comment:

option --allsection --pod --comment --code

option --pod     --inside  :pod:
option --comment --inside  :comment:
option --code    --outside :doc:

#option --pod     --inside  '&pod'
#option --comment --inside  '&comment'
#option --code    --outside '&doc'

option	--colordump \
	--le '&part(code)'    --cm=R \
	--le '&part(comment)' --cm=G \
	--le '&part(pod)'     --cm=B \
	--need 1 --all
