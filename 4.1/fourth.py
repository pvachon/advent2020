#!/usr/bin/env python3

import sys
import re

kHEX = re.compile('^\#[0-9a-f]{6}$')
kPASSPORT = re.compile('^[0-9]{9}$')
kKEY_REQUIRED = ['byr', 'iyr', 'eyr', 'hgt', 'hcl', 'ecl', 'pid']

def check_passport(passport):
    keys = passport.keys()
    found = 0
    for key in kKEY_REQUIRED:
        if key in keys:
            found += 1

    if found < len(kKEY_REQUIRED):
        return False

    if len(passport['byr']) != 4:
        return False
    byr = int(passport['byr'])
    if byr < 1920 or byr > 2002:
        return False

    if len(passport['iyr']) != 4:
        return False
    iyr = int(passport['iyr'])
    if iyr < 2010 or iyr > 2020:
        return False

    if len(passport['eyr']) != 4:
        return False
    eyr = int(passport['eyr'])
    if eyr < 2020 or eyr > 2030:
        return False

    if passport['hgt'][-2:] == 'in':
        hgt = int(passport['hgt'][:-2])
        if hgt < 59 or hgt > 76:
            return False
    elif passport['hgt'][-2:] == 'cm':
        hgt = int(passport['hgt'][:-2])
        if hgt < 150 or hgt > 193:
            return False
    else:
        return False

    if not kHEX.match(passport['hcl']):
        return False

    if passport['ecl'] not in ['amb', 'blu', 'brn', 'gry', 'grn', 'hzl', 'oth']:
        return False

    if not kPASSPORT.match(passport['pid']):
        return False

    print('{:4} {:4} {:4} {:>5} {:7} {:3} {:9}'.format(
        passport['byr'],
        passport['iyr'],
        passport['eyr'],
        passport['hgt'],
        passport['hcl'],
        passport['ecl'],
        passport['pid']))

    return True

def update_dupe(to, dict_from):
    for key, val in dict_from.items():
        if key in to.keys():
            print('Duplicate key found: {}: {}'.format(key, val))
    to.update(dict_from)

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
                # print(keys)
                if check_passport(keys):
                    valid += 1

                keys = {}
            else:
                update_dupe(keys, {y[0]: y[1] for y in [x.split(':') for x in line.strip().split(' ')]})
        # print(keys)
        if check_passport(keys):
            valid += 1

    print('Valid passports: {}'.format(valid))

if __name__ == '__main__':
    main()
