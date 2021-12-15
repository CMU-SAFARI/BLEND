import numpy as np
import pandas as pd
import csv
import seaborn as sns
import sys
import matplotlib.pyplot as plt
from collections import OrderedDict
from argparse import ArgumentParser
import pathlib
import math

def main():
    args = get_args()
    sns.set(style='darkgrid',)
    palette=sns.color_palette('pastel')
    
    for f in args.input:
        sample = f.replace(".csv", "")
        enums = ['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','r','s','t','u','v','w','x','y','z']
        with open(f, 'r') as csvfile:
            data = pd.read_csv(csvfile)
            plt.rcParams['figure.figsize']=(6,3)
            g = []
            dname = data.Data[0]
            g.append(sns.kdeplot(x = "Matches", hue = "Tool", data = data, palette='pastel', fill=True))
            g[0].set_xlabel(xlabel="Length of Matching Bases in Overlaps", fontweight='bold')
            g[0].set_ylabel(ylabel='Proportion', fontweight='bold')
            g[0].set_title(dname, weight='bold')
            g[0].tick_params(labelsize='small')
            g[0].get_legend().set_title(None)

            plt.tight_layout()
            plt.subplots_adjust(top=0.9, bottom=0.1, left=0.13, right=0.95, hspace=0.1, wspace=0.42)
            plt.savefig(f'overlap_finding-matching_blocks_{sample}.pdf')
            #plt.show()

def get_args():
    parser = ArgumentParser(description="Creates PDF plots")
    parser.add_argument("input",
                        nargs='+',
                        help="the dist file(s) to use for plotting")
    return parser.parse_args()


if __name__ == '__main__':
    main()
