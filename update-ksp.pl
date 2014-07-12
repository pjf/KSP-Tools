#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;
use autodie qw(:all);
use FindBin qw($Bin);
use File::Spec;
use IPC::System::Simple qw(capture);
use constant MOD_GAMEDATA => 'GameData';

# Update KSP GameData from git repos.
# Assumes you love git as much as I do. :)
# 
# Paul '@pjf' Fenwick, July 2014
#
# License: Same as Perl itself

my $Player_GameData = "$ENV{HOME}/Steam/SteamApps/common/Kerbal Space Program/GameData";

# Turn mods into absolute paths
my @mods = 
    map { 
        s{/$}{};    # Remove trailing slash
        { name => $_, path => File::Spec->rel2abs( $_ ) } 
    } @ARGV
;

if (not @mods) {
    die "Usage: $0: mod1 mod2 mod3...\n";
}

check_repo_clean($Player_GameData, "GameDir");

foreach my $mod (@mods) {
    chdir($mod->{path});
    check_repo_clean('.', $mod->{name});

    say "Fetching updates for $mod->{name}\n";
    system('git pull');

    my $git_version = capture('git rev-parse --short HEAD');
    
    # If the mod has a gamedata directory, switch to it
    if (-d MOD_GAMEDATA) { chdir(MOD_GAMEDATA) }

    # Now let's install
    foreach my $dir ( glob("*") ) {
        next if not -d $dir;
        system('cp', '-r', $dir, $Player_GameData);
    }

    record_update($Player_GameData, "Updated $mod->{name} to $git_version");
}

sub check_repo_clean {
    my ($path, $label) = @_;

    chdir($path);

    my $git_status = capture('git status --porcelain');

    if ($git_status =~ /\S/) {
        die "$label git repo not clean.\n$git_status\n";
    }
    
    return;
}

sub record_update {
    my ($dir, $msg, $name) = @_;

    chdir($dir);

    my $changes = capture('git status --porcelain');

    if ($changes !~ /\S/) {
        # No changes
        return;
    }

    say $msg;
    say $changes;
    system(qw(git commit -m), $msg, '.');

    return;
}
