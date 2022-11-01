import sys
import matplotlib.pyplot as plt 
import matplotlib 
import numpy as np 
import seaborn as sns
import pandas as pd
import csv
from collections import OrderedDict
import pathlib

matplotlib.rc("figure", facecolor="white")
width = 0.5
palette=sns.color_palette('tab10')
colors = ["#4b71bb", "#f0c041", "#5FA137", "#db8043", "#a3a3a3", "#aa4499", "#6799ce"]
f="readCounts.tab"

with open(f, 'r') as csvfile:
	csvf = pd.read_csv(csvfile, sep='\t', low_memory=False)
	csvf = csvf[csvf["'BLEND'"] <= 500]
	csvf = csvf[csvf["'minimap2'"] <= 500]
	chrs=csvf["#'chr'"]
	uniqchrs = chrs.unique();
	pos=csvf["'start'"]
	blend=csvf["'BLEND'"]
	minimap2=csvf["'minimap2'"]
	
fig, ax = plt.subplots(12, 2, figsize=(12,12))

####################################################################################################
##Coverage
####################################################################################################

for i in range(12):
	uniqcsv = csvf[csvf["#'chr'"].eq(uniqchrs[i])]
	sns.lineplot(ax=ax[i][0], x = uniqcsv["'start'"], y = uniqcsv["'BLEND'"], linewidth=0.8, alpha = 0.8, color=colors[6])
	sns.lineplot(ax=ax[i][1], x = uniqcsv["'start'"], y = uniqcsv["'minimap2'"], linewidth=0.8, alpha=0.8, color=colors[2])
	# xlabel = "Chromosome position (chr" + uniqchrs[i] + ")"
	ax[i][0].margins(x=0.01)
	ax[i][0].set_ylabel("Cov. (x)", fontweight='bold')
	ax[i][0].set_xlabel("")
	ax[i][1].margins(x=0.01)
	ax[i][1].set_xlabel("")
	ax[i][1].set_ylabel("")
	left,right = ax[i][0].get_ylim()
	left2,right2 = ax[i][1].get_ylim()
	ax[i][0].set_ylim(min(left,left2), max(right,right2))
	ax[i][1].set_ylim(min(left,left2), max(right,right2))
	ax[i][0].grid(linestyle='--', linewidth=0.4)
	ax[i][1].grid(linestyle='--', linewidth=0.4)
	ax[i][0].ticklabel_format(axis='x', style='sci', useMathText=True)
	ax[i][1].ticklabel_format(axis='x', style='sci', useMathText=True)

xlabel = "Chromosome position"
ax[11][1].set_xlabel(xlabel, fontweight='bold')
ax[11][0].set_xlabel(xlabel, fontweight='bold')

plt.subplots_adjust(top=0.99, bottom=0.04, left=0.05, right=0.985, hspace=0.9, wspace=0.1)
fig.savefig("coverage1-12.pdf")

fig, ax = plt.subplots(12, 2, figsize=(12,12))

####################################################################################################
##Coverage 12:24
####################################################################################################

for i in range(12):
	uniqcsv = csvf[csvf["#'chr'"].eq(uniqchrs[i+12])]
	sns.lineplot(ax=ax[i][0], x = uniqcsv["'start'"], y = uniqcsv["'BLEND'"], linewidth=0.8, alpha = 0.8, color=colors[6])
	sns.lineplot(ax=ax[i][1], x = uniqcsv["'start'"], y = uniqcsv["'minimap2'"], linewidth=0.8, alpha=0.8, color=colors[2])
	# xlabel = "Chromosome position (chr" + uniqchrs[i+12] + ")"
	ax[i][0].margins(x=0.01)
	ax[i][0].set_ylabel("Cov. (x)", fontweight='bold')
	ax[i][0].set_xlabel("")
	ax[i][1].margins(x=0.01)
	ax[i][1].set_xlabel("")
	ax[i][1].set_ylabel("")
	left,right = ax[i][0].get_ylim()
	left2,right2 = ax[i][1].get_ylim()
	ax[i][0].set_ylim(min(left,left2), max(right,right2))
	ax[i][1].set_ylim(min(left,left2), max(right,right2))
	ax[i][0].grid(linestyle='--', linewidth=0.4)
	ax[i][1].grid(linestyle='--', linewidth=0.4)
	ax[i][0].ticklabel_format(axis='x', style='sci', useMathText=True)
	ax[i][1].ticklabel_format(axis='x', style='sci', useMathText=True)

xlabel = "Chromosome position"
ax[11][1].set_xlabel(xlabel, fontweight='bold')
ax[11][0].set_xlabel(xlabel, fontweight='bold')

plt.subplots_adjust(top=0.99, bottom=0.04, left=0.05, right=0.988, hspace=0.9, wspace=0.1)
fig.savefig("coverage13-24.pdf")

# plt.show()