%%%%%%%%%% Freezing Only %%%%%%%%%%%%%%%%%%%%%%%%
%%All mice together
clear all
cd('/media/sophie/My Passport1/ProjectEmbReac/Figures/ForIGBoost/')
MouseNum=[436,437,438,439,469,470,471,483,484,485,490,507,508,509,510,512,514]
AllValsIn=[];AllValsOut=[];
VarToKeep=[1,5,6,13,14,15,16,17,21];
load('/media/sophie/My Passport1/ProjectEmbReac/Figures/ForIGBoost/TableToPredictBreathingFreq.mat')
a=fieldnames(AllParams{1});
for i=1:length(VarToKeep)
    disp([num2str(i-1),' ',a{VarToKeep(i)}])
end
for i=1:length(MouseNum)
    load(['Mouse',num2str(MouseNum(i)),'TableToPredictBreathingFreqOnlyFz.mat'])
    InPutData(find(isnan(OutPutData)),:)=[];
    OutPutData(find(isnan(OutPutData)))=[];
    % Make Xdistinto X+Y
    InPutData(:,6)=InPutData(:,7)+InPutData(:,6);
    InPutData(:,17)=InPutData(:,17)+InPutData(:,18);
    AllValsOut=[AllValsOut,OutPutData];
    AllValsIn=[AllValsIn,InPutData(:,VarToKeep)'];
end
OutPutData=AllValsOut;
InPutData=AllValsIn';
save('AllMiceTogetherJustFz.mat','OutPutData','InPutData')

%%All mice separate
clear all
cd('/media/sophie/My Passport1/ProjectEmbReac/Figures/ForIGBoost/')
MouseNum=[436,437,438,439,469,470,471,483,484,485,490,507,508,509,510,512,514]
AllValsIn=[];AllValsOut=[];
VarToKeep=[1,5,6,13,14,15,16,17,21];
load('/media/sophie/My Passport1/ProjectEmbReac/Figures/ForIGBoost/TableToPredictBreathingFreq.mat')
a=fieldnames(AllParams{1});
for i=1:length(VarToKeep)
    disp([num2str(i-1),' ',a{VarToKeep(i)}])
end
for i=1:length(MouseNum)
    load(['Mouse',num2str(MouseNum(i)),'TableToPredictBreathingFreqOnlyFz.mat'])
    InPutData(find(isnan(OutPutData)),:)=[];
    OutPutData(find(isnan(OutPutData)))=[];
    % Make Xdistinto X+Y
    InPutData(:,6)=InPutData(:,7)+InPutData(:,6);
    InPutData(:,17)=InPutData(:,17)+InPutData(:,18);
    eval(['M',num2str(i-1),'Out=OutPutData;']);
    eval(['M',num2str(i-1),'In=InPutData(:,VarToKeep)'';']);
end

clear VarToKeep MouseNum Znes Znestemp InPutData OutPutData i
save('AllMiceSepJustFz.mat')

%% Train and test on different mice
clear all
cd('/media/sophie/My Passport1/ProjectEmbReac/Figures/ForIGBoost/')
MouseNum=[436,437,438,439,469,470,471,483,484,485,490,507,508,509,510,512,514];
VarToKeep=[1,5,6,13,14,15,16,17,21];
for i=1:length(MouseNum)
    load(['Mouse',num2str(MouseNum(i)),'TableToPredictBreathingFreqOnlyFz.mat'])
    InPutData(find(isnan(OutPutData)),:)=[];
    OutPutData(find(isnan(OutPutData)))=[];
    % Make Xdistinto X+Y
    InPutData(:,6)=InPutData(:,7)+InPutData(:,6);
    InPutData(:,17)=InPutData(:,17)+InPutData(:,18);
    OutAll{i}=OutPutData;
    InAll{i}=InPutData(:,VarToKeep)';
end
clear InputDataTrain OutPutDataTrain InputDataTest OutPutDataTest
for i=1:length(MouseNum)
    AllM=1:length(MouseNum);
    AllM(i)=[];
    InputDataTrain=[];OutPutDataTrain=[];
    for k=1:length(AllM)
        InputDataTrain=[InputDataTrain,InAll{AllM(k)}];
        OutPutDataTrain=[OutPutDataTrain,OutAll{AllM(k)}];
    end
    InputDataTest= InAll{i};
    OutPutDataTest= OutAll{i};
    InputDataTrain=InputDataTrain';
    InputDataTest=InputDataTest';
    save(['AllMiceSepTrainandTest',num2str(i-1),'JustFz.mat'],'InputDataTrain','OutPutDataTrain','InputDataTest','OutPutDataTest')
end
load('/home/sophie/Documents/ForIGBoost/TableToPredictBreathingFreq.mat')
a=fieldnames(AllParams{1});
for i=1:length(VarToKeep)
    disp([num2str(i-1),' ',a{VarToKeep(i)}])
end


%%%%%%%%%%%% all behav %%%%%%%%%%%%
%%All mice together
clear all
cd('/media/sophie/My Passport1/ProjectEmbReac/Figures/ForIGBoost/')
MouseNum=[436,437,438,439,469,470,471,483,484,485,490,507,508,509,510,512,514]
AllValsIn=[];AllValsOut=[];
VarToKeep=[1,4,5,6,10,13,14,15,16,17];
load('/media/sophie/My Passport1/ProjectEmbReac/Figures/ForIGBoost/TableToPredictBreathingFreq.mat')
a=fieldnames(AllParams{1});
for i=1:length(VarToKeep)
    disp([num2str(i-1),' ',a{VarToKeep(i)}])
end
for i=1:length(MouseNum)
    load(['Mouse',num2str(MouseNum(i)),'TableToPredictBreathingFreq.mat'])
    InPutData(find(isnan(OutPutData)),:)=[];
    OutPutData(find(isnan(OutPutData)))=[];
    % Make Xdistinto X+Y
    InPutData(:,6)=InPutData(:,7)+InPutData(:,6);
    InPutData(:,17)=InPutData(:,17)+InPutData(:,18);
    AllValsOut=[AllValsOut,OutPutData];
    AllValsIn=[AllValsIn,InPutData(:,VarToKeep)'];
end
OutPutData=AllValsOut;
InPutData=AllValsIn';
InPutData(find(isnan(OutPutData)),:)=[];
OutPutData(find(isnan(OutPutData)))=[];
save('AllMiceTogether.mat','OutPutData','InPutData')

%%All mice separate
clear all
cd('/media/sophie/My Passport1/ProjectEmbReac/Figures/ForIGBoost/')
MouseNum=[436,437,438,439,469,470,471,483,484,485,490,507,508,509,510,512,514]
AllValsIn=[];AllValsOut=[];
VarToKeep=[1,4,5,6,10,13,14,15,16,17];
load('/media/sophie/My Passport1/ProjectEmbReac/Figures/ForIGBoost/TableToPredictBreathingFreq.mat')
a=fieldnames(AllParams{1});
for i=1:length(VarToKeep)
    disp([num2str(i-1),' ',a{VarToKeep(i)}])
end
for i=1:length(MouseNum)
    load(['Mouse',num2str(MouseNum(i)),'TableToPredictBreathingFreq.mat'])
    InPutData(find(isnan(OutPutData)),:)=[];
    OutPutData(find(isnan(OutPutData)))=[];
    % Make Xdistinto X+Y
    InPutData(:,6)=InPutData(:,7)+InPutData(:,6);
    InPutData(:,17)=InPutData(:,17)+InPutData(:,18);
    eval(['M',num2str(i-1),'Out=OutPutData;']);
    eval(['M',num2str(i-1),'In=InPutData(:,VarToKeep)'';']);
end
clear VarToKeep MouseNum Znes Znestemp InPutData OutPutData i
save('AllMiceSep.mat')


clear all
cd('/media/sophie/My Passport1/ProjectEmbReac/Figures/ForIGBoost/')
MouseNum=[436,437,438,439,469,470,471,483,484,485,490,507,508,509,510,512,514];
VarToKeep=[1,4,5,6,10,13,14,15,16,17];
for i=1:length(MouseNum)
    load(['Mouse',num2str(MouseNum(i)),'TableToPredictBreathingFreq.mat'])
    InPutData(find(isnan(OutPutData)),:)=[];
    OutPutData(find(isnan(OutPutData)))=[];
    % Make Xdistinto X+Y
    InPutData(:,6)=InPutData(:,7)+InPutData(:,6);
    InPutData(:,17)=InPutData(:,17)+InPutData(:,18);
    OutAll{i}=OutPutData;
    InAll{i}=InPutData(:,VarToKeep)';
end
clear InputDataTrain OutPutDataTrain InputDataTest OutPutDataTest
for i=1:length(MouseNum)
    AllM=1:length(MouseNum);
    AllM(i)=[];
    InputDataTrain=[];OutPutDataTrain=[];
    for k=1:length(AllM)
        InputDataTrain=[InputDataTrain,InAll{AllM(k)}];
        OutPutDataTrain=[OutPutDataTrain,OutAll{AllM(k)}];
    end
    InputDataTest= InAll{i};
    OutPutDataTest= OutAll{i};
    InputDataTrain=InputDataTrain';
    InputDataTest=InputDataTest';
    save(['AllMiceSepTrainandTest',num2str(i-1),'.mat'],'InputDataTrain','OutPutDataTrain','InputDataTest','OutPutDataTest')
end

load('/home/sophie/Documents/ForIGBoost/TableToPredictBreathingFreq.mat')
a=fieldnames(AllParams{1});
for i=1:length(VarToKeep)
    disp([num2str(i-1),' ',a{VarToKeep(i)}])
end


