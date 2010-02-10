#!/usr/bin/perl -w

use Getopt::Long;

my @DEFS;
my %WORDS;
my @WORDS;

my $delim = "\t";

my $iter = 'def';
my $fields = 'Kanji';

GetOptions(
	"iter=s" => \$iter,
	"fields=s" => \$fields,
);

loadDefs();

my @fields = split(',', $fields);
if ($iter eq 'def') {
	defIter(sub { print join($delim, map { $_[0]->{$_} } @fields),"\n" });
}
if ($iter eq 'words') {
	wordIter(sub { print join($delim, map { $_[0]->{$_} } @fields),"\n" });
}

#wordIter(sub { print join($delim, $_[0]->{Word}, $_[0]->{Pronun}),"\n" });
#wordIter(sub { print join($delim, $_[0]->{Word}, $_[0]->{Meaning}),"\n" });
#wordIter(sub { print join($delim, $_[0]->{Word}, $_[0]->{Meaning}),"\n" });

sub defIter {
	my ($sub) = shift;

	foreach my $def (@DEFS) {
		&$sub($def);
	}
}

sub wordIter {
	my ($sub) = shift;

	foreach my $word (@WORDS) {
		&$sub($word);
	}
}

sub loadDefs {
	my $file_name = "bkb.txt";
	open FILE, $file_name
		or "Can't open $file_name: $!\n";
	# 1;日;sol,dia;ひ,-び,-か;二,ニチ;日本(に　ほん/にっ　ぽん)=Japón
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
