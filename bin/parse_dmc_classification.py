import sys, os

def select_best_hit(dmcValues):
  if 0 not in dmcValues:
    maxIndex = dmcValues.index(max(dmcValues))
    labels = ["Eukaryote", "EukaryoteVirus", "Plasmid", "Prokaryote", "ProkaryoteVirus"]
    return labels[maxIndex]
  else :
    return 'Unknown'

def main():
  with open(sys.argv[1], "r") as dmcPredictions, open("output.parse_dmc_classification", "w") as output :
    lines = dmcPredictions.readlines()
    for line in lines[1:] :
      seqName = line.split("\t")[0].split(" ", 1)[0]
      dmcValues = [float(score) for score in line.split("\t")[1:6]]
      output.write(f'{seqName}\t{select_best_hit(dmcValues)}')
      if line != lines[-1] :
        output.write("\n")

if __name__ == "__main__":
    main()