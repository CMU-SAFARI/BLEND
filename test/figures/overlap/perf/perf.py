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
	toolCpu = {"minimap2": [], "MHAP": []}
	toolMem = {"minimap2": [], "MHAP": []}

	for i in range(len(data)):
		if tools[i] == 'BLEND':
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
			toolCpu[tools[i]].append(cpu[i]/blendcpu)
			toolMem[tools[i]].append(mem[i]/blendmem)

# Minimap2 CPU and memory results for latex
print("\\newcommand\\avgovpM{$%.1f\\times$\\xspace}\n\\newcommand\\avgovpHM{$%.1f\\times$\\xspace}\n\\newcommand\\ovpM{$%.1f\\times$\\xspace}\n\\newcommand\\movpM{$%.1f\\times$\\xspace}\n" % (sum(toolCpu["minimap2"])/len(toolCpu["minimap2"]), sum(toolCpu["minimap2"][:3])/3, max(toolCpu["minimap2"]), min(toolCpu["minimap2"])))

print("\\newcommand\\avgovmM{$%.1f\\times$\\xspace}\n\\newcommand\\avgovmHM{$%.1f\\times$\\xspace}\n\\newcommand\\ovmM{$%.1f\\times$\\xspace}\n\\newcommand\\movmM{$%.1f\\times$\\xspace}\n" % (sum(toolMem["minimap2"])/len(toolMem["minimap2"]), sum(toolMem["minimap2"][:3])/3, max(toolMem["minimap2"]), min(toolMem["minimap2"])))

# MHAP CPU and memory results for latex
print("\\newcommand\\avgovpMH{$%.1f\\times$\\xspace}\n\\newcommand\\avgovpHMH{$%.1f\\times$\\xspace}\n\\newcommand\\ovpMH{$%.1f\\times$\\xspace}\n\\newcommand\\movpMH{$%.1f\\times$\\xspace}\n" % (sum(toolCpu["MHAP"])/len(toolCpu["MHAP"]), sum(toolCpu["MHAP"][:3])/3, max(toolCpu["MHAP"]), min(toolCpu["MHAP"])))
print("\\newcommand\\avgovmMH{$%.1f\\times$\\xspace}\n\\newcommand\\avgovmHMH{$%.1f\\times$\\xspace}\n\\newcommand\\ovmMH{$%.1f\\times$\\xspace}\n\\newcommand\\movmMH{$%.1f\\times$\\xspace}\n" % (sum(toolMem["MHAP"])/len(toolMem["MHAP"]), sum(toolMem["MHAP"][:3])/3, max(toolMem["MHAP"]), min(toolMem["MHAP"])))

fig, ax = plt.subplots(2, 1, figsize=(13,5))

####################################################################################################
##Overlapping CPU
####################################################################################################

ax[0].bar(idx[0:3], cpu[0:3], color=colors, width=0.99, align="center", edgecolor="black", linewidth=1.2)
ax[0].bar(idx[3:6], cpu[3:6], color=colors, width=0.99, align="center", edgecolor="black", linewidth=1.2)
ax[0].bar(idx[6:9], cpu[6:9], color=colors, width=0.99, align="center", edgecolor="black", linewidth=1.2)
ax[0].bar(idx[9:11], cpu[9:11], color=colors, width=0.99, align="center", edgecolor="black", linewidth=1.2)
ax[0].bar(idx[11:14], cpu[11:14], color=colors, width=0.99, align="center", edgecolor="black", linewidth=1.2)
ax[0].bar(idx[14:17], cpu[14:17], color=colors, width=0.99, align="center", edgecolor="black", linewidth=1.2)
ax[0].bar(idx[17:20], cpu[17:20], color=colors, width=0.99, align="center", edgecolor="black", linewidth=1.2)
ax[0].set_yscale("log")

cidx=0
bidx=0
for c in ax[0].containers:
	ax[0].bar_label(c, labels=cpuX[bidx:bidx+len(c.datavalues)], fmt='%gs', color='red', size='large', rotation='vertical', fontweight='bold')
	bidx += len(c.datavalues)

left,right = ax[0].get_ylim()
ax[0].set_ylim(left-left*0.8, right+right*1200)
ax[0].margins(x=0.01)
ax[0].grid(linestyle='--', linewidth=0.2) 
ax[0].grid(axis='x', linestyle='--', linewidth=2) 

ax[0].set_xticks([4,8,12,15,19,23])
ax[0].tick_params(axis="x", which="both", pad=10, direction="in", left=True, labelleft=True) 
ax[0].tick_params(axis="y", which="both", pad=10, direction="in", rotation=0, top=True) 
ax[0].set_xticklabels([])

####################################################################################################
##Overlapping Memory
####################################################################################################

ax[1].bar(idx[0:3], mem[0:3], color=colors, width=0.99, align="center", edgecolor="black", linewidth=1.2)
ax[1].bar(idx[3:6], mem[3:6], color=colors, width=0.99, align="center", edgecolor="black", linewidth=1.2)
ax[1].bar(idx[6:9], mem[6:9], color=colors, width=0.99, align="center", edgecolor="black", linewidth=1.2)
ax[1].bar(idx[9:11], mem[9:11], color=colors, width=0.99, align="center", edgecolor="black", linewidth=1.2)
ax[1].bar(idx[11:14], mem[11:14], color=colors, width=0.99, align="center", edgecolor="black", linewidth=1.2)
ax[1].bar(idx[14:17], mem[14:17], color=colors, width=0.99, align="center", edgecolor="black", linewidth=1.2)
ax[1].bar(idx[17:20], mem[17:20], color=colors, width=0.99, align="center", edgecolor="black", linewidth=1.2)
ax[1].set_yscale("log")

cidx=0
bidx=0
for c in ax[1].containers:
	ax[1].bar_label(c, labels=memX[bidx:bidx+len(c.datavalues)], fmt='%gs', color='red', size='large', rotation='vertical', fontweight='bold')
	bidx += len(c.datavalues)

left,right = ax[1].get_ylim()
ax[1].set_ylim(left-left*0.8, right+right*15)
ax[1].margins(x=0.01)
ax[1].grid(linestyle='--', linewidth=0.2) 
ax[1].grid(axis='x', linestyle='--', linewidth=2) 

ax[1].set_xticks([4,8,12,15,19,23])
ax[1].tick_params(axis="x", which="both", pad=10, direction="in", left=True, labelleft=True) 
ax[1].tick_params(axis="y", which="both", pad=10, direction="in", rotation=0, top=True) 
ax[1].set_xticklabels([])

plt.subplots_adjust(top=0.99, bottom=0.01, left=0.005, right=0.995, hspace=0.05, wspace=0.2)
fig.savefig("overlapping_perf_mem.pdf")

plt.show()