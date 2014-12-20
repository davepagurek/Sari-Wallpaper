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
    my $viewed = {};

    if (-e "read.txt") {
        open my $fh, '<', "read.txt" or die;
        local $/ = undef;
        my $data = <$fh>;
        close $fh;

        $viewed = $json->decode($data);
    }
    $viewed->{$query->param("id")} = 1;

    open(my $readFile, ">", "read.txt");
    print $readFile $json->encode($viewed);
    close($readFile);
}