

% load('/media/nas7/ProjetEmbReact/DataEmbReact/TailTemperature.mat')

Mouse=Drugs_Groups_UMaze_BM(22);
[OutPutData , Epoch1 , NameEpoch] = MeanValuesPhysiologicalParameters_BM('all_saline',Mouse,'cond','tailtemperature');

OutPutData.tailtemperature.mean(OutPutData.tailtemperature.mean==0)=NaN;
OutPutData.tailtemperature.mean(8,:) = NaN;

Cols={[1 .5 .5],[.5 .5 1]};
X=[1 2.5];
Legends={'Shock','Safe'};

figure
MakeSpreadAndBoxPlot3_SB({OutPutData.tailtemperature.mean(:,5) OutPutData.tailtemperature.mean(:,6)},Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('Tail temperature (°C)')
makepretty_BM2





