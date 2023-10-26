#!/usr/bin/env bash

set -e

# Script to create N-Triples graph using RML

# Get local path
localpath=$(pwd)
echo "Local path: $localpath"

# Create raw directory
rawpath="$localpath/raw"
mkdir -p $rawpath
echo "Raw path: $rawpath"

# Process RML mapping
python3 -m morph_kgc stages/ctdbase.ini

# Sort in-place for reproducible hash
sort -o $rawpath/knowledge-graph.nt $rawpath/knowledge-graph.nt
