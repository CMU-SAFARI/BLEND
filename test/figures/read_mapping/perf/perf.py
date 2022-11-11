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
colorsStrobalign = ["#4b71bb", "#f0c041", "#aa4499", "#db8043", "#a3a3a3", "#5FA137" , "#6799ce"]
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
	toolCpu = {"minimap2": [], "LRA": [], "Winnowmap2": [], "S-conLSH": [], "Strobealign": []}
	toolMem = {"minimap2": [], "LRA": [], "Winnowmap2": [], "S-conLSH": [], "Strobealign": []}

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
print("\\newcommand\\avgrmpM{$%.1f\\times$\\xspace}\n\\newcommand\\avgrmpHM{$%.1f\\times$\\xspace}\n\\newcommand\\rmpM{$%.1f\\times$\\xspace}\n\\newcommand\\mrmpM{$%.1f\\times$\\xspace}\n" % (sum(toolCpu["minimap2"])/len(toolCpu["minimap2"]), sum(toolCpu["minimap2"][:4])/4, max(toolCpu["minimap2"]), min(toolCpu["minimap2"])))
print("\\newcommand\\avgrmmM{$%.1f\\times$\\xspace}\n\\newcommand\\avgrmmHM{$%.1f\\times$\\xspace}\n\\newcommand\\rmmM{$%.1f\\times$\\xspace}\n\\newcommand\\mrmmM{$%.1f\\times$\\xspace}\n" % (sum(toolMem["minimap2"])/len(toolMem["minimap2"]), sum(toolMem["minimap2"][:4])/4, max(toolMem["minimap2"]), min(toolMem["minimap2"])))

# LRA CPU and memory results for latex
print("\\newcommand\\avgrmpL{$%.1f\\times$\\xspace}\n\\newcommand\\avgrmpHL{$%.1f\\times$\\xspace}\n\\newcommand\\rmpL{$%.1f\\times$\\xspace}\n\\newcommand\\mrmpL{$%.1f\\times$\\xspace}\n" % (sum(toolCpu["LRA"])/(len(toolCpu["LRA"])-1), sum(toolCpu["LRA"][:4])/4, max(toolCpu["LRA"]), min(toolCpu["LRA"])))
print("\\newcommand\\avgrmmL{$%.1f\\times$\\xspace}\n\\newcommand\\avgrmmHL{$%.1f\\times$\\xspace}\n\\newcommand\\rmmL{$%.1f\\times$\\xspace}\n\\newcommand\\mrmmL{$%.1f\\times$\\xspace}\n" % (sum(toolMem["LRA"])/len(toolMem["LRA"]), sum(toolMem["LRA"][:4])/4, max(toolMem["LRA"]), min(toolMem["LRA"])))

# Winnowmap2 CPU and memory results for latex
print("\\newcommand\\avgrmpW{$%.1f\\times$\\xspace}\n\\newcommand\\avgrmpHW{$%.1f\\times$\\xspace}\n\\newcommand\\rmpW{$%.1f\\times$\\xspace}\n\\newcommand\\mrmpW{$%.1f\\times$\\xspace}\n" % (sum(toolCpu["Winnowmap2"])/len(toolCpu["Winnowmap2"]), sum(toolCpu["Winnowmap2"][:4])/4, max(toolCpu["Winnowmap2"]), min(toolCpu["Winnowmap2"])))
print("\\newcommand\\avgrmmW{$%.1f\\times$\\xspace}\n\\newcommand\\avgrmmHW{$%.1f\\times$\\xspace}\n\\newcommand\\rmmW{$%.1f\\times$\\xspace}\n\\newcommand\\mrmmW{$%.1f\\times$\\xspace}\n" % (sum(toolMem["Winnowmap2"])/len(toolMem["Winnowmap2"]), sum(toolMem["Winnowmap2"][:4])/4, max(toolMem["Winnowmap2"]), min(toolMem["Winnowmap2"])))

# S-conLSH CPU and memory results for latex
print("\\newcommand\\avgrmpS{$%.1f\\times$\\xspace}\n\\newcommand\\avgrmpHS{$%.1f\\times$\\xspace}\n\\newcommand\\rmpS{$%.1f\\times$\\xspace}\n\\newcommand\\mrmpS{$%.1f\\times$\\xspace}\n" % (sum(toolCpu["S-conLSH"])/len(toolCpu["S-conLSH"]), sum(toolCpu["S-conLSH"][:2])/2, max(toolCpu["S-conLSH"]), min(toolCpu["S-conLSH"])))
print("\\newcommand\\avgrmmS{$%.1f\\times$\\xspace}\n\\newcommand\\avgrmmHS{$%.1f\\times$\\xspace}\n\\newcommand\\rmmS{$%.1f\\times$\\xspace}\n\\newcommand\\mrmmS{$%.1f\\times$\\xspace}\n" % (sum(toolMem["S-conLSH"])/len(toolMem["S-conLSH"]), sum(toolMem["S-conLSH"][:2])/2, max(toolMem["S-conLSH"]), min(toolMem["S-conLSH"])))

# Strobealign CPU and memory results for latex
print("\\newcommand\\avgrmpSt{$%.1f\\times$\\xspace}\n\\newcommand\\rmpSt{$%.1f\\times$\\xspace}\n\\newcommand\\mrmpSt{$%.1f\\times$\\xspace}\n" % (sum(toolCpu["Strobealign"])/len(toolCpu["Strobealign"]), max(toolCpu["Strobealign"]), min(toolCpu["Strobealign"])))
print("\\newcommand\\avgrmmSt{$%.1f\\times$\\xspace}\n\\newcommand\\rmmSt{$%.1f\\times$\\xspace}\n\\newcommand\\mrmmSt{$%.1f\\times$\\xspace}\n" % (sum(toolMem["Strobealign"])/len(toolMem["Strobealign"]), max(toolMem["Strobealign"]), min(toolMem["Strobealign"])))

fig, ax = plt.subplots(2, 1, figsize=(13,5))

####################################################################################################
##Read Mapping CPU
####################################################################################################

ax[0].bar(idx[0:5], cpu[0:5], color=colors, width=0.99, align="center", edgecolor="black", linewidth=1.2)
ax[0].bar(idx[5:9], cpu[5:9], color=colors, width=0.99, align="center", edgecolor="black", linewidth=1.2)
ax[0].bar(idx[9:13], cpu[9:13], color=colors, width=0.99, align="center", edgecolor="black", linewidth=1.2)
ax[0].bar(idx[13:18], cpu[13:18], color=colors, width=0.99, align="center", edgecolor="black", linewidth=1.2)
ax[0].bar(idx[18:23], cpu[18:23], color=colors, width=0.99, align="center", edgecolor="black", linewidth=1.2)
ax[0].bar(idx[23:28], cpu[23:28], color=colors, width=0.99, align="center", edgecolor="black", linewidth=1.2)
ax[0].bar(idx[28:33], cpu[28:33], color=colors, width=0.99, align="center", edgecolor="black", linewidth=1.2)
ax[0].bar(idx[33:36], cpu[33:36], color=colorsStrobalign, width=0.99, align="center", edgecolor="black", linewidth=1.2)
ax[0].bar(idx[36:41], cpu[36:41], color=colors, width=0.99, align="center", edgecolor="black", linewidth=1.2)
ax[0].set_yscale("log")

cidx=0
bidx=0
for c in ax[0].containers:
	ax[0].bar_label(c, labels=cpuX[bidx:bidx+len(c.datavalues)], fmt='%gs', color='red', size='large', rotation='vertical', fontweight='bold')
	bidx += len(c.datavalues)

left,right = ax[0].get_ylim()
ax[0].set_ylim(left-left*0.8, right+right*30)
ax[0].margins(x=0.01)
ax[0].grid(linestyle='--', linewidth=0.4) 
ax[0].grid(axis='x', linestyle='--', linewidth=2) 

ax[0].set_xticks([6,11,16,22,28,34,40,44])
ax[0].tick_params(axis="x", which="both", pad=10, direction="in", left=True, labelleft=True) 
ax[0].tick_params(axis="y", which="both", pad=10, direction="in", rotation=0, top=True) 
ax[0].set_xticklabels([])

####################################################################################################
##Read Mapping Memory
####################################################################################################

ax[1].bar(idx[0:5], mem[0:5], color=colors, width=0.99, align="center", edgecolor="black", linewidth=1.2)
ax[1].bar(idx[5:9], mem[5:9], color=colors, width=0.99, align="center", edgecolor="black", linewidth=1.2)
ax[1].bar(idx[9:13], mem[9:13], color=colors, width=0.99, align="center", edgecolor="black", linewidth=1.2)
ax[1].bar(idx[13:18], mem[13:18], color=colors, width=0.99, align="center", edgecolor="black", linewidth=1.2)
ax[1].bar(idx[18:23], mem[18:23], color=colors, width=0.99, align="center", edgecolor="black", linewidth=1.2)
ax[1].bar(idx[23:28], mem[23:28], color=colors, width=0.99, align="center", edgecolor="black", linewidth=1.2)
ax[1].bar(idx[28:33], mem[28:33], color=colors, width=0.99, align="center", edgecolor="black", linewidth=1.2)
ax[1].bar(idx[33:36], mem[33:36], color=colorsStrobalign, width=0.99, align="center", edgecolor="black", linewidth=1.2)
ax[1].bar(idx[36:41], mem[36:41], color=colors, width=0.99, align="center", edgecolor="black", linewidth=1.2)
ax[1].set_yscale("log")

cidx=0
bidx=0
for c in ax[1].containers:
	ax[1].bar_label(c, labels=memX[bidx:bidx+len(c.datavalues)], fmt='%gs', color='red', size='large', rotation='vertical', fontweight='bold')
	bidx += len(c.datavalues)

left,right = ax[1].get_ylim()
ax[1].set_ylim(left-left*0.8, right+right*3)
ax[1].margins(x=0.01)
ax[1].grid(linestyle='--', linewidth=0.4) 
ax[1].grid(axis='x', linestyle='--', linewidth=2) 

ax[1].set_xticks([6,11,16,22,28,34,40,44])
ax[1].tick_params(axis="x", which="both", pad=10, direction="in", left=True, labelleft=True) 
ax[1].tick_params(axis="y", which="both", pad=10, direction="in", rotation=0, top=True) 
ax[1].set_xticklabels([])

plt.subplots_adjust(top=0.99, bottom=0.01, left=0.005, right=0.995, hspace=0.05, wspace=0.2)
fig.savefig("read_mapping_perf_mem.pdf")

# plt.show()