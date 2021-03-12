function [cp,map]=fusion_NSCT_PCNN(matrixA,matrixB,Para)


PCNN_timesA=PCNN_withParameters(matrixA,Para);
PCNN_timesB=PCNN_withParameters(matrixB,Para);

map=(PCNN_timesA>=PCNN_timesB);

cp=map.*matrixA+~map.*matrixB;