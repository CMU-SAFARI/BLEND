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
    sns.set(style='white',)
    palette=sns.color_palette('tab10')
    colors = ["#4b71bb", "#f0c041", "#5FA137", "#db8043", "#a3a3a3"]
    
    for f in args.input:
        sample = f.replace(".csv", "")
        enums = ['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','r','s','t','u','v','w','x','y','z']
        with open(f, 'r') as csvfile:
            data = pd.read_csv(csvfile)
            tot_data = len(data.Data.unique())
            nrows = math.ceil(tot_data/2)
            fig, ax = plt.subplots(nrows,2, figsize=(12,6))
            g = []
            ind = 0
            row = 0
            col = 0
            for dname in data.Data.unique():
                selData = data[data.Data.eq(dname)]
                g.append(sns.kdeplot(ax=ax[row][col], x = "Percentage", hue = "Tool", data = selData, palette='tab10', fill=True, linewidth=1.2))
                ax[row][col].grid(linestyle='--', linewidth=0.4)

                g[ind].set_xlim(0, 100)
                g[ind].set_title('('+enums[ind]+') '+dname, weight='bold', fontsize='large')
                g[ind].set_xticks(np.arange(0, 101, 5))
                ax[row][col].tick_params(labelsize='small')
                g[ind].get_legend().set_title(None)
                ax[row][col].get_legend().set_visible(False)
                ind += 1
                ax[row][col].set_xlabel("")
                ax[row][col].set_ylabel('Proportion', fontweight='bold', fontsize='large')

                if col == 0:
                    col = 1
                else:
                    ax[row][col].set_ylabel("")
                    col = 0
                    row += 1

            ax[nrows-1][0].set_xlabel("GC Content (%)", fontweight='bold', fontsize='large')
            ax[nrows-1][1].set_xlabel("GC Content (%)", fontweight='bold', fontsize='large')
            olegend = ax[0][0].legend_
            handles = olegend.legendHandles
            labels = [t.get_text() for t in olegend.get_texts()]
            fig.legend(handles, labels, bbox_to_anchor=(0.53,1.025), loc='upper center', ncol=len(labels), facecolor='white', framealpha=0, fontsize="large")
            plt.tight_layout()
            plt.subplots_adjust(top=0.92, bottom=0.08, left=0.07, right=0.99, hspace=0.3, wspace=0.15)
            plt.savefig(f'gc_content-all-{sample}.pdf')
            plt.show()

def get_args():
    parser = ArgumentParser(description="Creates PDF plots")
    parser.add_argument("input",
                        nargs='+',
                        help="the dist file(s) to use for plotting")
    return parser.parse_args()


if __name__ == '__main__':
    main()