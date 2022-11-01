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
# colors = ["#4b71bb", "#f0c041", "#5FA137", "#db8043", "#a3a3a3", "#aa4499", "#6799ce"]
colors = ["#4b71bb", "#f0c041","#4b71bb", "#f0c041","#4b71bb", "#f0c041","#4b71bb", "#f0c041","#4b71bb", "#f0c041","#4b71bb", "#f0c041","#4b71bb", "#f0c041","#4b71bb", "#f0c041"]
f="perf.csv"

with open(f, 'r') as csvfile:
	csvf = pd.read_csv(csvfile)
	idx=csvf['idx']
	cpu=csvf['CPU Time']
	mem=csvf['Peak Memory (GB)']
	tools=csvf['Tool']
	data=csvf['Data']
	
	#calculating the improvements by X
	memX=[]
	memXVal=[]
	cpuX=[]
	cpuXVal=[]
	for i in range(len(data)):
		if tools[i] == 'BLEND-S':
			blendcpu=cpu[i]
			blendmem=mem[i]
			cpuXVal.append(1)
			cpuX.append(' ')
			memXVal.append(1)
			memX.append(' ')
		else:
			cpuXVal.append(cpu[i]/blendcpu)
			memXVal.append(mem[i]/blendmem)
			cpuX.append(r'$%.1f{\times}$' % cpuXVal[i])
			memX.append(r'$%.1f{\times}$' % memXVal[i])

fig, ax = plt.subplots(2, 1, figsize=(13,5))

####################################################################################################
##Overlapping CPU
####################################################################################################

ax[0].bar(idx, cpu, color=colors, width=0.99, align="center", edgecolor="black", linewidth=1.2)
ax[0].set_yscale("log")

cidx=0
bidx=0
for c in ax[0].containers:
	ax[0].bar_label(c, labels=cpuX[bidx:bidx+len(c.datavalues)], fmt='%gs', color='red', size='large', rotation='vertical', fontweight='bold')
	bidx += len(c.datavalues)

left,right = ax[0].get_ylim()
ax[0].set_ylim(left-left*0.8, right+right*8)
ax[0].margins(x=0.01)
ax[0].grid(linestyle='--', linewidth=0.2) 
ax[0].grid(axis='x', linestyle='--', linewidth=2) 

ax[0].set_xticks([3,6,9,12,15,18,21])
ax[0].tick_params(axis="x", which="both", pad=10, direction="in", left=True, labelleft=True) 
ax[0].tick_params(axis="y", which="both", pad=10, direction="in", rotation=0, top=True) 
ax[0].set_xticklabels([])

####################################################################################################
##Overlapping Memory
####################################################################################################

ax[1].bar(idx, mem, color=colors, width=0.99, align="center", edgecolor="black", linewidth=1.2)
ax[1].set_yscale("log")

cidx=0
bidx=0
for c in ax[1].containers:
	ax[1].bar_label(c, labels=memX[bidx:bidx+len(c.datavalues)], fmt='%gs', color='red', size='large', rotation='vertical', fontweight='bold')
	bidx += len(c.datavalues)

left,right = ax[1].get_ylim()
ax[1].set_ylim(left-left*0.8, right+right*1.5)
ax[1].margins(x=0.01)
ax[1].grid(linestyle='--', linewidth=0.2) 
ax[1].grid(axis='x', linestyle='--', linewidth=2) 

ax[1].set_xticks([3,6,9,12,15,18,21])
ax[1].tick_params(axis="x", which="both", pad=10, direction="in", left=True, labelleft=True) 
ax[1].tick_params(axis="y", which="both", pad=10, direction="in", rotation=0, top=True) 
ax[1].set_xticklabels([])

plt.subplots_adjust(top=0.99, bottom=0.01, left=0.005, right=0.995, hspace=0.05, wspace=0.2)
fig.savefig("overlapping_blend_perf_mem.pdf")

plt.show()