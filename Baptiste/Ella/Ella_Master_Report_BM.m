
GetEmbReactMiceFolderList_BM
Mouse = [688 739 777 849 893 1171 9184 1189 1391 1392 1394];

for mouse = 1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    Fz_Cam.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'epoch','epochname','freeze_epoch_camera');
    Acc.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'accelero');
    Acc_Fz.(Mouse_names{mouse}) = Restrict(Acc.(Mouse_names{mouse}) , Fz_Cam.(Mouse_names{mouse}));
end


figure
for mouse = 1:length(Mouse)
    subplot(3,4,mouse)
    histogram(log10(Data(Acc.(Mouse_names{mouse}))),'BinLimits',[4 9.5],'NumBins',100);
    hold on
    histogram(log10(Data(Acc_Fz.(Mouse_names{mouse}))),'BinLimits',[4 9.5],'NumBins',100);
end


for mouse = 1:length(Mouse)
    clear D
    D = log10(Data(Acc_Fz.(Mouse_names{mouse})));
    prop(mouse) = (sum(D>log10(1e8))/length(D))*100;
end


%%
[OutPutData , Epoch1 , NameEpoch] = MeanValuesPhysiologicalParameters_BM(Mouse,'cond','respi_freq_bm');

% after shock
figure
bin=50; % divide by 5 to have wanted epoch in seconds
for mouse=1:11
    clear St D ind ind_pre ind_post D_pre D_post
    St = Start(Epoch1{mouse,2});
    D = Data(OutPutData.respi_freq_bm.tsd{mouse,6});
    for s=1:length(St)
        ind = max(find(Range(OutPutData.respi_freq_bm.tsd{mouse,6})<St(s)));
        if ind<bin
            ind_pre = 1:ind; % 5s of freezing safe before eyelidshock
        else
            ind_pre = ind-bin:ind; % 5s of freezing safe before eyelidshock
        end
        ind_post = ind:ind+bin; % 5s of freezing safe after eyelidshock
        D_pre(s,1:length(D(ind_pre))) = D(ind_pre);
        D_post(s,1:length(D(ind_post))) = D(ind_post);
    end
    D_pre(D_pre==0)=NaN; D_post(D_post==0)=NaN;
    
    subplot(4,3,mouse)
    MakeSpreadAndBoxPlot3_SB({nanmedian(D_pre') nanmedian(D_post')},{[.5 1 .5],[1 .5 1]},[1 2],{'Pre','Post'},'showpoints',0,'paired',1);
    
    Mean_Bef(mouse) = nanmedian(nanmedian(D_pre'));
    Mean_Aft(mouse) = nanmedian(nanmedian(D_post'));
end

figure
MakeSpreadAndBoxPlot3_SB({Mean_Bef Mean_Aft},{[.5 1 .5],[1 .5 1]},[1 2],{'Pre','Post'},'showpoints',0,'paired',1);


load('/media/nas6/ProjetEmbReact/DataEmbReact/Create_Behav_Drugs_BM.mat', 'BlockedEpoch')

% after entries shock
figure
for mouse=1:11
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    
    clear St D ind ind_pre ind_post D_pre D_post
    St = Start(and(Epoch1{mouse,7} , (Epoch1{mouse,1}-BlockedEpoch.Cond.(Mouse_names{mouse}))));
    D = Data(OutPutData.respi_freq_bm.tsd{mouse,6});
    for s=1:length(St)
        ind = max(find(Range(OutPutData.respi_freq_bm.tsd{mouse,6})<St(s)));
        if ind<bin
            ind_pre = 1:ind; % 5s of freezing safe before eyelidshock
        else
            ind_pre = ind-bin:ind; % 5s of freezing safe before eyelidshock
        end
        if ind+bin>length(D)
            ind_post = ind:length(D); % 5s of freezing safe after eyelidshock
        else
            ind_post = ind:ind+bin; % 5s of freezing safe after eyelidshock
        end
        D_pre(s,1:length(D(ind_pre))) = D(ind_pre);
        D_post(s,1:length(D(ind_post))) = D(ind_post);
    end
    D_pre(D_pre==0)=NaN; D_post(D_post==0)=NaN;
    
    subplot(4,3,mouse)
    MakeSpreadAndBoxPlot3_SB({nanmedian(D_pre') nanmedian(D_post')},{[.5 1 .5],[1 .5 1]},[1 2],{'Pre','Post'},'showpoints',0,'paired',1);
    
    Mean_Bef(mouse) = nanmedian(nanmedian(D_pre'));
    Mean_Aft(mouse) = nanmedian(nanmedian(D_post'));
end

figure
[a,b]=MakeSpreadAndBoxPlot3_SB({Mean_Bef Mean_Aft},{[.5 1 .5],[1 .5 1]},[1 2],{'Pre','Post'},'showpoints',0,'paired',1);





