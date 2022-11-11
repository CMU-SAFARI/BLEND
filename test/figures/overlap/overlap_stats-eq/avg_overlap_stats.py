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
f="overlap_stats.csv"

with open(f, 'r') as csvfile:
	csvf = pd.read_csv(csvfile)
	idx=csvf['idx']
	n_overlaps=csvf['Number of Overlaps (M)']
	avg_overlaplen=csvf['Avg. Overlap Len. (Kbp)']
	avg_seeds=csvf['Avg. Seeds']
	tools=csvf['Tool']
	data=csvf['Data']
	
	#calculating the improvements by X
	n_overlapsX=[]
	n_overlapsXVal=[]
	avg_overlapX=[]
	avg_overlapXVal=[]
	avg_seedsX=[]
	avg_seedsXVal=[]

	for i in range(len(data)):
		if tools[i] == 'BLEND-I':
			blend_overlaps=n_overlaps[i]
			n_overlapsX.append(' ')
			n_overlapsXVal.append(1)
			
			blend_ovlen=avg_overlaplen[i]
			avg_overlapX.append(' ')
			avg_overlapXVal.append(1)
			
			blend_avgseed=avg_seeds[i]
			avg_seedsX.append(' ')
			avg_seedsXVal.append(1)
			
		else:
			n_overlapsXVal.append(n_overlaps[i]/blend_overlaps)
			n_overlapsX.append(r'$%.1f{\times}$' % n_overlapsXVal[i])

			avg_overlapXVal.append(avg_overlaplen[i]/blend_ovlen)
			avg_overlapX.append(r'$%.1f{\times}$' % avg_overlapXVal[i])

			avg_seedsXVal.append(avg_seeds[i]/blend_avgseed)
			avg_seedsX.append(r'$%.1f{\times}$' % avg_seedsXVal[i])
			
fig, ax = plt.subplots(3, 7, figsize=(7,7))

####################################################################################################
##Total overlap bases
####################################################################################################

ax[0][0].bar(idx[0:3], n_overlaps[0:3], color=colors, width=0.99, align="center", edgecolor="black", linewidth=1.2)
ax[0][0].set_yscale("log")
ax[0][1].bar(idx[3:6], n_overlaps[3:6], color=colors, width=0.99, align="center", edgecolor="black", linewidth=1.2)
ax[0][1].set_yscale("log")
ax[0][2].bar(idx[6:9], n_overlaps[6:9], color=colors, width=0.99, align="center", edgecolor="black", linewidth=1.2)
ax[0][3].bar(idx[9:12], n_overlaps[9:12], color=colors, width=0.99, align="center", edgecolor="black", linewidth=1.2)
ax[0][4].bar(idx[12:15], n_overlaps[12:15], color=colors, width=0.99, align="center", edgecolor="black", linewidth=1.2)
ax[0][5].bar(idx[15:18], n_overlaps[15:18], color=colors, width=0.99, align="center", edgecolor="black", linewidth=1.2)
ax[0][6].bar(idx[18:21], n_overlaps[18:21], color=colors, width=0.99, align="center", edgecolor="black", linewidth=1.2)

cidx=0
bidx=0
for i in range(len(ax[0])):
	for c in ax[0][i].containers:
		ax[0][i].bar_label(c, labels=n_overlapsX[bidx:bidx+len(c.datavalues)], fmt='%gs', color='red', size='large', rotation='vertical', fontweight='bold')
		bidx += len(c.datavalues)
		left,right = ax[0][i].get_ylim()
		ax[0][i].set_ylim(left-left*0.8, right+right*0.35)
		ax[0][i].margins(x=0.01)
		ax[0][i].grid(axis='y', linestyle='--', linewidth=0.2) 
		ax[0][i].tick_params(axis="x", which="both", pad=10, direction="in", left=True, labelleft=True) 
		ax[0][i].tick_params(axis="y", which="both", pad=3, direction="in", rotation=0, top=True) 
		ax[0][i].set_xticklabels([])
		# ax[0][i].set_yticklabels([])

ax[0][3].tick_params(axis="y", which="both", pad=2, direction="in", rotation=65, top=True) 

left,right = ax[0][0].get_ylim()
ax[0][0].set_ylim(left-left*0.8, right+right*30)

left,right = ax[0][1].get_ylim()
ax[0][1].set_ylim(left-left*0.8, right+right*30)

####################################################################################################
##Average overlap
####################################################################################################

ax[1][0].bar(idx[0:3], avg_overlaplen[0:3], color=colors, width=0.99, align="center", edgecolor="black", linewidth=1.2)
ax[1][1].bar(idx[3:6], avg_overlaplen[3:6], color=colors, width=0.99, align="center", edgecolor="black", linewidth=1.2)
ax[1][2].bar(idx[6:9], avg_overlaplen[6:9], color=colors, width=0.99, align="center", edgecolor="black", linewidth=1.2)
ax[1][3].bar(idx[9:12], avg_overlaplen[9:12], color=colors, width=0.99, align="center", edgecolor="black", linewidth=1.2)
ax[1][4].bar(idx[12:15], avg_overlaplen[12:15], color=colors, width=0.99, align="center", edgecolor="black", linewidth=1.2)
ax[1][5].bar(idx[15:18], avg_overlaplen[15:18], color=colors, width=0.99, align="center", edgecolor="black", linewidth=1.2)
ax[1][6].bar(idx[18:21], avg_overlaplen[18:21], color=colors, width=0.99, align="center", edgecolor="black", linewidth=1.2)

cidx=0
bidx=0
for i in range(len(ax[1])):
	for c in ax[1][i].containers:
		ax[1][i].bar_label(c, labels=avg_overlapX[bidx:bidx+len(c.datavalues)], fmt='%gs', color='red', size='large', rotation='vertical', fontweight='bold')
		bidx += len(c.datavalues)
	left,right = ax[1][i].get_ylim()
	ax[1][i].set_ylim(left-left*0.8, right+right*0.35)
	ax[1][i].margins(x=0.01)
	ax[1][i].grid(axis='y', linestyle='--', linewidth=0.2) 
	ax[1][i].tick_params(axis="x", which="both", pad=10, direction="in", left=True, labelleft=True) 
	ax[1][i].tick_params(axis="y", which="both", pad=3, direction="in", rotation=0, top=True) 
	ax[1][i].set_xticklabels([])
	# ax[1][i].set_yticklabels([])

####################################################################################################
##Average seeds
####################################################################################################

ax[2][0].bar(idx[0:3], avg_seeds[0:3], color=colors, width=0.99, align="center", edgecolor="black", linewidth=1.2)
ax[2][1].bar(idx[3:6], avg_seeds[3:6], color=colors, width=0.99, align="center", edgecolor="black", linewidth=1.2)
ax[2][2].bar(idx[6:9], avg_seeds[6:9], color=colors, width=0.99, align="center", edgecolor="black", linewidth=1.2)
ax[2][3].bar(idx[9:12], avg_seeds[9:12], color=colors, width=0.99, align="center", edgecolor="black", linewidth=1.2)
ax[2][4].bar(idx[12:15], avg_seeds[12:15], color=colors, width=0.99, align="center", edgecolor="black", linewidth=1.2)
ax[2][5].bar(idx[15:18], avg_seeds[15:18], color=colors, width=0.99, align="center", edgecolor="black", linewidth=1.2)
ax[2][6].bar(idx[18:21], avg_seeds[18:21], color=colors, width=0.99, align="center", edgecolor="black", linewidth=1.2)

cidx=0
bidx=0
for i in range(len(ax[2])):
	for c in ax[2][i].containers:
		ax[2][i].bar_label(c, labels=avg_seedsX[bidx:bidx+len(c.datavalues)], fmt='%gs', color='red', size='large', rotation='vertical', fontweight='bold')
		bidx += len(c.datavalues)
	left,right = ax[2][i].get_ylim()
	ax[2][i].set_ylim(left-left*0.8, right+right*0.4)
	ax[2][i].margins(x=0.01)
	ax[2][i].grid(axis='y', linestyle='--', linewidth=0.2) 
	ax[2][i].tick_params(axis="x", which="both", pad=10, direction="in", left=True, labelleft=True) 
	ax[2][i].tick_params(axis="y", which="both", pad=3, direction="in", rotation=0, top=True) 
	ax[2][i].set_xticklabels([])
	# ax[2][i].set_yticklabels([])

plt.subplots_adjust(top=0.99, bottom=0.015, left=0.05, right=0.995, hspace=0.2, wspace=0.5)
fig.savefig("overlapping_stats_eq.pdf")

# plt.show()