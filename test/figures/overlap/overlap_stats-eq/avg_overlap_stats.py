import numpy as np
import pandas as pd
import csv
import seaborn as sns
import sys
import matplotlib.pyplot as plt
from collections import OrderedDict
from argparse import ArgumentParser
import pathlib

def main():
    args = get_args()
    sns.set(style='white')
    palette=sns.color_palette('tab10')
    colors = ["#4b71bb", "#f0c041", "#5FA137", "#db8043", "#a3a3a3"]
    enums = ['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','r','s','t','u','v','w','x','y','z']
    dind = 0
    tot_data = 0
    g = []
    for f in args.input:
        sample = f.replace(".csv", "")
        with open(f, 'r') as csvfile:
            if dind == 0:
                dind += 1
                data = pd.read_csv(csvfile)
                tot_data = len(data.Data.unique())
                fig, ax = plt.subplots(2, tot_data, figsize=(11.25,5))
                ind = 0
                for dname in data.Data.unique():
                    selData = data[data.Data.eq(dname)]
                    g.append(sns.barplot(ax=ax[0][ind], x = "Data", y = "Avg. Overlap Len.", hue = "Tool", data = selData, palette=colors, alpha=0.9, edgecolor='black', linewidth=1.2))
                    ax[0][ind].grid(linestyle='--', linewidth=0.4)

                    labels = [item.get_text() for item in ax[0][ind].get_xticklabels()]
                    ax[0][ind].set_xticklabels('')
                    ax[0][ind].set_xlabel("")
                    ax[0][ind].set_ylabel("")

                    ax[0][ind].tick_params(axis="y", which="both", direction="in", left=True, width=0.5)
                    ax[0][ind].tick_params(axis="x", which="both", direction="in", top=True)

                    left,right = ax[0][ind].get_ylim()
                    ax[0][ind].set_ylim(left, right+right*0.1)
                    ax[0][ind].get_legend().set_visible(False)
                    ind += 1
            else:
                ind = 0
                data = pd.read_csv(csvfile)
                tot_data = len(data.Data.unique())
                for dname in data.Data.unique():
                    selData = data[data.Data.eq(dname)]
                    g.append(sns.barplot(ax=ax[1][ind], x = "Data", y = "Avg. Seeds", hue = "Tool", data = selData, palette=colors, alpha=0.9, edgecolor='black', linewidth=1.2))
                    ax[1][ind].grid(linestyle='--', linewidth=0.4)

                    labels = [item.get_text() for item in ax[1][ind].get_xticklabels()]
                    ax[1][ind].set_xticklabels(labels,rotation = 0, ha = 'center', fontweight='bold', fontsize='large')
                    ax[1][ind].set_xlabel("")
                    ax[1][ind].set_ylabel("")

                    ax[1][ind].tick_params(axis="y", which="both", direction="in", left=True, width=0.5)
                    ax[1][ind].tick_params(axis="x", which="both", direction="in", top=True)

                    blend = data[data.Tool.eq('BLEND')]
                    uniqtool = len(data.Tool.unique())
                    labels = []
                    blendval = min(blend[blend.Data.eq(dname)]["Avg. Seeds"])
                    for tool in data.Tool.unique():
                        if tool != 'BLEND':
                            tooldat = data[data.Tool.eq(tool)]
                            if len(tooldat[tooldat.Data.eq(dname)]["Avg. Seeds"]) > 0:
                                val = min(tooldat[tooldat.Data.eq(dname)]["Avg. Seeds"])/blendval
                                labels.append(r'$%.2f{\times}$' % val)
                            else: 
                                labels += ' '
                        else:
                            labels += ' '
                    left,right = ax[1][ind].get_ylim()
                    ax[1][ind].set_ylim(left, right+right*0.1)

                    ind2 = 0
                    for c in ax[1][ind].containers:
                        ax[1][ind].bar_label(c, labels=labels[ind2::uniqtool], fmt='%gs', color='red', size='medium', rotation='90')
                        ind2 += 1

                    left,right = ax[1][ind].get_ylim()
                    ax[1][ind].set_ylim(left, right+right*0.25)
                    ax[1][ind].get_legend().set_visible(False)
                    ind += 1
            
    ax[0][0].set_ylabel("Avg. Overlap Length (Kbp)", fontweight='bold', fontsize='medium')
    ax[1][0].set_ylabel("Avg. Seeds per Overlap", fontweight='bold', fontsize='medium')
    handles, labels = ax[0][2].get_legend_handles_labels()
    fig.legend(handles, labels, bbox_to_anchor=(0.5,1.03), loc='upper center', ncol=len(labels), facecolor='white', framealpha=0, fontsize="large")
    plt.tight_layout()
    plt.subplots_adjust(top=0.95, bottom=0.05, left=0.05, right=0.994, hspace=0.05, wspace=0.25)
    plt.savefig(f'overlap_stats-all_{sample}.pdf')
    plt.show()

def get_args():
    parser = ArgumentParser(description="Creates PDF plots")
    parser.add_argument("input",
                        nargs='+',
                        help="the dist file(s) to use for plotting")
    return parser.parse_args()

if __name__ == '__main__':
    main()