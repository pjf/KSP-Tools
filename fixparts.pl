#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;
use autodie;
use File::Spec;
use File::Path qw(remove_tree);

# Deletes all those parts you don't want anymore.
# For great justice!

my %unloved = (

    # Fairings (because ProceduralFairings rock)
    fairings => [
        'FASA/Apollo/FASA_Apollo_Fairings',
        'FASA/Gemini2/FASA_Fairings_Plate_2m',
    ],

    # Nosecones (ProceduralParts is awesome)
    nosecones => [
        'NovaPunch2/Parts/NoseCone',

        # These are all warheads...
        'RftS/Parts/KWNoseconeBlack',
        'RftS/Parts/NPNosecone',
        'RftS/USWarhead_0_5m.cfg',
        'RftS/Mk3RV',
        'RftS/Mk4RV.cfg',
    ],

    # TODO: Tanks
    # TODO: Wings
);

my $GameData = "$ENV{HOME}/Steam/SteamApps/common/Kerbal Space Program/GameData";

delete_parts(\%unloved);

sub delete_parts {
    my (@parts) = @_;

    foreach my $part (@parts) {
        if (not ref $part) {
            my $path = "$GameData/$part";
            remove_tree("$GameData/$part", { verbose => 1 } );
        }
        elsif ('ARRAY' eq ref $part) {
            delete_parts(@$part);
        }
        elsif ('HASH' eq ref $part) {
            delete_parts(values %$part);
        }
        else {
            die "Unknown structure $part";
        }
    }
}
