%% Get all data types for freezing shock and safe
%% SB
clear all

GetEmbReactMiceFolderList_BM
Session_type={'CondPre','CondPost','Ext'};
Fz_Type={'Fz','Fz_Shock','Fz_Safe'};
Side_ind=[3 5 6];
VarTypes = {'respi_freq_BM_sametps','heartrate_sametps','heartratevar_sametps','ob_high_sametps','ripples_density','ob_high_freq_sametps'};

for sess=1:length(Session_type) % generate all data required for analyses
    disp(Session_type{sess})
    [OutPutData.(Session_type{sess}) , Epoch.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM(Mouse,lower(Session_type{sess}),'respi_freq_BM_sametps','heartrate_sametps','heartratevar_sametps','ob_high_sametps','ripples_density','ob_high_freq_sametps');

end

%% Get mice groups
MouseGrp.SalineSB = [688,739,777,779,849,893]; % add 1096

MouseGrp.ChronicFlx = [875,876,877,1001,1002,1095];

MouseGrp.AcuteFlx = [740,750,775,778,794];

MouseGrp.Midazolam = [829,851,857,858,859,1005,1006];

MouseGrp.SalineBM_Short = [1144,1146,1147,1170,1171,1174,9184,1189,9205]; % no 1172 1200 1204 1206 1207

MouseGrp.Diazepam_Short = [11147,11184,11189,11200,11204,11205,11206,11207];

MouseGrp.SalineBM_Long = [1184 1205 1224 1225 1226 1227];

MouseGrp.Diazepam_Long = [11225 11226 11203 1199 1230 1223];

MouseGrp.Diazepam_All = [11147,11184,11189,11200,11204,11205,11206,11207 11225 11226 11203 1199 1230 1223];

MouseGrp.Sal_Dzp = [1184 1205 1224 1225 1226 1227 1144,1146,1147,1170,1171,1174,9184,1189,9205];


cd /media/nas6/ProjetEmbReact/SB_Data
save('BasicVariables_DrugMice','OutPutData','Epoch','NameEpoch','Mouse','MouseGrp','-v7.3')



%%
Sk.respi_freq_BM = cellfun(@Data,OutPutData.Ext.respi_freq_BM.tsd(find(ismember(Mouse,MouseGrp.Diazepam_All)),5),'UniformOutput',0);
Sf.respi_freq_BM = cellfun(@Data,OutPutData.Ext.respi_freq_BM.tsd(find(ismember(Mouse,MouseGrp.Diazepam_All)),6),'UniformOutput',0);
figure
subplot(211)
nhist(Sk.respi_freq_BM)
xlim([0 10])
subplot(212)
nhist(Sf.respi_freq_BM)
xlim([0 10])

%% correlation matrices

VarTypes = {'respi_freq_BM_sametps','ob_high_freq_sametps','ob_high_sametps','heartrate_sametps','heartratevar_sametps','ripples_density'};
Names = {'Resp','OBGamPow','OBGamFreq','HR','HRVar','Rip'};
AllMiceGrops = fieldnames(MouseGrp);
AllMiceGrops = AllMiceGrops([1,2,3,4,10,9]);
Side_ind=[3 5 6];
DataType = {'Fz','FzSk','FzSf'};
for d = 1:length(DataType)
    figure('Name',DataType{d})
    
    for g = 1:length(AllMiceGrops)
        subplot(2,4,g)
        CatVar = [];
        for v = 1:length(VarTypes)
            Sk = cellfun(@Data,OutPutData.Ext.(VarTypes{v}).tsd(find(ismember(Mouse,MouseGrp.(AllMiceGrops{g}))),Side_ind(d)),'UniformOutput',0);
            A = vertcat(Sk{:});
            CatVar(v,:) =A;
            
        end
        
        imagesc(corr(CatVar','rows','pairwise'))
        caxis([-0.7 0.7])
        set(gca,'XTick',1:6,'XTickLabel',Names','YTick',1:6,'YTickLabel',Names)
        axis xy
        axis square
        title(AllMiceGrops{g})
        xtickangle(45)
        ytickangle(45)
        NumVals(g) = sum(sum(isnan(CatVar))==0);
    end
    colormap(redblue)
    
end


%% correlation matrice, mouse by mouse
SessType = 'Ext';

Side_ind= 1 :8;
DataType = NameEpoch;

for d = 1:length(DataType)

    for m = 1 :length(Mouse)
        
        CatVar = [];
        for v = 1:length(VarTypes)
            Sk = cellfun(@Data,OutPutData.(SessType).(VarTypes{v}).tsd(m,Side_ind(d)),'UniformOutput',0);
            A = vertcat(Sk{:});
            CatVar(v,:) =A;
            
        end
        
        if ~isempty(CatVar)
        CorrMat(m,:,:) = corr(CatVar','rows','pairwise');
        else
           CorrMat(m,:,:) = NaN(6,6); 
        end
    end
    
        figure('Name',DataType{d})

    
    for g = 1:length(AllMiceGrops)
               subplot(2,4,g)
               CooMatOI = squeeze(nanmean(CorrMat(find(ismember(Mouse,MouseGrp.(AllMiceGrops{g}))),:,:),1));
        
        imagesc(CooMatOI)
        caxis([-0.6 0.6])
        set(gca,'XTick',1:6,'XTickLabel',Names','YTick',1:6,'YTickLabel',Names)
        axis xy
        axis square
        title(AllMiceGrops{g})
        xtickangle(45)
        ytickangle(45)
        colormap(redblue)
        
    end
end

%% Decode safe vs shock

VarTypes = {'respi_freq_BM_sametps','ob_high_freq_sametps','ob_high_sametps','heartrate_sametps','heartratevar_sametps','ripples_density'};

SessType = 'Ext';
clear Sk Sf

for m = 1 :length(Mouse)
    
    for v = 1:length(VarTypes)
        
        Sk_temp = cellfun(@Data,OutPutData.(SessType).(VarTypes{v}).tsd(m,5),'UniformOutput',0);
        Sk{m}(v,:) = vertcat(Sk_temp{:});
        
        Sf_temp = cellfun(@Data,OutPutData.(SessType).(VarTypes{v}).tsd(m,6),'UniformOutput',0);
        Sf{m}(v,:) = vertcat(Sf_temp{:});
        
        
       
    end
    
    % get rid of time bins qith missing info
%     Sk{m}(:,sum(isnan(Sk{m}))>0) = [];
%     Sf{m}(:,sum(isnan(Sf{m}))>0) = [];
    
end

clear MeanSk MeanSf

for perm = 1:50
    gtrain=1;
    Sal = find(ismember(Mouse,MouseGrp.(AllMiceGrops{gtrain})));
    Rand = randperm(length(Sal));
    Train = Sal(Rand(1:ceil(length(Sal)/2)));
    Test = Sal(Rand(ceil(length(Sal)/2))+1:end);
    
    
    AllSk = [];
    AllSf = [];
    for tr  = 1:length(Train)
        AllSk = [AllSk,Sk{Train(tr)}];
        AllSf = [AllSf,Sf{Train(tr)}];
    end
    
    for v = 1:length(VarTypes)
        Mn = (nanmean(AllSk(v,:)) + nanmean(AllSf(v,:)))/2;
        Std = (nanstd(AllSk(v,:)) + nanstd(AllSf(v,:)))/2;
        
        AllSk(v,:) = (AllSk(v,:) - Mn)/Std;
        AllSf(v,:) = (AllSf(v,:) - Mn)/Std;
    end
    
    
    W = nanmean(AllSk') - nanmean(AllSf');
    
    for g= 1:4
        
        if g==gtrain
            Test = Sal(Rand(ceil(length(Sal)/2)+1:end));
        else
            Test = find(ismember(Mouse,MouseGrp.(AllMiceGrops{g})));
        end
        
        AllSk = [];
        AllSf = [];
        for tr  = 1:length(Test)
            AllSk = [AllSk,Sk{Test(tr)}];
            AllSf = [AllSf,Sf{Test(tr)}];
        end
        
        for v = 1:length(VarTypes)
            Mn = (nanmean(AllSk(v,:)) + nanmean(AllSf(v,:)))/2;
            Std = (nanstd(AllSk(v,:)) + nanstd(AllSf(v,:)))/2;
            
            AllSk(v,:) = (AllSk(v,:) - Mn)/Std;
           AllSf(v,:) = (AllSf(v,:) - Mn)/Std;
        end
        
        
        A{1} = nanmean(AllSk .* repmat(W,size(AllSk,2),1)');
        A{2} = nanmean(AllSf .* repmat(W,size(AllSf,2),1)');
        %                 subplot(3,2,g)
        %                 nhist(A,'median')
        %                 title(AllMiceGrops{g})
        %                 xlim([-2 2])
        %                 line([0 0],ylim)
        
        %         MeanSk(perm,g) = nanmean(A{1})/nanstd(A{1});
        %         MeanSf(perm,g) = nanmean(A{2})/nanstd(A{2});;
        
        MeanSk{g}(perm) = median(A{1});
        MeanSf{g}(perm) = -median(A{2});
        
        
        
    end
    %         pause
end


for perm = 1:50
    gtrain=5;
    Sal = find(ismember(Mouse,MouseGrp.(AllMiceGrops{gtrain})));
    Rand = randperm(length(Sal));
    Train = Sal(Rand(1:ceil(length(Sal)/2)));
    Test = Sal(Rand(ceil(length(Sal)/2))+1:end);
    
    
    AllSk = [];
    AllSf = [];
    for tr  = 1:length(Train)
        AllSk = [AllSk,Sk{Train(tr)}];
        AllSf = [AllSf,Sf{Train(tr)}];
    end
    
    for v = 1:length(VarTypes)
        Mn = (nanmean(AllSk(v,:)) + nanmean(AllSf(v,:)))/2;
        Std = (nanstd(AllSk(v,:)) + nanstd(AllSf(v,:)))/2;
        
        AllSk(v,:) = (AllSk(v,:) - Mn)/Std;
        AllSf(v,:) = (AllSf(v,:) - Mn)/Std;
    end
    
    
    W = nanmean(AllSk') - nanmean(AllSf');
    
    for g= 5:6
        
        if g==gtrain
            Test = Sal(Rand(ceil(length(Sal)/2)+1:end));
        else
            Test = find(ismember(Mouse,MouseGrp.(AllMiceGrops{g})));
        end
        
        AllSk = [];
        AllSf = [];
        for tr  = 1:length(Test)
            AllSk = [AllSk,Sk{Test(tr)}];
            AllSf = [AllSf,Sf{Test(tr)}];
        end
        
        for v = 1:length(VarTypes)
            Mn = (nanmean(AllSk(v,:)) + nanmean(AllSf(v,:)))/2;
            Std = (nanstd(AllSk(v,:)) + nanstd(AllSf(v,:)))/2;
            
            AllSk(v,:) = (AllSk(v,:) - Mn)/Std;
            AllSf(v,:) = (AllSf(v,:) - Mn)/Std;
        end
        
        
        A{1} = nanmean(AllSk .* repmat(W,size(AllSk,2),1)');
        A{2} = nanmean(AllSf .* repmat(W,size(AllSf,2),1)');
        %         subplot(3,2,g)
        %         nhist(A)
        %         title(AllMiceGrops{g})
        %         xlim([-1.5 1.5])
        %
        %         MeanSk(perm,g) = nanmean(A{1})/nanstd(A{1});
        %         MeanSf(perm,g) = nanmean(A{2})/nanstd(A{2});;
        
        MeanSk{g}(perm) = median(A{1});
        MeanSf{g}(perm) = -median(A{2});
        
        
        
        
    end
end


figure
subplot(121)
MakeSpreadAndBoxPlot2_SB(MeanSk(1:4),{},[1:4],{'Sal','FlxCh','FlxAc','Mdz'},'paired',0,'showsigstar','none')
ylim([-0.2 1])
subplot(122)
MakeSpreadAndBoxPlot2_SB(MeanSf(1:4),{},[1:4],{'Sal','FlxCh','FlxAc','Mdz'},'paired',0,'showsigstar','none')
ylim([-0.2 1])


figure
subplot(121)
MakeSpreadAndBoxPlot2_SB(MeanSk(5:6),{},[1:2],{'Sal','Dzp'},'paired',0,'showsigstar','none')
ylim([-0.2 1])
subplot(122)
MakeSpreadAndBoxPlot2_SB(MeanSf(5:6),{},[1:2],{'Sal','Dzp'},'paired',0,'showsigstar','none')
ylim([-0.2 1])

