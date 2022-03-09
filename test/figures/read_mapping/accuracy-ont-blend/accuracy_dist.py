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
import copy

def main():
    args = get_args()
    sns.set(style='white',)
    palette=sns.color_palette('tab10')
    colors = ["#4b71bb", "#f0c041", "#5FA137", "#db8043", "#a3a3a3"]
    enums = ['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','r','s','t','u','v','w','x','y','z']
    
    for f in args.input:
        sample = f.replace(".csv", "")
        enums = ['BLEND-I','BLEND-S','d','e','f','g','h','i','j','k','l','m','n','o','p','r','s','t','u','v','w','x','y','z']
        with open(f, 'r') as csvfile:
            data = pd.read_csv(csvfile)
            tot_data = len(data.Tool.unique())
            nrow = tot_data
            ncol = 1
            fig, ax = plt.subplots(nrow, ncol, figsize=(8,8))
            g = []
            ind = 0
            for dname in data.Tool.unique():
                selData = data[data.Tool.eq(dname)]
                g.append(sns.kdeplot(ax=ax[ind], x = "Distance", hue = "Chromosome", data = selData, palette='plasma', alpha=.9, common_norm=False))
                g[ind].legend_._set_loc(2)
                # (loc='upper left', facecolor='white', framealpha=0, fontsize="medium")
                ax[ind].grid(linestyle='--', linewidth=0.4)

                g[ind].set_ylabel(ylabel='Proportion ('+enums[ind]+')', fontweight='bold')
                g[ind].set_xlabel("")

                ax[ind].tick_params(axis="y", which="both", direction="in", left=True, width=0.5)
                ax[ind].tick_params(axis="x", which="both", direction="in", top=True)

                ax[ind].set_xlim(-50, 50)
                ind += 1

            g[ind-1].set_xlabel('Distance to True Location', fontweight='bold')
            plt.subplots_adjust(top=0.995, bottom=0.05, left=0.09, right=0.99, hspace=0.2, wspace=0.2)
            plt.savefig(f'read_mapping-accuracy-distribution_{sample}.pdf')
            plt.show()

def get_args():
    parser = ArgumentParser(description="Creates PDF plots")
    parser.add_argument("input",
                        nargs='+',
                        help="the dist file(s) to use for plotting")
    return parser.parse_args()


if __name__ == '__main__':
    main()
