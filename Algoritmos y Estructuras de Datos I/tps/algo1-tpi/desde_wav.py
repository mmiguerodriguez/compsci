import scipy.io.wavfile
import click


@click.command()
@click.option("--wavfile", required=True, type=click.Path(exists=True))
@click.option("--output_file", "-o", required=True)
def wav_to_numbers(wavfile, output_file):
    sample_rate, data = scipy.io.wavfile.read(wavfile)
    if sample_rate != 44100:
        raise "Solo soporta audio a 44.1 Khz"
    chs = data.shape[1]
    res = []
    for i in range(len(data)):
        res.extend(data[i, :])

    with open(output_file, "w") as o:
        o.write("{} {}".format(chs, " ".join([str(r) for r in res])))

if __name__ == "__main__":
    wav_to_numbers()
