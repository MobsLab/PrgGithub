M733REM10sMatVal=Data(matVal)
save('M733REM10sMatVal.mat')



cd('/media/mobsmorty/DataMOBS82/Test Figures/21032018/M675_ProtoStimSleep_1min_180321_102404')
load('M675REM10sMatVal.mat')
M675REM10sMatVal=Data(matVal)
save('M675REM10sMatVal.mat')


MatriceREM10s


MatriceREM10_20s



MatriceREM20_30s






%%%%load les matrice et les attribuées
load('matriceREM10s')
M1=matriceREM10s


load('matriceREM10_20s')
M2=MatriceREM10_20s

load('matriceREM20_30s')


 AllStim=[M1l M2]
 figure
 imagesc((AllStim)')
 imagesc(zscore(AllStim)')