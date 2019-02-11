NUM_DIV = [5, 7, 9, 11, 13, 15]
EPSILON_DECAY = [0.9, 0.93, 0.95, 0.97, 0.99, 0.995]
ALFA = [0.05, 0.1, 0.12, 0.14, 0.16, 0.18, 0.20]
GANMA = [0.9, 0.95, 0.97]
BETA_DIST = [0.01, 0.02, 0.05, 0.1, 0.2]
BETA_GAP = [0.01, 0.02, 0.05, 0.1, 0.2]
BETA_ZONE = [0.01, 0.02, 0.05, 0.1, 0.2]
BAND_WIDTH = [0.005, 0.01, 0.02, 0.04]
ZONE_LIMIT = [0.08, 0.1, 0.16, 0.2]


for div in range(len(NUM_DIV)):
    for eps in range(len(EPSILON_DECAY)):
        for alf in range(len(ALFA)):
            for gan in range(len(GANMA)):
                for bdis in range(len(BETA_DIST)):
                    for bgap in range(len(BETA_GAP)):
                        for bzon in range(len(BETA_ZONE)):
                            for bw in range(len(BAND_WIDTH)):
                                for zl in range(len(ZONE_LIMIT)):
                                    ZONE0_LIMIT = ZONE_LIMIT[zl]/4
                                    ZONE1_LIMIT = ZONE_LIMIT[zl]/2
                                    ZONE2_LIMIT = ZONE_LIMIT[zl]





