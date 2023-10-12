#!/usr/bin/env bash

# Script to prepare data

# Get local [ath]
localpath=$(pwd)
echo "Local path: $localpath"

# Create the list directory to save list of remote files and directories
datapath="$localpath/data-source"
echo "Data path: $datapath"
mkdir -p $datapath
cd $datapath;

# Define brick names to process
brick_names='ctdbase'

export datapath
echo $brick_names | xargs -n1 python3 -c 'import sys; from biobricks.brick import Brick; b = Brick.Resolve(sys.argv[1]); print( "|".join([ "PATH_SENTINEL", str(b.path() / "brick"), sys.argv[1], b.url() ] ))' \
  | perl -F'\|' -npe '
  if( $F[0] eq "PATH_SENTINEL" ) {
    shift @F;
    my ($path, $name, $url) = @F;
    symlink($path, "$ENV{datapath}/$name");
    $_ = $url;
  } else { $_ = "" }' | sort > $datapath/brick-manifest
