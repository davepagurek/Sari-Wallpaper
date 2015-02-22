#!/usr/bin/perl

use CGI;
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
use GD;
use JSON;
use HTML::Template;

use warnings;
use strict;

my $json = JSON->new->allow_nonref;

my $quality = 90;
my $sizes = {
    "thumbnail" => {
        "width" => 300,
        "height" => 600,
        "crop" => 0
    },
    "images" => {
        "width" => 900,
        "height" => 900,
        "crop" => 0
    }
};

my $readFile = "read.txt";
my $config = do "config.pl";
my $credentials = $config->{password};
my $recipient = $config->{recipient};

my $query = new CGI;
print $query->header("text/html");


sub get_sorted_files {
    my $path = shift;
    opendir my($dir), $path or die "can't opendir $path: $!";
    my %hash = map {$_ => -(stat($_))[9] || undef} # avoid empty list
    map  { "$path/$_" }
    grep { m/.(jpg|png)/i }
    readdir $dir;
    closedir $dir;
    return %hash;
}

sub resize {
    my $file = shift;
    if ($file && -e $file) {
        my $name = "img";
        my $mime = "jpg";
        if ($file =~ /[\/\\]*([a-zA-Z0-9-_ ]*)\.([a-z]+)$/i) {
            $name = $1;
            $mime = $2;
        }

        my $img;

        if (lc($mime) eq "jpg" || lc($mime) eq "jpeg") {
            $img = GD::Image->newFromJpeg($file);
        } elsif (lc($mime) eq "png") {
            $img = GD::Image->newFromPng($file);
        }

        my ($w,$h) = $img->getBounds(); # find dimensions

        for my $size (keys %$sizes) {
            if ($sizes->{$size}->{crop}) {
                my ($cut,$xcut,$ycut);
                if ($w>$h){
                    $cut=$h;
                    $xcut=(($w-$h)/2);
                    $ycut=0;
                }
                if ($w<$h){
                    $cut=$w;
                    $xcut=0;
                    $ycut=(($h-$w)/2);
                }
                my $newimg = new GD::Image($sizes->{$size}->{width}, $sizes->{$size}->{height}, 1);
                $newimg->copyResampled($img,0,0,$xcut,$ycut,$sizes->{$size}->{width}, $sizes->{$size}->{height},$cut,$cut);


                open(my $thumbFile, ">", "$size/$name.jpg");
                binmode $thumbFile;
                print $thumbFile $newimg->jpeg($quality);
                close $thumbFile;
            } else {
                my $gd;
                if ($w>$h) {
                    $gd = new GD::Image($sizes->{$size}->{width}, (($h/$w)*$sizes->{$size}->{width}), 1);
                    $gd->copyResampled($img,0,0,0,0,$sizes->{$size}->{width}, (($h/$w)*$sizes->{$size}->{width}),$w,$h);
                } else {
                    $gd = new GD::Image(($w/$h)*$sizes->{$size}->{height}, ($sizes->{$size}->{height}), 1);
                    $gd->copyResampled($img,0,0,0,0,($w/$h)*$sizes->{$size}->{height}, ($sizes->{$size}->{height}),$w,$h);

                }

                open(my $thumbFile, ">", "$size/$name.jpg");
                binmode $thumbFile;
                print $thumbFile $gd->jpeg($quality);
                close($thumbFile);
            }
        }
    } else {
        print "Can't find file $file\n";
    }
}

my $past = $query->param('past');
if ($query->param("make_thumbs")) {
    my %files = get_sorted_files("full");
    foreach my $key (keys %files) {
        resize("$key");
    }
}
if ($past) {

    my $images = [];
    my %files = get_sorted_files("full");
    foreach my $key (sort{$files{$a} <=> $files{$b}} keys %files) {
        if ($key =~ /^full\/(.*)\.(.*)$/) {
            push(@{ $images }, {
                name => $1,
                mime => $2
            });
        }
    }

    my $template = HTML::Template->new(
        filename => "templates/past.html",
        die_on_bad_params =>  0
    );

    $template->param({
        images => $images,
        recipient => $recipient
    });

    print $template->output;


} else {
    my $password = $query->param('password');
    my $file = $query->param('file');
    my $filehandle = $query->upload("file");
    if ($file && $filehandle && $password eq $credentials) {
        my $basename = $file;
        $basename =~ s/.*[\/\\](.*)/$1/;

        binmode($filehandle);

        open (my $OUTFILE,'>',"full/$basename");
        while ( my $nBytes = read($filehandle, my $buffer, 1024) ) {
            print $OUTFILE $buffer;
        }
        close($OUTFILE);

        my $latest = 0;
        if (-e "latest.txt") {
            open my $latestFile2, "<", "latest.txt" or die "Can't open latest.txt: $!";
            $latest = <$latestFile2>;
            $latest++;
            close($latestFile2);
        } else {
            $latest = 1;
        }

        open my $latestFile2, ">", "latest.txt" or die "Can't open latest.txt: $!";
        print $latestFile2 $latest;
        print $latestFile2 "\n";
        print $latestFile2 "full/$basename";
        close($latestFile2);

        resize("full/$basename");

        unlink $readFile or warn "Could not unlink $readFile: $!";
    }

    my $viewed;

    if (-e "read.txt") {
        open my $fh, '<', "read.txt" or die;
        local $/ = undef;
        my $data = <$fh>;
        close $fh;

        $viewed = $json->decode($data);
    } else {
        $viewed = {};
    }

    my $template = HTML::Template->new(
        filename => "templates/current.html",
        die_on_bad_params =>  0
    );

    if (-e "latest.txt") {
        open my $latestFile, "<", "latest.txt" or die "Can't open latestFile: $!";

        my $latest = <$latestFile>;
        my $latestUrl = <$latestFile>;
        if ($latestUrl =~ /^(.*)\.(.*)$/) {
            my $url = $1;
            my $mime = $2;
            my $basename = $url;
            $basename =~ s/.*[\/\\](.*)/$1/;

            my $devices = [];
            for my $key (@{ $config->{devices} }) {
                push(@{ $devices }, {
                    device => $key,
                    downloaded => $viewed->{$key}
                });
            }

            $template->param({
                devices => $devices,
                url => $latestUrl,
                name => $basename,
                recipient => $recipient
            });

        }
    } else {
        $template->param({
            new => 1,
            recipient => $recipient
        });
    }
    print $template->output;

}
