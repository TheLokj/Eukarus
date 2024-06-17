# -*- coding: utf-8 -*-
import sys, json, datetime, argparse, os

# Read arguments
parser = argparse.ArgumentParser()
parser.add_argument('-tv','--tiaraVersion', metavar='v', type=str, required=True)
parser.add_argument('-dmcv', '--DmcVersion',  metavar='v', type=str, required=True)
parser.add_argument('-lt','--logTiara', metavar='v', type=str, required=True)
parser.add_argument('-ldmc','--logDmc', metavar='v', type=str, required=True)
parser.add_argument('-lc','--logCat', metavar='v', type=str, required=True)
parser.add_argument('-cdb','--DbCat', metavar='path', type=str, required=True)
parser.add_argument('-ddb','--DbDiamond', metavar='path', type=str, required=True)
parser.add_argument('-tdb','--DbTaxonomy', metavar='path', type=str, required=True)
args = parser.parse_args()

# Parse log files
with open(args.logCat, "r") as logCat :
    log = logCat.read()
    if "No contig requiring CAT validation" not in log : 
        catVersion = log.split("\n")[0].split("v")[1][:-1]
        prodigalVersion = log.split("Prodigal V")[1].split(":")[0]
        diamondVersion = log.split("diamond version ")[1].split("\n")[0][:-1]
    else :
        catVersion = "not used"
        prodigalVersion = "not used"
        diamondVersion = "not used"

with open(args.logTiara, "r") as logTiara :
    tiaraParameters, tiaraModels, log = {}, [], logTiara.readlines()
    for line in log :
        lineText = line.replace("\n", "")
        if "\t\t" in lineText and "\t\t\t" not in lineText :
            tiaraModels.append(lineText.replace("\t\t",""))
        if "\t\t\t" in lineText and lineText.split(": ")[0].replace("\t\t\t","") not in tiaraParameters.keys():
            tiaraParameters[lineText.split(": ")[0].replace("\t\t\t","")] = lineText.split(": ")[1]

with open(args.logDmc, "r") as logDmc : 
    dmcModelPath = logDmc.readlines()[2].split("from ")[1][:-1]

# Build the metadata dictionnary
metadata = {"launched" : str(datetime.datetime.now()),
            "tools" : [ 
                        {
                            "name" : "Tiara",
                            "version" : args.tiaraVersion,
                            "model" : [
                                        { 
                                            "tiarafirststage" : tiaraModels[0],
                                            "neuralnetworkweightsfirststage" : tiaraModels[2],
                                            "parameters" : tiaraParameters
                                        }
                                    ]
                        },
                        {
                            "name" : "DeepMicroClass",
                            "version" : args.DmcVersion,
                            "model" : dmcModelPath
                        },
                        {
                            "name" : "CAT",
                            "version" : catVersion,
                            "database" : args.DbCat,
                            "dependencies" : [
                                {
                                    "tools" : [ 
                                        {
                                            "name" : "Prodigal",
                                            "version" : prodigalVersion
                                        }, 
                                        {
                                            "name" : "Diamond",
                                            "version" : diamondVersion,
                                            "database" : args.DbDiamond
                                        }
                                    ],
                                    "databases" : [
                                        {
                                            "name" : "Taxonomy",
                                            "database" : args.DbTaxonomy
                                        }
                                    ]
                                }
                            ]
                        }
            ]                 
}

with open("metadata.json", "w") as jsonFile :
    json.dump(metadata, jsonFile, indent=2)