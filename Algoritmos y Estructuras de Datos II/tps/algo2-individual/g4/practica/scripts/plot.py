import csv
import numpy as np
import matplotlib.pyplot as plt
import math
import sys

# Usage python3 plot.py file m

dataRaw = []
filename = sys.argv[1]
file = open(filename)
next(file) # skip first line

with file as tsv:
	for line in csv.reader(tsv, dialect="excel-tab"):
		if(len(line) > 0):
			dataRaw.append([int(line[0]), int(line[1])])

data = []
n = []
m = int(sys.argv[2])

for item in dataRaw:
	n.append(item[0])
	data.append(item[1])

logScale = []
quadratic = []
nm = []
for item in n:
	logScale.append(item * math.log2(item) * m)
	quadratic.append(item * math.log2(item))


# print(logScale)

fig, ax = plt.subplots()

color = 'tab:blue'
ax.set_xlabel('N')
ax.set_ylabel('Operaciones')
ax.plot(n, data, color=color, label='Operaciones')
ax.tick_params(axis='y')

# ax2 = ax1.twinx() # Crea nuevo eje

color = '#000000'
ax.plot(n, logScale, color=color, label='M * N * log(N)', ls=":")
# color = 'gray'
# ax.plot(n, quadratic, color=color, label='N * log(N)', ls=":")

# ax3 = ax1.twinx() # Crea nuevo eje

# color = 'tab:orange'
# ax3.plot(n, quadratic, color=color)

fig.legend(loc="upper left", bbox_to_anchor=(0,1), bbox_transform=ax.transAxes)

plt.title(sys.argv[3])

fig.tight_layout() # Arregla problema y-label
plt.savefig(filename + ".png")
