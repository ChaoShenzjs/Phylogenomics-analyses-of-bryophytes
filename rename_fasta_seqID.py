#!/usr/bin/env python
import sys
import pysam

with pysam.FastxFile(sys.argv[1]) as fh:
    for r in fh:
        new_name = r.name.split('-')[0]
        print(">"+new_name)
        print(r.sequence)