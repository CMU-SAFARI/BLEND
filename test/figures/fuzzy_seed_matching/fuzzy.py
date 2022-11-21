import sys
import matplotlib.pyplot as plt 
import matplotlib 
import numpy as np 
import seaborn as sns
import pandas as pd
import csv
from collections import OrderedDict
import pathlib
from matplotlib.ticker import PercentFormatter

matplotlib.rc("figure", facecolor="white")
width = 0.5
palette=sns.color_palette('tab10')
colors = ["#4b71bb", "#f0c041", "#5FA137", "#aa4499", "#db8043", "#a3a3a3","#6799ce"]
colors2 = ["#5FA137"]
palette1=sns.color_palette('rocket')
palette2=colors2 + palette1
f="fuzzy_matches.csv"

with open(f, 'r') as csvfile:
	csvf = pd.read_csv(csvfile)
	edit=csvf["Edit Distance"]
	ratio=csvf["Ratio"]
	number=csvf["Number"]
	tool=csvf["Tool"]
	
fig, ax = plt.subplots(2, 1, figsize=(13,5))
####################################################################################################
##Fuzzy Plotting (Number of collisions)
####################################################################################################

# sns.kdeplot(ax = ax, data=csvf, x = "Edit Distance", hue = "Tool", palette=colors, fill=True, linewidth=1.2)
# sns.lineplot(ax=ax, x = edit, y = ratio, hue=tool, linewidth=0.8, alpha = 0.8, color=colors[6])
sns.barplot(ax=ax[0], x = edit, y = number, hue=tool, palette=palette2, alpha=0.9, edgecolor='black', linewidth=1.2)

# ax[0].yaxis.set_major_formatter(PercentFormatter(1 / 1))  # show axis such that 1/binwidth corresponds to 100%
# ax[0].set_ylabel(f'Probability for a bin width of 1')

ax[0].margins(x=0.01)
ax[0].grid(axis='y', linestyle='--', linewidth=0.5) 

ax[0].set_xticks(np.arange(0, 16, 1))
ax[0].set_xlim([0,16])
# ax[0].set_ylim([0,0.35])
ax[0].tick_params(axis="x", which="both", pad=10, direction="in", left=True, labelleft=True) 
ax[0].tick_params(axis="y", which="both", pad=10, direction="in", rotation=0, top=True) 

ax[0].get_legend().set_visible(False)
ax[0].set_ylabel("")
ax[0].set_xlabel("")
ax[0].set_xticklabels([])

####################################################################################################
##Fuzzy Plotting (Ratio)
####################################################################################################

# sns.kdeplot(ax = ax, data=csvf, x = "Edit Distance", hue = "Tool", palette=colors, fill=True, linewidth=1.2)
# sns.lineplot(ax=ax, x = edit, y = ratio, hue=tool, linewidth=0.8, alpha = 0.8, color=colors[6])
sns.barplot(ax=ax[1], x = edit, y = ratio, hue=tool, palette=palette2, alpha=0.9, edgecolor='black', linewidth=1.2)


# ax[1].yaxis.set_major_formatter(PercentFormatter(1 / 1))  # show axis such that 1/binwidth corresponds to 100%
# ax[1].set_ylabel(f'Probability for a bin width of 1')

ax[1].margins(x=0.01)
ax[1].grid(axis='y', linestyle='--', linewidth=0.5) 

ax[1].set_xticks(np.arange(0, 16, 1))
ax[1].set_xlim([0,16])
ax[1].set_ylim([0,0.35])
ax[1].tick_params(axis="x", which="both", pad=10, direction="in", left=True, labelleft=True) 
ax[1].tick_params(axis="y", which="both", pad=10, direction="in", rotation=0, top=True) 

ax[1].get_legend().set_visible(False)
ax[1].set_ylabel("")
ax[1].set_xlabel("")

plt.subplots_adjust(top=0.985, bottom=0.06, left=0.05, right=0.995, hspace=0.15, wspace=0.2)
fig.savefig("fuzzy_matches.pdf")
# plt.show()
