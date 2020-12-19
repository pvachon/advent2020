#!/usr/bin/env python3

import sys
import re

kBAG_COUNT = re.compile('(\d+)\s+(.*)\s+bags?')
kBAG_DEFINITION = re.compile('(.*)\s+bags')

def can_contain_gold(rules, current_bag):
    result = False

    if 'shiny gold' in current_bag.keys():
        return True

    for key in current_bag.keys():
        result = result or can_contain_gold(rules, rules.get(key))

    return result

def main():
    print('Advent of Code 7.0: Python Edition (Parsers in Ada Sucks)')

    if len(sys.argv) != 2:
        raise Exception('Wrong number of arguments. Got: {}'.format(sys.argv))

    print('Reading input from {}'.format(sys.argv[1]))

    colour_rules = {}
    with open(sys.argv[1], 'rt') as fp:
        for line in fp:
            line = line.strip()
            t = line.split(' contain ')
            if len(t) != 2:
                raise Exception('Split failed: {}'.format(t))
            bag_spec = kBAG_DEFINITION.match(t[0])
            bag_color = bag_spec[1]
            colour_rules[bag_color] = {}
            if t[1] != 'no other bags.':
                bag_types = t[1][:-1].split(', ')
                for bag_type in bag_types:
                    bag_spec = kBAG_COUNT.match(bag_type)
                    inner_bag_color = bag_spec[2]
                    colour_rules[bag_color][inner_bag_color] = int(bag_spec[1])

    can_gold = 0
    for key, value in colour_rules.items():
        if can_contain_gold(colour_rules, value):
            can_gold += 1

    print('{} bag types can contain gold bags'.format(can_gold))

if __name__ == '__main__':
    main()
