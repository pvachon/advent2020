#!/usr/bin/env python3

import sys

def check_passport(passport):
    keys = passport.keys()
    found = 0
    required = ['byr', 'iyr', 'eyr', 'hgt', 'hcl', 'ecl', 'pid']
    for key in required:
        if key in keys:
            found += 1
    return found == len(required)

def main():
    print('Advent of Code 4.0: Python Edition (Parsers in Ada Sucks)')

    if len(sys.argv) != 2:
        raise Exception('Wrong number of arguments. Got: {}'.format(sys.argv))

    print('Reading input from {}'.format(sys.argv[1]))

    valid = 0
    with open(sys.argv[1], 'rt') as fp:
        keys = {}
        for line in fp:
            if not line.strip():
                # Check passport meets constraints
                print(keys)
                if check_passport(keys):
                    valid += 1

                keys = {}
            else:
                keys.update({y[0]: y[1] for y in [x.split(':') for x in line.strip().split(' ')]})
        print(keys)
        if check_passport(keys):
            valid += 1

    print('Valid passports: {}'.format(valid))

if __name__ == '__main__':
    main()
