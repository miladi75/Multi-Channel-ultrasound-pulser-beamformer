#!/usr/bin/python
import os

try:
    fh = open('build_app/stx2_tenrec_fpga.fit.summary', 'r')

except IOError as e:
    raise e
    exit()


def find_value(line):
    tmp = line.split()
    return int(tmp[tmp.index('/') - 1].replace(',', ''))


for line in fh.readlines():
    if "ALM" in line:
        alm = find_value(line)
    elif "RAM" in line:
        ram = find_value(line)
    elif "DSP" in line:
        dsp = find_value(line)
    else:
        pass

fh.close()

newpath = "plot_data"

if not os.path.exists(newpath):
    os.makedirs(newpath)

try:
    alm_fh = open(os.path.join(newpath, 'alm.csv'), 'w')
except Exception as e:
    raise e

alm_fh.write('ALM\n%d\n' % alm)
alm_fh.close()

try:
    ram_fh = open(os.path.join(newpath, 'ram.csv'), 'w')
except Exception as e:
    raise e

ram_fh.write('M10K\n%d\n' % ram)
ram_fh.close()

try:
    dsp_fh = open(os.path.join(newpath, 'dsp.csv'), 'w')
except Exception as e:
    raise e

dsp_fh.write('DSP\n%d\n' % dsp)
dsp_fh.close()
