import matplotlib.pyplot as plt
import matplotlib.patches as mpatches
import matplotlib.colors as mpcolors
from matplotlib.ticker import FuncFormatter
from IPython.display import clear_output
from subprocess import call, check_output
from IPython.display import Markdown, display
import pandas as pd
def printmd(string):
    display(Markdown(string))

def getTeamsPositions(df,method):
    return df.sort_values(method,ascending=False).reset_index(drop=True)

def getPosition(df,method,team):
    cmm_rank = getTeamsPositions(df,method)
    return cmm_rank.loc[cmm_rank["Equipo"] == team].index.values[0]+1
    
def plotAllMethods(df):
    cmm_rank = df.sort_values('CMM',ascending=True)["id"]
    wp_rank = df.sort_values('WP', ascending=True)["id"]
    bp_rank = df.sort_values('BP',ascending=True)["id"]
    teams = df["Equipo"]

    positions = range(1,len(teams)+1)

    w=0.4
    cmm_pos = [t - w/2 for t in cmm_rank]
    wp_pos = [t for t in wp_rank]
    bp_pos = [t + w/2 for t in bp_rank]

    fig, ax = plt.subplots()

    plt.bar(cmm_pos,positions,label="CMM", width=w)
    plt.bar(wp_pos, positions, label="WP", width=w)
    plt.bar(bp_pos, positions, label="BP", width=w)

    plt.ylabel("Posición", fontsize=18)
    plt.xlabel("Equipos", fontsize=18)
    plt.xticks(range(1,len(teams)+1), teams, rotation=75, fontsize=12)
    plt.yticks(positions, range(len(positions),0,-1))
    fig.set_size_inches(20, 8)
    plt.legend(title="Metodo de calculo")
    plt.title("Comparación de resultados", fontsize=22)
    ax.yaxis.grid(color='dimgrey')
    plt.show()
    
def calculateRatings(scores_data_path, teams_data_path):
    cmm = check_output(["./src", "0", scores_data_path]).decode("utf-8").split("\n")
    wp = check_output(["./src", "1", scores_data_path]).decode("utf-8").split("\n")
    bp = check_output(["./src", "2", scores_data_path]).decode("utf-8").split("\n")
    res = pd.read_csv(teams_data_path, names=["id","Equipo"])
    res["CMM"] = cmm
    res["WP"] = wp
    res["BP"] = bp
    return res
