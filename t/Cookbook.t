#!/usr/bin/perl -w
#
# test script for validation and load/dump between Perl/Moose and XML
# for the PRANG::Cookbook

use strict;
use Test::More;
use Scriptalicious;
use FindBin qw($Bin);
use lib $Bin;
use XMLTests;
use XML::Compare;

use PRANG::Cookbook;
use PRANG::Cookbook::Note;
use PRANG::Cookbook::Library;

our @tests = XMLTests::find_tests;

plan tests => @tests * 3;

my $xml_compare = XML::Compare->new(
	ignore => [
		q{//Error//text()},  # FIXME - cdata types
		q{//AccessControlListQry/@FullResult},
	       ],
       );

for my $test ( sort @tests ) {
	my $xml = XMLTests::read_xml($test);

	my $object = XMLTests::parse_test( "PRANG::Cookbook", $xml, $test );
 SKIP: {
		skip "didn't parse", 2 unless $object;
		my $r_xml = XMLTests::emit_test( $object, $test );
		if ( !defined $r_xml ) {
			skip "no XML returned", 1;
		}
		XMLTests::xml_compare_test(
			$xml_compare, $xml, $r_xml, $test,
		       );
	}
}

# Copyright (C) 2010 NZ Registry Services
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the Artistic License 2.0 or later.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# Artistic License 2.0 for more details.
#
# You should have received a copy of the Artistic License the file
# COPYING.txt.  If not, see
# <http://www.perlfoundation.org/artistic_license_2_0>
