#!/usr/bin/perl -w

use Getopt::Long;

my @DEFS;
my %WORDS;
my @WORDS;

my $delim = "\t";

my $iter = 'def';
my $fields = 'Kanji';

my $file_name = shift;
GetOptions(
	"iter=s" => \$iter,
	"fields=s" => \$fields,
);

loadDefs();

my @fields = split(',', $fields);
my $what = $iter eq 'def' ? \@DEFS : \@WORDS;

dataIter(sub { print join($delim, map { $_[0]->{$_} } @fields),"\n" }, $what);

sub dataIter {
	my ($sub, $what) = @_;

	foreach my $def (@$what) {
		&$sub($def);
	}
}

sub loadDefs {
	open (FILE, $file_name)
		or die "Can't open $file_name: $!\n";
	while (<FILE>) {
		next if /^\s*#/; # Ignore comments

		my @f = split /;/;
		my %def;
		$def{Number} = shift @f;
		$def{Kanji} = shift @f;
		#$def{Defs} = [ split(/,/, shift @f) ];
		$def{Defs} = shift @f;
		$def{Kunyomi} = [ split(/,/, shift @f) ];
		$def{Onyomi} = [ split(/,/, shift @f) ];
		my @words;
		while (@f) {
			my $word = shift @f;
			$word =~ s/　/ /g; # Substitute "japanese space"
			die "$.: Bad example '$word'\n"
				unless $word =~ /^(.+)\((.+)\)=(.+)$/;
			my %word = (
				Word => $1,
				Pronun => $2,
				Meaning => $3
			);
			push @words, \%word;
			push @WORDS, \%word
				unless exists $WORDS{$1};
			$WORDS{$1} = \%word;
		}
		$def{Words} = \@words;

		push @DEFS, \%def;
	}
	close(FILE);
}
