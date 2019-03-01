#!/usr/bin/env python

import os, time

run_dir = os.path.dirname(os.path.abspath(__file__))
home_dir = os.getenv('HOME')
bkp = '.{}.bkp'.format(time.strftime('%Y%m%d_%H%M%S'))

for file in os.listdir(run_dir):
    if os.path.isfile(file) and file.startswith('.') and not file.endswith('.swp'):
        dot_file = '{}/{}'.format(run_dir, file)
        home_file = '{}/{}'.format(home_dir, file)
        if os.path.isfile(home_file):
            os.rename(home_file, home_file + bkp)
        os.symlink(dot_file, home_file)
