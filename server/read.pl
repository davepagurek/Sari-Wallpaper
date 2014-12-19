#!/usr/bin/perl

use CGI;
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
use JSON;

use warnings;
use strict;

my $query = new CGI;
print $query->header("text/html");

my $json = JSON->new->allow_nonref;

my $update = 0;

if ($query->param("id")) {
    open(my $viewed, ">>", "read.txt");
    print $viewed $query->param("id") . "\n";
    close($viewed);
}