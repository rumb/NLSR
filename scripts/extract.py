# -*- coding: utf-8 -*-

import sys
import pandas
from StringIO import StringIO
from matplotlib import pyplot
from matplotlib.font_manager import FontProperties

MARKER = '(EXTRACT_MARKER)'
DELIMITER = ','

def extract_lines(filename):
    with open(filename,'r') as f:
        extracted_lines = [line.strip() for line in f if line.find(MARKER) >= 0]
    return extracted_lines

def generate_csv(lines):
    csv = "router,time,delay\n"
    for line in lines:
        ary = line.split(DELIMITER)
        router = get_router(ary)
        time = get_time(ary)
        delay = get_delay(ary)
        csv += router \
               + "," + time \
               + "," + delay\
               + "\n"
    return csv

def get_router(ary):
    ix = ary.index("Router")
    router =  ary[ix+1]
    return router

def get_time(ary):
    t = ary[0][:ary[0].index(" ")]
    return t

def get_delay(ary):
    ix = ary.index("Delay")
    delay = ary[ix+1][:ary[ix+1].index(" ")]
    ns = float(delay)
    s = ns / 1000000000
    return str(s)

def plot(csv,filename=None):
    df = pandas.read_csv(StringIO(csv))
    routers = list(df["router"].drop_duplicates())

    pyplot.title("DataMule")
    pyplot.xlabel("time (Unix time)")
    pyplot.ylabel("delay (s)")
    for router in routers:
        _df = df[df["router"] == router]
        pyplot.plot(list(_df["time"]),_df["delay"],'o',label=router)

    fp = FontProperties(size=10)
    #loc='lower right'で、右下に凡例を表示
    pyplot.legend(prop=fp, bbox_to_anchor=(1.05, 1), loc='upper left', borderaxespad=0)
    pyplot.grid(which="both")
    pyplot.show()
    #pyplot.savefig(filename)

if __name__ == '__main__':

    argvs = sys.argv
    argc = len(argvs)

    if argc == 2:
        input_file = argvs[1]
        lines = extract_lines(input_file)
        csv = generate_csv(lines)
        print csv
        plot(csv)
