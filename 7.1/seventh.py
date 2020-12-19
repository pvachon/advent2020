#!/usr/bin/env python3

import sys
import re

kBAG_COUNT = re.compile('(\d+)\s+(.*)\s+bags?')
kBAG_DEFINITION = re.compile('(.*)\s+bags')

def count_contents(rules, cur_bag):
    if not cur_bag:
        return 0

    bag_sum = 0
    for key, value in cur_bag.items():
        child_sum = count_contents(rules, rules[key])
        bag_sum += value + value * child_sum
        print('  {} -> {} : {} (@ {})'.format(cur_bag, key, value, child_sum))

    return bag_sum

def main():
    print('Advent of Code 7.1: Python Edition (Parsers in Ada Sucks)')

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

    item_count = count_contents(colour_rules, colour_rules['shiny gold'])
    print('There are {} bags required'.format(item_count))

if __name__ == '__main__':
    main()
