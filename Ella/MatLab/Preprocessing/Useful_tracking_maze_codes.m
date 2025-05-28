%% Offline tracking codes

edit FastOfflineTrackingFinal_CompNewTracking
edit RetrackAndLinearizeAllSessions
edit Correct_BadBehavResources_BM.m
edit OfflineTrackingFinal_CompNewTracking

% If ZoneEpochs need to be recomputed
for t = 1:3
    Xtemp2=Range(Xtsd)*0;
    Xtemp2(ZoneIndices{t})=1;
    ZoneEpoch{t}=thresholdIntervals(tsd(Range(Xtsd),Xtemp2),0.5,'Direction','Above');

end
save('behavResources.mat','ZoneEpoch','-append')

%% Align maze across sessions and/or mice

% Code below extracted from these codes
edit Process_OF_Sessions.m
edit PreProcess_Nicotine_HC.m

load('behavResources.mat')
satisfied = 0;
if not(exist('AlignedXtsd','var'))
    while satisfied ==0
        
        X=Data(Xtsd);Y=Data(Ytsd);
       
        figure
%         imagesc(double(ref)), colormap jet, hold on
        plot(X,Y)
        title('give 3 corners : bottom left, bottom right and top left')
        [x,y] = ginput(3);
        
        close all
        
        AlignedXtsd = tsd(Range(Xtsd),(X-x(1))./(x(2)-x(1)));
        AlignedYtsd = tsd(Range(Ytsd),(Y-y(1))./(y(3)-y(1)));
        
        figure, hold on
        plot(Data(AlignedXtsd),Data(AlignedYtsd))
        hline(0,'r--'); hline(1,'r--'); vline(0,'r--'); vline(1,'r--')
        
        satisfied = input('Satisfied?');
    end
    
    save('behavResources.mat', 'AlignedXtsd', 'AlignedYtsd','-append');
end

%% Behavioral analysis

edit Nicotine_OF_Analysis.m
edit Thigmotaxis_OF_CH.m % Function used in Nicotine_OF_Analysis


