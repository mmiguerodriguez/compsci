import scipy.io.wavfile
import click
import numpy as np


@click.command()
@click.option("--input_file", "-i", required=True, type=click.Path(exists=True))
@click.option("--output_file", "-o", required=True)
@click.option("--profundidad", "-p", default="16", type=click.Choice(["8", "16"]))
def numbers_to_wav(input_file, output_file, profundidad):
    profundidad = int(profundidad)
    with open(input_file, "r") as f:
        str = f.readline()
        chs, *data = [int(n) for n in str.split(" ")]

    res = []
    i = 0

    while(i < len(data)):
        sample = []
        for c in range(chs):
            sample.append(data[i])
            i += 1
        res.append(sample)
    res = np.array(res, dtype=np.int16 if profundidad == 16 else np.int8)
    scipy.io.wavfile.write(filename=output_file, rate=44100, data=res)


if __name__ == "__main__":
    numbers_to_wav()
