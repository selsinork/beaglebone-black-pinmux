#!/usr/bin/perl -w

use strict;

open(X,'<','3359.txt') || die "can't open file: $!\n";

my @lns=<X>;

close X;

open(X,'<','registers.txt') || die "can't open file: $!\n";

my @regs=<X>;

close X;


my %p;
my %r;


my $pin;
my $name;

my $max=0;
my $maxn=0;

foreach my $l (@lns) {

	chomp $l;

	$l=~s/^\s+//;
	if($l=~/^VDD/) {
		next;
	}
	if($l=~/^\(/) {
		next;
	}

	my @c=split(/\s+/,$l);

	my $cnt=scalar(@c);
	if($cnt<3) {
		next;
	}


	if($cnt>4) {

		if($c[3]=~/^\(/) {
			splice @c,3,1;
		}

		$pin=$c[1];
		$name=$c[2];
		if(length $name > $maxn) {
			$maxn=length $name;
		}
		$p{$pin}->{'name'}=$name;
		$p{$pin}->{'default'}=$c[8];

		if($c[4] eq 'NA') {
			$c[4]=0;
		}
		$p{$pin}->{'pins'}->{$c[4]}=$c[3];
		if(length $c[3] > $max) {
			$max=length $c[3];
		}

	} else {

		$p{$pin}->{'pins'}->{$c[1]}=$c[0];
		if(length $c[0] > $max) {
			$max=length $c[0];
		}
	}
	
}

foreach my $l (@regs) {

	chomp $l;
	my @c=split(/\s+/,$l);
	my $rn=substr($c[1],5);
	my $base=substr($c[0],0,-1);
	$r{$rn}="0x$base";
		

}

my %p8=('1'	=>'GND',
	'2'	=>'GND',
	'3'	=>'R9',
	'4'	=>'T9',
	'5'	=>'R8',
	'6'	=>'T8',
	'7'	=>'R7',
	'8'	=>'T7',
	'9'	=>'T6',
	'10'	=>'U6',
	'11'	=>'R12',
	'12'	=>'T12',
	'13'	=>'T10',
	'14'	=>'T11',
	'15'	=>'U13',
	'16'	=>'V13',
	'17'	=>'U12',
	'18'	=>'V12',
	'19'	=>'U10',
	'20'	=>'V9',
	'21'	=>'U9',
	'22'	=>'V8',
	'23'	=>'U8',
	'24'	=>'V7',
	'25'	=>'U7',
	'26'	=>'V6',
	'27'	=>'U5',
	'28'	=>'V5',
	'29'	=>'R5',
	'30'	=>'R6',
	'31'	=>'V4',
	'32'	=>'T5',
	'33'	=>'V3',
	'34'	=>'U4',
	'35'	=>'V2',
	'36'	=>'U3',
	'37'	=>'U1',
	'38'	=>'U2',
	'39'	=>'T3',
	'40'	=>'T4',
	'41'	=>'T1',
	'42'	=>'T2',
	'43'	=>'R3',
	'44'	=>'R4',
	'45'	=>'R1',
	'46'	=>'R2');

my %p9=('1'	=>'GND',
	'2'	=>'GND',
	'3'	=>'3.3V',
	'4'	=>'3.3V',
	'5'	=>'VDD_5V',
	'6'	=>'VDD_5V',
	'7'	=>'SYS_5V',
	'8'	=>'SYS_5V',
	'9'	=>'PWR_BUT',
	'10'	=>'A10',
	'11'	=>'T17',
	'12'	=>'U18',
	'13'	=>'U17',
	'14'	=>'U14',
	'15'	=>'R13',
	'16'	=>'T14',
	'17'	=>'A16',
	'18'	=>'B16',
	'19'	=>'D17',
	'20'	=>'D18',
	'21'	=>'B17',
	'22'	=>'A17',
	'23'	=>'V14',
	'24'	=>'D15',
	'25'	=>'A14',
	'26'	=>'D16',
	'27'	=>'C13',
	'28'	=>'C12',
	'29'	=>'B13',
	'30'	=>'D12',
	'31'	=>'A13',
	'32'	=>'VADC',
	'33'	=>'C8',
	'34'	=>'AGND',
	'35'	=>'A8',
	'36'	=>'B8',
	'37'	=>'B7',
	'38'	=>'A7',
	'39'	=>'B6',
	'40'	=>'C7',
	'41'	=>'D14',
	'41.1'	=>'D13',
	'42'	=>'C18',
	'42.1'	=>'B12',
	'43'	=>'GND',
	'44'	=>'GND',
	'45'	=>'GND',
	'46'	=>'GND');

$max++;
$max++;

sub dmp($) {

	my ($pl)=@_;

	foreach my $t (sort {$a<=>$b} keys %$pl) {

		my $pn;
		my $pins;
		my $s;
		my $def;

		print "$t".' ' x (6-length($t));
		print $pl->{$t}.' ' x (9-length($pl->{$t}));;
		if(exists $p{$pl->{$t}}) {
			$pn=$p{$pl->{$t}}->{'name'};
			$pins=$p{$pl->{$t}}->{'pins'};
			$def=$p{$pl->{$t}}->{'default'};
			print $pn;
		} else {
			$pn='';
			$def=9;
		}
		print ' ' x (20-length $pn);
		if(exists $r{lc($pn)}) {
			$s=$r{lc($pn)};
			print $s;
		} else {
			$s='';
		}

		print ' ' x (15-length $s);
		
		for(my $f=0;$f<8;$f++) {
			if($f==$def) {
				print "*";
			}
			if(exists $pins->{$f}) {
				print $pins->{$f}.' ' x ($max-length($pins->{$f}));
			} else {
				print ' ' x ($max);
			}
		}	
		
		
		print "\n";
	}
}

dmp(\%p8);

print "\n\n";

dmp(\%p9);

