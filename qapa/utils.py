from __future__ import print_function
import sys

def eprint(*args, **kwargs):
    tag = kwargs.pop('tag', 'qapa')
    print("[{}] {}".format(tag, *args), file=sys.stderr, **kwargs)
