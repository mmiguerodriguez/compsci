import numpy as np
import matplotlib
import matplotlib.pyplot as plt
from sklearn.metrics import cohen_kappa_score
def heatmap(data, row_labels, col_labels, ax=None,
            cbar_kw={}, cbarlabel="", **kwargs):
    """
    Create a heatmap from a numpy array and two lists of labels.

    Parameters
    ----------
    data
        A 2D numpy array of shape (N, M).
    row_labels
        A list or array of length N with the labels for the rows.
    col_labels
        A list or array of length M with the labels for the columns.
    ax
        A `matplotlib.axes.Axes` instance to which the heatmap is plotted.  If
        not provided, use current axes or create a new one.  Optional.
    cbar_kw
        A dictionary with arguments to `matplotlib.Figure.colorbar`.  Optional.
    cbarlabel
        The label for the colorbar.  Optional.
    **kwargs
        All other arguments are forwarded to `imshow`.
    """

    if not ax:
        ax = plt.gca()

    # Plot the heatmap
    im = ax.imshow(data, **kwargs)

    # Create colorbar
    cbar = ax.figure.colorbar(im, ax=ax, **cbar_kw)
    cbar.ax.set_ylabel(cbarlabel, rotation=-90, va="bottom")

    # We want to show all ticks...
    ax.set_xticks(np.arange(data.shape[1]))
    ax.set_yticks(np.arange(data.shape[0]))
    # ... and label them with the respective list entries.
    ax.set_xticklabels(col_labels)
    ax.set_yticklabels(row_labels)

    # Let the horizontal axes labeling appear on top.
    ax.tick_params(top=True, bottom=False,
                   labeltop=True, labelbottom=False)

    # Rotate the tick labels and set their alignment.
    plt.setp(ax.get_xticklabels(), rotation=-30, ha="right",
             rotation_mode="anchor")

    # Turn spines off and create white grid.
    for edge, spine in ax.spines.items():
        spine.set_visible(False)

    ax.set_xticks(np.arange(data.shape[1]+1)-.5, minor=True)
    ax.set_yticks(np.arange(data.shape[0]+1)-.5, minor=True)
    ax.grid(which="minor", color="w", linestyle='-', linewidth=3)
    ax.tick_params(which="minor", bottom=False, left=False)

    return im, cbar

def calculateConfusionK(k, confusion):
    confusionK = np.zeros((2, 2))

    for i in range(10):
        for j in range(10):
            if i == k and j == k:
                confusionK[1, 1] = confusion[k, k]
            elif i != k and j != k:
                confusionK[0, 0] += confusion[i, j]
            elif i == k and j != k:
                confusionK[1, 0] += confusion[i, j]
            else:
                confusionK[0, 1] += confusion[i, j]

    return confusionK

def getConfusionMatrix(y_pred,y_val):
    confusion = np.zeros(shape=(10,10))
    for i in range(y_pred.shape[0]):
        confusion[int(y_pred[i])][int(y_val[i])] += 1
    return confusion

def calculateConfusions(confusion):
    confusions = []
    for i in range(len(confusion)):
        confusions.append(calculateConfusionK(i, confusion))
    
    return confusions

def calculatePrecisions(confusions):
    precisions = []
    for i in range(len(confusions)):
        precisions.append(confusions[i][1, 1] / (confusions[i][1, 1] + confusions[i][1, 0]))
        
    return precisions

def calculateRecalls(confusions):
    recalls = []
    for i in range(len(confusions)):
        recalls.append(confusions[i][1, 1] / (confusions[i][1, 1] + confusions[i][0, 1]))
        
    return recalls

def drawConfusionMatrix(y_pred,y_val):
    # Calcula la matriz de confusión
    confusion = getConfusionMatrix(y_pred,y_val)

    # Mapa de calor en base a los resultados    
    # plt.imshow(confusion, cmap='cool', interpolation='nearest')
    # plt.show()

    valores = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
    
    fig, ax = plt.subplots(figsize=(6,6))
    im = ax.imshow(confusion, cmap="Wistia")

    # We want to show all ticks...
    ax.set_xticks(np.arange(len(valores)))
    ax.set_yticks(np.arange(len(valores)))
    # ... and label them with the respective list entries
    ax.set_xticklabels(valores)
    ax.set_yticklabels(valores)
    plt.ylabel("Predicción")
    plt.xlabel("Esperado")

    # Rotate the tick labels and set their alignment.
    plt.setp(ax.get_xticklabels(), rotation_mode="anchor")

    # Loop over data dimensions and create text annotations.
    for i in range(len(valores)):
        for j in range(len(valores)):
            text = ax.text(j, i, int(confusion[i, j]),
                           ha="center", va="center", color="black")

    ax.set_title("Aciertos por número")

    corr_matrix = np.corrcoef(confusion)
    im, _ = heatmap(confusion, valores, valores, ax=ax,
                    cmap="Wistia", vmin=np.min(confusion), vmax=np.max(confusion),
                    cbarlabel="Cantidad")
    fig.tight_layout()
    plt.show()

# from sklearn.neighbors import KNeighborsClassifier
from sklearn.metrics import accuracy_score
import metnum

def calculate_F1_score(precision, recall):
    return 2 * (precision * recall)/(precision + recall)

# KNN accuracy calculator
def knn_accuracy(k, train, val):
    X_train, y_train = train
    X_val, y_val = val
    
    clf = metnum.KNNClassifier(k) #clf = KNeighborsClassifier(alpha)
    clf.fit(X_train, y_train)
    y_pred = clf.predict(X_val)
    
    confusions = calculateConfusions(getConfusionMatrix(y_pred, y_val))
    
    accuracy = accuracy_score(y_val, y_pred)
    cohen = cohen_kappa_score(y_val, y_pred)
    precision = np.mean(calculatePrecisions(confusions))
    recall = np.mean(calculateRecalls(confusions))
    
    f1 = calculate_F1_score(precision, recall)
    
    return (accuracy, precision, recall, cohen, f1)

# PCA + KNN accuracy calculator
def pca_knn_accuracy(alpha, k, train, val):
    X_train, y_train = train
    X_val, y_val = val
    pca = metnum.PCA(alpha)
    pca.fit(X_train)

    Y_train = pca.transform(X_train)
    Y_test = pca.transform(X_val)

    clf = metnum.KNNClassifier(k)
    clf.fit(Y_train, y_train)
    y_pred = clf.predict(Y_test)
    
    #print(y_pred[:20], y_val[:20])
    
    confusions = calculateConfusions(getConfusionMatrix(y_pred, y_val))
    
    accuracy = accuracy_score(y_val, y_pred)
    cohen = cohen_kappa_score(y_val, y_pred)
    precision = np.mean(calculatePrecisions(confusions))
    recall = np.mean(calculateRecalls(confusions))
    f1 = calculate_F1_score(precision, recall)
    
    return (accuracy, precision, recall, cohen, f1)