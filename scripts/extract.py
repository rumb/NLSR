# -*- coding: utf-8 -*-

import sys

if __name__ == '__main__':

    argvs = sys.argv
    argc = len(argvs)
    if argc == 2:
        input_file = argvs[1]

        with open(input_file,'r') as f:
            lines = f.readlines()

        for line in lines:
            if line.find("(EXTRACT_MARKER)") >= 0:
                print line[:-1]

    elif argvs == 3:
        input_file = argvs[1]
        output_file = argvs[2]

        with open(input_file,'r') as f:
            lines = f.readlines()

        with open(output_file,'a') as f:
            for line in lines:
                if line.find("(EXTRACT_MARKER)") >= 0:
                    f.write(line[:-1])
