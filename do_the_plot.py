#!/usr/bin/python3

import sys
from os import system
import matplotlib.pyplot as plt

if 'dracula' in plt.style.available:
    plt.style.use('dracula')
else:
    print("What are you doing with your life. "
          "Install draculatheme.com/matplotlib right now.")
    raise SystemExit

if len(sys.argv) != 2 or sys.argv[1] != "--running-it-from-the-shell-file":
    system("./get_the_git.sh \
            --running-it-from-the-python-file")

times = [int(x) for x in open("times.txt").read().split(' ') if x != '']

plt.hist(times, 24, color='C1')
plt.savefig("results.png", bbox_inches="tight")
