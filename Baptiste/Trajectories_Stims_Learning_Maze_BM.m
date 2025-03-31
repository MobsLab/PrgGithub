

clear all
GetEmbReactMiceFolderList_BM

for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    
    StimEpoch.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}) , 'epoch' , 'epochname','stimepoch');
    BlockedEpoch.Cond.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}) , 'epoch' , 'epochname','blockedepoch');
    %     FreezeEpoch.Cond.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}) , 'epoch' , 'epochname','freezeepoch');
    %     FreezeEpoch.TestPost.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(TestPostSess.(Mouse_names{mouse}) , 'epoch' , 'epochname','freezeepoch');
    Pos.Cond.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}) , 'AlignedPosition');
    Pos.TestPost.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(TestPostSess.(Mouse_names{mouse}) , 'AlignedPosition');
    TotEpoch.Cond.(Mouse_names{mouse}) = intervalSet(0,max(Range(Pos.Cond.(Mouse_names{mouse}))));
    FreeEpoch.Cond.(Mouse_names{mouse}) = TotEpoch.Cond.(Mouse_names{mouse})-BlockedEpoch.Cond.(Mouse_names{mouse});
    StimEpoch_Free.(Mouse_names{mouse}) = and(StimEpoch.(Mouse_names{mouse}) , FreeEpoch.Cond.(Mouse_names{mouse}));
    %     Pos_Fz.TestPost.(Mouse_names{mouse}) = Restrict(Pos.TestPost.(Mouse_names{mouse}) , FreezeEpoch.TestPost.(Mouse_names{mouse}));
    disp(Mouse_names{mouse})
end

n=1;
for mouse=22:length(Mouse)
    if length(Start(StimEpoch_Free.(Mouse_names{mouse})))<7
        
        subplot(3,5,n)
        
        p=Data(Pos.Cond.(Mouse_names{mouse}));
        Xtsd=tsd(Range(Pos.Cond.(Mouse_names{mouse})),p(:,1));
        Ytsd=tsd(Range(Pos.Cond.(Mouse_names{mouse})),p(:,2));
        X_stimT = Restrict(Xtsd , ts(Start(StimEpoch.(Mouse_names{mouse}))));
        Y_stimT = Restrict(Ytsd , ts(Start(StimEpoch.(Mouse_names{mouse}))));
        X_stimFree = Restrict(Xtsd , ts(Start(StimEpoch_Free.(Mouse_names{mouse}))));
        Y_stimFree = Restrict(Ytsd , ts(Start(StimEpoch_Free.(Mouse_names{mouse}))));
        
        q = Data(Pos.TestPost.(Mouse_names{mouse}));
        X.TestPost.(Mouse_names{mouse}) = q(:,1);
        Y.TestPost.(Mouse_names{mouse}) = q(:,2);
        
        plot(X.TestPost.(Mouse_names{mouse}) , Y.TestPost.(Mouse_names{mouse}) , '.-')
        hold on
        plot(Data(X_stimT) , Data(Y_stimT) , 'ko','markerfacecolor','y')
        plot(Data(X_stimFree) , Data(Y_stimFree) , 'ko','markerfacecolor','r')
        xlim([-.1 1.1]),ylim([-.1 1.1])
        line([0 1],[0 0],'Color','m'), line([0 0],[0 1],'Color','m'), line([1 1],[0 1],'Color','m'), line([0 1],[1 1],'Color','m')
        
        
        D=Data(X_stimFree);
        D2=Data(Y_stimFree);
        
        stim=1;
        
        X_Below_Stim = X.TestPost.(Mouse_names{mouse})<D(stim)+.05;
        X_Above_Stim = X.TestPost.(Mouse_names{mouse})>D(stim)-.05;
        Y_Below_Stim = Y.TestPost.(Mouse_names{mouse})<D2(stim)+.05;
        Y_Above_Stim = Y.TestPost.(Mouse_names{mouse})>D2(stim)-.05;
        
        ind_to_use = and(and(X_Below_Stim,X_Above_Stim) , and(Y_Below_Stim,Y_Above_Stim));
        
        plot(X.TestPost.(Mouse_names{mouse})(ind_to_use) , Y.TestPost.(Mouse_names{mouse})(ind_to_use) , '*g')
        
    n=n+1;
    end
end


stim=stim+1;







ind = find(Data(X_stimT)>.5);
St = Start(StimEpoch.(Mouse_names{mouse}));
St(ind)/(480e4)

X_Below_Stim = thresholdIntervals(X.TestPost.(Mouse_names{mouse}),D(stim)+.05,'Direction','Below');
X_Above_Stim = thresholdIntervals(X.TestPost.(Mouse_names{mouse}),D(stim)-.05,'Direction','Above');
Y_Below_Stim = thresholdIntervals(Y.TestPost.(Mouse_names{mouse}),D2(stim)+.05,'Direction','Below');
Y_Above_Stim = thresholdIntervals(Y.TestPost.(Mouse_names{mouse}),D2(stim)-.05,'Direction','Above');





%%


clear all
GetEmbReactMiceFolderList_BM

Mouse=[688 739 777 779 849 893 1096];
Mouse=[1170 1171 9184 1189 9205 1391 1392 1393 1394];
Mouse=[1412,1415,1416,1437,1439,1446,1447,1448];
Mouse=[1411,1413,1414,1417,1418,1438,1440,1445];


for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    
    StimEpoch.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}) , 'epoch' , 'epochname','stimepoch');
    BlockedEpoch.Cond.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}) , 'epoch' , 'epochname','blockedepoch');
    FreezeEpoch.Cond.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}) , 'epoch' , 'epochname','freezeepoch');
    FreezeEpoch.TestPost.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(TestPostSess.(Mouse_names{mouse}) , 'epoch' , 'epochname','freezeepoch');
    Pos.Cond.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}) , 'AlignedPosition');
    Pos.TestPost.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(TestPostSess.(Mouse_names{mouse}) , 'AlignedPosition');
    TotEpoch.Cond.(Mouse_names{mouse}) = intervalSet(0,max(Range(Pos.Cond.(Mouse_names{mouse}))));
    FreeEpoch.Cond.(Mouse_names{mouse}) = TotEpoch.Cond.(Mouse_names{mouse})-BlockedEpoch.Cond.(Mouse_names{mouse});
    StimEpoch_Free.(Mouse_names{mouse}) = and(StimEpoch.(Mouse_names{mouse}) , FreeEpoch.Cond.(Mouse_names{mouse}));
    Pos_Fz.TestPost.(Mouse_names{mouse}) = Restrict(Pos.TestPost.(Mouse_names{mouse}) , FreezeEpoch.TestPost.(Mouse_names{mouse}));
    
    
    p=Data(Pos.Cond.(Mouse_names{mouse}));
    Xtsd=tsd(Range(Pos.Cond.(Mouse_names{mouse})),p(:,1));
    Ytsd=tsd(Range(Pos.Cond.(Mouse_names{mouse})),p(:,2));
    X_stimT = Restrict(Xtsd , ts(Start(StimEpoch.(Mouse_names{mouse}))));
    Y_stimT = Restrict(Ytsd , ts(Start(StimEpoch.(Mouse_names{mouse}))));
    X_stimFree = Restrict(Xtsd , ts(Start(StimEpoch_Free.(Mouse_names{mouse}))));
    Y_stimFree = Restrict(Ytsd , ts(Start(StimEpoch_Free.(Mouse_names{mouse}))));
    
    q = Data(Pos.TestPost.(Mouse_names{mouse}));
    X.TestPost.(Mouse_names{mouse}) = q(:,1);
    Y.TestPost.(Mouse_names{mouse}) = q(:,2);
    
    r = Data(Pos_Fz.TestPost.(Mouse_names{mouse}));
    X_Fz.TestPost.(Mouse_names{mouse}) = r(:,1);
    Y_Fz.TestPost.(Mouse_names{mouse}) = r(:,2);
    
    
%     figure,
    subplot(2,4,mouse)
    plot(X.TestPost.(Mouse_names{mouse}) , Y.TestPost.(Mouse_names{mouse}) , '.-')
    hold on
    plot(X_Fz.TestPost.(Mouse_names{mouse}) , Y_Fz.TestPost.(Mouse_names{mouse}) , 'r.')
    plot(Data(X_stimT) , Data(Y_stimT) , 'ko','markerfacecolor','y')
    plot(Data(X_stimFree) , Data(Y_stimFree) , 'ko','markerfacecolor','r')
    xlim([-.1 1.1]),ylim([-.1 1.1])
    line([0 1],[0 0],'Color','m'), line([0 0],[0 1],'Color','m'), line([1 1],[0 1],'Color','m'), line([0 1],[1 1],'Color','m')
    
    
    D=Data(X_stimFree);
    D2=Data(Y_stimFree);
    
    stim=1;
    
    X_Below_Stim = X.TestPost.(Mouse_names{mouse})<D(stim)+.05;
    X_Above_Stim = X.TestPost.(Mouse_names{mouse})>D(stim)-.05;
    Y_Below_Stim = Y.TestPost.(Mouse_names{mouse})<D2(stim)+.05;
    Y_Above_Stim = Y.TestPost.(Mouse_names{mouse})>D2(stim)-.05;
    
    ind_to_use = and(and(X_Below_Stim,X_Above_Stim) , and(Y_Below_Stim,Y_Above_Stim));
    
    plot(X.TestPost.(Mouse_names{mouse})(ind_to_use) , Y.TestPost.(Mouse_names{mouse})(ind_to_use) , '*g')
    
    stim=stim+1;
    
end










ind = find(Data(X_stimT)>.5);
St = Start(StimEpoch.(Mouse_names{mouse}));
St(ind)/(480e4)

X_Below_Stim = thresholdIntervals(X.TestPost.(Mouse_names{mouse}),D(stim)+.05,'Direction','Below');
X_Above_Stim = thresholdIntervals(X.TestPost.(Mouse_names{mouse}),D(stim)-.05,'Direction','Above');
Y_Below_Stim = thresholdIntervals(Y.TestPost.(Mouse_names{mouse}),D2(stim)+.05,'Direction','Below');
Y_Above_Stim = thresholdIntervals(Y.TestPost.(Mouse_names{mouse}),D2(stim)-.05,'Direction','Above');







