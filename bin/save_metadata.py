# -*- coding: utf-8 -*-
import sys, json, datetime

if len(sys.argv)==12 :
    # Case where CAT was launched
    metadata = {"LaunchedOn" : str(datetime.datetime.now()),
                "Tools" : {"Tiara": sys.argv[1],
                            "DeepMicroClass" : sys.argv[2],
                            "CAT" : {"CAT" : sys.argv[3],
                                "Prodigal" : sys.argv[4],
                                "DIAMOND" : sys.argv[5]}},
                "Databases" : { "CAT" : sys.argv[6],
                                "DIAMOND" :  sys.argv[7],
                                "Taxonomy" :  sys.argv[8]},
                "Models" : { "Tiara" : 
                                { "TiaraFirstStage" : sys.argv[9],
                                "NeuralNetworkWeightsFirstStage" : sys.argv[10]},
                            "DeepMicroClass" : sys.argv[11]}
    }
else :
    # Case where CAT wasn't launch
    metadata = {"LaunchedOn" : str(datetime.datetime.now()),
                "Tools" : {"Tiara": sys.argv[1],
                            "DeepMicroClass" : sys.argv[2]},
                "Models" : { "Tiara" : 
                                { "TiaraFirstStage" : sys.argv[6],
                                "NeuralNetworkWeightsFirstStage" : sys.argv[7]},
                            "DeepMicroClass" : sys.argv[8]}
    }

with open("metadata.json", "w") as jsonFile :
    json.dump(metadata, jsonFile, indent=2)