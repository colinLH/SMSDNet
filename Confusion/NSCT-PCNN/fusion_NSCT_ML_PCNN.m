function [cp,map]=fusion_NSCT_ML_PCNN(matrixA,matrixB,Para)

SF_A=ModifyLow(abs(matrixA));
SF_B=ModifyLow(abs(matrixB));

PCNN_timesA=PCNN_withParameters(SF_A,Para);
PCNN_timesB=PCNN_withParameters(SF_B,Para);
map=(PCNN_timesA>=PCNN_timesB);

cp=map.*matrixA+~map.*matrixB;