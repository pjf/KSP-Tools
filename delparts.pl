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
        'FASA/Gemini2/FASA_Gemini_LR91_Pack/FairingNosecone1m.cfg',
        'FASA/Gemini2/FASA_Gemini_LR91_Pack/FairingNosecone1m.mu',
        'FASA/Gemini2/FASA_Gemini_LR91_Pack/FairingNosecone2mHalf.cfg',
        'FASA/Gemini2/FASA_Gemini_LR91_Pack/FairingNosecone3M.cfg',
        'FASA/Gemini2/FASA_Gemini_LR91_Pack/FairingNosecone3m.mu',
        'FASA/Gemini2/FASA_Gemini_LR91_Pack/FairingNosecone625m.cfg',
        'FASA/Gemini2/FASA_Gemini_LR91_Pack/FairingNosecone625m.mu',
        'FASA/Gemini2/FASA_Gemini_LR91_Pack/FairingNoseconeHalf2m.mu',
        'FASA/Gemini2/FASA_Gemini_LR91_Pack/FairingWall05m.cfg',
        'FASA/Gemini2/FASA_Gemini_LR91_Pack/FairingWall05m.mu',
        'FASA/Gemini2/FASA_Gemini_LR91_Pack/FairingWall1M.cfg',
        'FASA/Gemini2/FASA_Gemini_LR91_Pack/FairingWall1m.mu',
        'FASA/Gemini2/FASA_Gemini_LR91_Pack/FairingWall2m.cfg',
        'FASA/Gemini2/FASA_Gemini_LR91_Pack/FairingWall2m.mu',
        'FASA/Gemini2/FASA_Gemini_LR91_Pack/FairingWall2mS.cfg',
        'FASA/Gemini2/FASA_Gemini_LR91_Pack/FairingWall2mS.mu',
        'FASA/Gemini2/FASA_Gemini_LR91_Pack/FairingWall3M.cfg',
        'FASA/Gemini2/FASA_Gemini_LR91_Pack/FairingWall3m.mu',
        'FASA/Gemini2/FASA_Gemini_LR91_Pack/FairingWallCone1m.cfg',
        'FASA/Gemini2/FASA_Gemini_LR91_Pack/FairingWallCone1m.mu',
        'FASA/Gemini2/FASA_Gemini_LR91_Pack/FairingWallCone2m.cfg',
        'FASA/Gemini2/FASA_Gemini_LR91_Pack/FairingWallCone2m.mu',
        'AIES_Aerospace/Structure/AIES t1000v4',
        'AIES_Aerospace/Structure/AIES t1500v4',
        'AIES_Aerospace/Structure/AIES t2000v4',
        'AIES_Aerospace/Structure/AIES t3000r20c',
        'AIES_Aerospace/Structure/AIES top100 a1ur5',
        'AIES_Aerospace/Structure/AIES top100 a1ur5b',
        'AIES_Aerospace/Structure/AIES top500 a1ur5',
    ],

    # Nosecones (ProceduralParts is awesome)
    nosecones => [qw(
        NovaPunch2/Parts/NoseCone
        NovaPunch2/NP_SRB_2_5m_AdvSRB/0_625mASRBNose.cfg
        NovaPunch2/NP_SRB_2_5m_AdvSRB/1_25mASRBNose.cfg
        NovaPunch2/NP_SRB_2_5m_AdvSRB/2_5mASRBNose.cfg
        NovaPunch2/NP_SRB_2_5m_AdvSRB/TD_JupiterSRBNose.png
        NovaPunch2/NP_SRB_2_5m_AdvSRB/TD_JupiterSRBNoseNRM.png
        NovaPunch2/NP_SRB_2_5m_AdvSRB/nose.mu

        NovaPunch2/NP_SRB_AdvBLite/Srb025mNose.cfg
        NovaPunch2/NP_SRB_AdvBLite/Srb0625mNose.cfg
        NovaPunch2/NP_SRB_AdvBLite/Srb125mNose.cfg
        NovaPunch2/NP_SRB_AdvBLite/nose.mu
        NovaPunch2/NP_SRB_AdvBLite/nosefairing.png
        NovaPunch2/NP_SRB_AdvBLite/nosefairingNRM.png

        AIES_Aerospace/Aero/AIEScone0.5Ra
        AIES_Aerospace/Aero/AIESconenoseram

        ),

        # These are all warheads...
        'RftS/Parts/KWNoseconeBlack',
        'RftS/Parts/NPNosecone',
        'RftS/Parts/USWarhead_0_5m.cfg',
        'RftS/Mk3RV',
        'RftS/Mk4RV.cfg',
        'FASA/ICBM/FASA_ICBM_Nosecone',


        # I'm leaving the Gemini nosecones in, because they don't
        # suck.

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
