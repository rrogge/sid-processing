#!/bin/bash

set +x

if [ -z "$SID_HOME" ]; then
  SID_HOME="$HOME/Workspaces/SID Processing"
fi
cd "$SID_HOME"

ANALYTICAL_DATA_DIR="$SID_HOME/Analytical Data/"
BASELINE_DATA_DIR="$SID_HOME/Baseline Data/"
OUTPUT_DATA_DIR="$SID_HOME/Output Data/"
RAW_DATA_DIR="$SID_HOME/Raw Data/"

function usage()
{
    echo "Usage: $1 [-a ANALYTICAL-DATA-DIR] [-b BASELINE-DIR] [-o OUTPUT-DATA-DIR] [-r RAW-DATA-DIR]"
}

args=`getopt a:b:o:r: $*`
if [ $? != 0 ]; then
    usage $0
    exit 1
fi

set -- $args
for i; do
    case "$i" in
        -a)
            ANALYTICAL_DATA_DIR=$2
            shift; shift;;
        -b)
            BASELINE_DATA_DIR=$2
            shift; shift;;
        -o)
            OUTPUT_DATA_DIR=$2
            shift; shift;;
        -r)
            RAW_DATA_DIR=$2
            shift; shift;;
        --)
           shift; break;;
    esac
done
if [ -z "$ANALYTICAL_DATA_DIR" -o -z "$BASELINE_DATA_DIR" -o -z "$OUTPUT_DATA_DIR" -o -z "$RAW_DATA_DIR" ]; then
  usage $0
  exit 1
fi

RScript Code/sid.process.data.R analytical.data.dir="$ANALYTICAL_DATA_DIR" baseline.data.dir="$BASELINE_DATA_DIR" output.data.dir="$OUTPUT_DATA_DIR" raw.data.dir="$RAW_DATA_DIR"
if [ "$?" != "0" ]; then
	echo Error processing data.
	exit 1
fi
