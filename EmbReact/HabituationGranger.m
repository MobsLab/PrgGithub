Files=PathForExperimentsEmbReact('Habituation');

% Granger options
order=10;
[params,movingwin,suffix]=SpectrumParametersML('low'); % low or high
plo=1;
Structures{1}='PFCx_deep';
Structures{2}='Bulb_deep';
Structures{3}='dHPC_rip';
StrucPairs=combntns([1:3],2);

for pp=1:length(Files.path)
    for c=1
        try
            disp(num2str(pp))
            cd(Files.path{pp}{c})
            load('StateEpochSB.mat')
            
            for k=1:3
                try
                    temp1=load(['ChannelsToAnalyse/',Structures{k},'.mat']);
                    eval(['temp1_1=load(''LFPData/LFP',num2str(temp1.channel),'.mat'');']);
                catch
                    if k==3
                        temp1=load(['ChannelsToAnalyse/dHPC_deep.mat']);
                        eval(['temp1_1=load(''LFPData/LFP',num2str(temp1.channel),'.mat'');']);
                        
                    end
                end
                LFP{k}=temp1_1.LFP;
            end
            TotEpoch=intervalSet(0,max(Range(LFP{1})));
            disp('calculation')
            for k=1:3
                [Fx2y{k},Fy2x{k},freqBin{k}]= GrangerSB(LFP{StrucPairs(k,1)},LFP{StrucPairs(k,2)},...
                    TotEpoch,order,params,movingwin,0,{Structures{StrucPairs(k,1)},Structures{StrucPairs(k,2)}});
            end
            save('GrangerCausality.mat','Fx2y','Fy2x','freqBin')
            disp('saved')
            
            load('B_PFCx_Low_Coherence.mat')
            RememberInfo{pp}.C_BP=mean(Spectro{1});
            load('H_B_Low_Coherence.mat')
            RememberInfo{pp}.C_HB=mean(Spectro{1});
            load('H_PFCx_Low_Coherence.mat')
            RememberInfo{pp}.C_HP=mean(Spectro{1});
            
            RememberInfo{pp}.Fx2y=Fx2y;
            RememberInfo{pp}.Fy2x=Fy2x;
            RememberInfo{pp}.freqBin=freqBin;
            clear  Fx2y Fy2x freqBin
            disp('done')
        end
    end
end




figure
for k=1:3
    All{k,1}=[];
    All{k,2}=[];
    All{k,3}=[];
    All{k,4}=[];
    All{k,5}=[];
    
end
for pp=1:5
    for k=1:3
%         subplot(3,1,k)
%         plot(RememberInfo{pp}.freqBin{k},RememberInfo{pp}.Fx2y{k},'k')
%         hold on
%         plot(RememberInfo{pp}.freqBin{k},RememberInfo{pp}.Fy2x{k},'r')
%         if pp==1
%             StrucName={Structures{StrucPairs(k,1)},Structures{StrucPairs(k,2)}};
%             legend([StrucName{1},'->',StrucName{2}],[StrucName{2},'->',StrucName{1}]);
%         end
        All{k,1}=[All{k,1};RememberInfo{pp}.Fx2y{k}];
        All{k,2}=[All{k,2};RememberInfo{pp}.Fy2x{k}];
        if k==1
            All{k,3}=[All{k,3},RememberInfo{pp}.C_BP'];
            All{k,4}=[All{k,4},RememberInfo{pp}.C_HP'];
            All{k,5}=[All{k,5},RememberInfo{pp}.C_HB'];
        end
        
        
    end
end


figure
for k=1:3
    subplot(2,3,k)
    StrucName={Structures{StrucPairs(k,1)},Structures{StrucPairs(k,2)}};
    hold on
    plot(RememberInfo{pp}.freqBin{k},RememberInfo{pp}.Fx2y{k},'k')
    hold on
    plot(RememberInfo{pp}.freqBin{k},RememberInfo{pp}.Fy2x{k},'r')
    g=shadedErrorBar(RememberInfo{pp}.freqBin{k},nanmean(All{k,1}),[stdError(All{k,1});stdError(All{k,1})],'k');
    g=shadedErrorBar(RememberInfo{pp}.freqBin{k},nanmean(All{k,2}),[stdError(All{k,2});stdError(All{k,2})],'r');hold on
        StrucName={Structures{StrucPairs(k,1)},Structures{StrucPairs(k,2)}};

    legend([StrucName{1},'->',StrucName{2}],[StrucName{2},'->',StrucName{1}]);
    xlim([0 20])
    ylim([0 0.3])
    
    subplot(2,3,k+3)
    hold on
    g=shadedErrorBar(Spectro{3},nanmean(All{1,2+k}'),[stdError(All{1,2+k}');stdError(All{1,2+k}')],'k');
    ylim([0.4 0.9])
end