
%% binary first
Cols={[1 .5 .5],[.5 .5 1]};
X=[1:2];
Legends={'Shock','Safe'};

load('/media/nas7/ProjetEmbReact/DataEmbReact/ThesisData/Physio_BehavGroup.mat','ShockZone_Occupancy','SafeZone_Occupancy')
load('/media/nas7/ProjetEmbReact/DataEmbReact/TemporalEvolution_Data.mat','Freq_Max_Shock','Freq_Max_Safe')

figure
subplot(121)
MakeSpreadAndBoxPlot3_SB({ShockZone_Occupancy.Cond{1} SafeZone_Occupancy.Cond{1}},Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('proportion of time')
makepretty_BM

subplot(122)
MakeSpreadAndBoxPlot3_SB({Freq_Max_Shock Freq_Max_Safe},Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('Breathing (Hz)')
makepretty_BM



%% As a function of threat imminence
load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/BehaviourAlongMaze.mat') 
% or after BehaviourAlongUMaze_BM.m

smootime = .1;
bin_size = 20;

figure
x =linspace(0,1,bin_size);
for i=1:4
    if i==1
        DATA = EpochLinDist_Jumps_prop2.Cond;
        txt = 'Jumps (prop)';
        val = .035;
    elseif i==2
        DATA = EpochLinDist_RA_prop2.Cond;
        txt = 'RA (prop)';
        val = .1;
    elseif i==3
        DATA = EpochLinDist_Grooming_Unblocked_prop2.Cond  ;
        txt = 'Grooming (prop)';
        val = .3;
    else
        DATA = EpochLinDist_Fz_prop2.Cond;
        txt = 'Freezing (prop)';
        val = .2;
    end
    
    subplot(4,1,i)
    area([-.1 .29] , [.8 .8] ,'FaceColor',[1 .5 .5],'FaceAlpha',.3)
    hold on
    area([.29 .447] , [.8 .8] ,'FaceColor',[1 .5 .5],'FaceAlpha',.2)
    area([.447 .552] , [.8 .8] ,'FaceColor',[1 .5 1],'FaceAlpha',.2)
    area([.552 .71] , [.8 .8] ,'FaceColor',[.5 .5 1],'FaceAlpha',.2)
    area([.71 1.1] , [.8 .8] ,'FaceColor',[.5 .5 1],'FaceAlpha',.3)
    
    errhigh = nanstd(DATA)/sqrt(size(DATA,1));
    errlow  = zeros(1,bin_size);
    
    b=bar(x,nanmean(DATA));
    b.FaceColor=[.3 .3 .3];
    
    box off
    
    er = errorbar(x,nanmean(DATA),errlow,errhigh);
    er.Color = [0 0 0];
    er.LineStyle = 'none';
    ylabel(txt)
    xlim([-.05 1.05]), ylim([0 val])
    if i==4
        xlabel('linear distance (a.u.)')
    end
end


%% SVM
load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/SVM_Sal_2sBin_CondPost.mat')
load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_Physio_Freezing_Saline_all_CondPost_2sFullBins.mat')
load('/media/nas7/ProjetEmbReact/DataEmbReact/ThesisData/SVM_score.mat')
 
ParToKeep = {[1:8],[2:8],[1,4:8],[1,2,3,6:8],[1:5,7,8],[1:6],[1,4,5,7:8]};
ParNames = {'All','NoResp','NoHeart','NoOB','NoRip','NoHpc','NoRipNoHeart'};
kernels = {'linear','rbf'};
PosLimStep = 0.5;
PosLims = [0.3 0.7];
DoZscore = 0;
SaveLoc = '/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/';
sess=1;
SessionTypes = {'CondPost'};
SessType = SessionTypes{sess};

AllMice = fieldnames(DATA.(SessType));
MergedData = [];
MouseId = [];
Pos = [];
for mm = 1:length(AllMice)
    MergedData = cat(2,MergedData,DATA.(SessType).(AllMice{mm})(1:8,:));
    MouseId = cat(2,MouseId,ones(1,size(DATA.(SessType).(AllMice{mm}),2))*mm);
    Pos_mice{mm} = cat(2,Pos,DATA.(SessType).(AllMice{mm})(9,:));
end
GoodMice = unique(MouseId);

for parToUse = 1%:length(ParNames)
    for svm_type    = 1%1:length(kernels)
        
        %% Contols train and test
        % Only keep subset of parameters
        DATA2 = MergedData(ParToKeep{parToUse},:);
        
        
        %% LOO iteration
        for mm = 1:length(GoodMice)
            
            
            % Define train and test sets
            train_X = DATA2(:,find(MouseId~=GoodMice(mm)));
            test_X = DATA2(:,find(MouseId==GoodMice(mm)));
            train_Y = Pos_mice{mm}(find(MouseId~=GoodMice(mm)));
            test_Y = Pos_mice{mm}(find(MouseId==GoodMice(mm)));
            test_Pos =  Pos_mice{mm}(find(MouseId==GoodMice(mm)));
            
            % Only keep interpretable positions for training
            Bad = (train_Y<PosLims(2) & train_Y>PosLims(1));
            train_X(:,Bad) = [];
            train_Y(Bad) = [];
            
            % Binarize in the middle of the maze
            train_Y = train_Y'>PosLimStep; % 0 for safe, 1 for shock
            test_Y = test_Y'>PosLimStep; % 0 for safe, 1 for shock
            
            
            % Keep only mice with full set of value
            train_Y(sum(isnan(train_X))>0) = [];
            test_Y(sum(isnan(test_X))>0) = [];
            
            train_X(:,sum(isnan(train_X))>0) = [];
            test_X(:,sum(isnan(test_X))>0) = [];
            size(test_X)
            
            
            if ~isempty(test_X)
                
                % balance the data
                numclass = min([sum(train_Y==0),sum(train_Y==1)]);
                SkId = find(train_Y==1);
                SkId = SkId(randperm(length(SkId),numclass));
                SfId = find(train_Y==0);
                SfId = SfId(randperm(length(SfId),numclass));
                train_Y = train_Y([SkId;SfId]);
                train_X = train_X(:,[SkId;SfId]);
                
                
                classifier_controltrain = fitcsvm(train_X',train_Y,...
                    'ClassNames',[0,1],'KernelFunction',kernels{svm_type});
                [prediction,scores2_test{mm}] = predict(classifier_controltrain,test_X');
            end
        end
    end
end


for mm=1:51
    for i=1:10
        try
            ind = and(Pos_mice{mm}>(i-1)/10 , Pos_mice{mm}<i/10);
            Mean_SVM_binned(mm,i) = nanmean(scores2_test{mm}(ind,1));
            Mean_SVM_binned2(mm,i) = nanmean(scores2_test{mm}(ind,1))*(sum(ind)/length(Pos_mice{mm}));
        end
    end
end
Mean_SVM_binned(Mean_SVM_binned==0) = NaN;
x = linspace(0,1,10);


Mean_SVM_binned(11,:)=NaN;

figure

area([-.1 .29] , [7 7] ,'FaceColor',[1 .5 .5],'FaceAlpha',.3)
hold on
area([.29 .447] , [7 7] ,'FaceColor',[1 .5 .5],'FaceAlpha',.2)
area([.447 .552] , [7 7] ,'FaceColor',[1 .5 1],'FaceAlpha',.2)
area([.552 .71] , [7 7] ,'FaceColor',[.5 .5 1],'FaceAlpha',.2)
area([.71 1.1] , [7 7] ,'FaceColor',[.5 .5 1],'FaceAlpha',.3)

area([-.1 .29] , [-7 -7] ,'FaceColor',[1 .5 .5],'FaceAlpha',.3)
area([.29 .447] , [-7 -7] ,'FaceColor',[1 .5 .5],'FaceAlpha',.2)
area([.447 .552] , [-7 -7] ,'FaceColor',[1 .5 1],'FaceAlpha',.2)
area([.552 .71] , [-7 -7] ,'FaceColor',[.5 .5 1],'FaceAlpha',.2)
area([.71 1.1] , [-7 -7] ,'FaceColor',[.5 .5 1],'FaceAlpha',.3)

b=bar(x , nanmean(Mean_SVM_binned) , 'FaceColor', [.3 .3 .3]); hold on
xlabel('linear distance (a.u.)')
box off
errhigh = nanstd(Mean_SVM_binned)/sqrt(size(Mean_SVM_binned,1));
errlow  = zeros(1,10);
N = nanmean(Mean_SVM_binned);
er1 = errorbar(x([1:6]),N([1:6]),errlow([1:6]),errhigh([1:6]));
er2 = errorbar(x([7:10]),N([7:10]),-errhigh([7:10]),errlow([7:10]));
er1.Color = [0 0 0]; er2.Color = [0 0 0];
er1.LineStyle = 'none'; er2.LineStyle = 'none';
xlim([-.1 1.1]), ylim([-1.5 1.5])
ylabel('brain-body score')



figure
b=bar([.1:.1:1] , nanmean(Mean_SVM_binned2) , 'FaceColor', [.3 .3 .3]); hold on
xlabel('linear distance (a.u.)')
box off
errhigh = nanstd(Mean_SVM_binned2)/sqrt(size(Mean_SVM_binned2,1));
errlow  = zeros(1,10);
N = nanmean(Mean_SVM_binned2);
er1 = errorbar(x([1:6 8]),N([1 2 3 5 6]),errlow([1 2 3 5 6]),errhigh([1 2 3 5 6]));
er2 = errorbar(x([4 7:10]),N([4 7:10]),-errhigh([4 7:10]),errlow([4 7:10]));
er1.Color = [0 0 0]; er2.Color = [0 0 0];
er1.LineStyle = 'none'; er2.LineStyle = 'none';
    


%% other physio
load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_Physio_Freezing_Saline_all_Cond_2sFullBins.mat')

sess=1;
for mouse=1:51
    for i=1:10
        try
            Pos_binned.(Session_type{sess}){i} = and(thresholdIntervals(OutPutData.(Session_type{sess}).linearposition.tsd{mouse,1},(i-1)/10,'Direction','Above') ,...
                thresholdIntervals(OutPutData.(Session_type{sess}).linearposition.tsd{mouse,1},i/10,'Direction','Below'));
            
            Mean_Breathing_binned(mouse,i) = nanmean(Data(Restrict(OutPutData.Cond.respi_freq_bm.tsd{mouse,3} , Pos_binned.(Session_type{sess}){i})));
            Mean_Rip_binned(mouse,i) = nanmean(Data(Restrict(OutPutData.Cond.ripples_density.tsd{mouse,3} , Pos_binned.(Session_type{sess}){i})));
            Mean_Rip_numb_binned(mouse,i) = nanmean(Data(Restrict(OutPutData.Cond.ripples_density.tsd{mouse,3} , Pos_binned.(Session_type{sess}){i}))).*(sum(DurationEpoch(Pos_binned.(Session_type{sess}){i}))/1e4);
        end
    end
    disp(mouse)
end

Mean_Breathing_binned(Mean_Breathing_binned==0) = NaN;
Mean_Rip_binned(Mean_Rip_binned==0) = NaN;
x = linspace(0,1,10);

figure
area([-.1 .29] , [7 7] ,'FaceColor',[1 .5 .5],'FaceAlpha',.3)
hold on
area([.29 .447] , [7 7] ,'FaceColor',[1 .5 .5],'FaceAlpha',.2)
area([.447 .552] , [7 7] ,'FaceColor',[1 .5 1],'FaceAlpha',.2)
area([.552 .71] , [7 7] ,'FaceColor',[.5 .5 1],'FaceAlpha',.2)
area([.71 1.1] , [7 7] ,'FaceColor',[.5 .5 1],'FaceAlpha',.3)

x = linspace(0,1,10);
b=bar(x , nanmean(Mean_Breathing_binned) , 'FaceColor', [.3 .3 .3]); hold on
xlabel('linear distance (a.u.)'), ylabel('Breathing (Hz)'), xlim([-.1 1.1]), ylim([3 5.5])
box off
errhigh = nanstd(Mean_Breathing_binned)/sqrt(size(Mean_Breathing_binned,1));
errlow  = zeros(1,10);
N = nanmean(Mean_Breathing_binned);
er = errorbar(x,N,errlow,errhigh);
er.Color = [0 0 0];
er.LineStyle = 'none';



figure
area([-.1 .29] , [13 13] ,'FaceColor',[1 .5 .5],'FaceAlpha',.3)
hold on
area([.29 .447] , [13 13] ,'FaceColor',[1 .5 .5],'FaceAlpha',.2)
area([.447 .552] , [13 13] ,'FaceColor',[1 .5 1],'FaceAlpha',.2)
area([.552 .71] , [13 13] ,'FaceColor',[.5 .5 1],'FaceAlpha',.2)
area([.71 1.1] , [13 13] ,'FaceColor',[.5 .5 1],'FaceAlpha',.3)

x = linspace(0,1,10);
b=bar(x , nanmean(Mean_Rip_binned) , 'FaceColor', [.3 .3 .3]); hold on
xlabel('linear distance (a.u.)'), ylabel('rip occurence (#/s)'), xlim([-.1 1.1]), ylim([0 .6])
box off
errhigh = nanstd(Mean_Rip_binned)/sqrt(size(Mean_Rip_binned,1));
errlow  = zeros(1,10);
N = nanmean(Mean_Rip_binned);
er = errorbar(x,N,errlow,errhigh);
er.Color = [0 0 0];
er.LineStyle = 'none';


figure
area([-.1 .29] , [550 550] ,'FaceColor',[1 .5 .5],'FaceAlpha',.3)
hold on
area([.29 .447] , [550 550] ,'FaceColor',[1 .5 .5],'FaceAlpha',.2)
area([.447 .552] , [550 550] ,'FaceColor',[1 .5 1],'FaceAlpha',.2)
area([.552 .71] , [550 550] ,'FaceColor',[.5 .5 1],'FaceAlpha',.2)
area([.71 1.1] , [550 550] ,'FaceColor',[.5 .5 1],'FaceAlpha',.3)

x = linspace(0,1,10);
b=bar(x , nanmean(Mean_Rip_numb_binned) , 'FaceColor', [.3 .3 .3]); hold on
xlabel('linear distance (a.u.)'), ylabel('SWR (#)'), xlim([-.1 1.1]), ylim([0 500])
box off
errhigh = nanstd(Mean_Rip_numb_binned)/sqrt(size(Mean_Rip_numb_binned,1));
errlow  = zeros(1,10);
N = nanmean(Mean_Rip_numb_binned);
er = errorbar(x,N,errlow,errhigh);
er.Color = [0 0 0];
er.LineStyle = 'none';




%% Thigmotaxis
load('/media/nas7/ProjetEmbReact/DataEmbReact/ThesisData/Physio_BehavGroup.mat')
load('/media/nas7/ProjetEmbReact/DataEmbReact/ThesisData/Behav_BehavGroup.mat', 'Speed', 'Position_Active_Unblocked')



% thigmo binned
for sess=1
    for mouse=1:length(Mouse)
    NewSpeed=tsd(Range(Speed.(Session_type{sess}).(Mouse_names{mouse})),runmean(Data(Speed.(Session_type{sess}).(Mouse_names{mouse})),10));
    Moving=thresholdIntervals(NewSpeed,1,'Direction','Above');
    Moving=mergeCloseIntervals(Moving,0.3*1e4);
    Moving=dropShortIntervals(Moving,0.3*1e4);
    Pos_Moving.(Session_type{sess}) = Restrict(Position_Active_Unblocked.(Session_type{sess}).(Mouse_names{mouse}) , Moving);
    for i=1:10
        Moving_binned.(Session_type{sess}){i} = and(thresholdIntervals(OutPutData.(Session_type{sess}).linearposition.tsd{mouse,1},(i-1)/10,'Direction','Above') ,...
            thresholdIntervals(OutPutData.(Session_type{sess}).linearposition.tsd{mouse,1},i/10,'Direction','Below'));
        Pos_Moving_binned.(Session_type{sess}){i} = Restrict(Pos_Moving.(Session_type{sess}) , Moving_binned.(Session_type{sess}){i});
        
        Thigmo_bin(mouse,i) = Thigmo_From_Position_BM(Pos_Moving_binned.(Session_type{sess}){i});
    end
    disp(mouse)
    end
end
Thigmo_bin(4,1) = NaN;
x = linspace(0,1,10);

figure
area([-.1 .29] , [13 13] ,'FaceColor',[1 .5 .5],'FaceAlpha',.3)
hold on
area([.29 .447] , [13 13] ,'FaceColor',[1 .5 .5],'FaceAlpha',.2)
area([.447 .552] , [13 13] ,'FaceColor',[1 .5 1],'FaceAlpha',.2)
area([.552 .71] , [13 13] ,'FaceColor',[.5 .5 1],'FaceAlpha',.2)
area([.71 1.1] , [13 13] ,'FaceColor',[.5 .5 1],'FaceAlpha',.3)

b=bar(x , nanmedian(Thigmo_bin) , 'FaceColor', [.3 .3 .3]); hold on
xlabel('linear distance (a.u.)')
box off
errhigh = nanstd(Thigmo_bin)/sqrt(size(Thigmo_bin,1));
errlow  = zeros(1,10);
N = nanmean(Thigmo_bin);
er = errorbar(x,N,errlow,errhigh);
er.Color = [0 0 0]; 
er.LineStyle = 'none'; 
ylabel('Thigmotaxis (cm/s)'), ylim([.3 .8]), xlim([-.1 1.1])



% Speed binned
sess=1;
for mouse=1:length(Mouse)
    NewSpeed=tsd(Range(Speed.(Session_type{sess}).(Mouse_names{mouse})),runmean(Data(Speed.(Session_type{sess}).(Mouse_names{mouse})),10));
    Moving=thresholdIntervals(NewSpeed,1,'Direction','Above');
    Moving=mergeCloseIntervals(Moving,0.3*1e4);
    Moving=dropShortIntervals(Moving,0.3*1e4);
    for i=1:10
        Lin_binned.(Session_type{sess}){i} = and(thresholdIntervals(OutPutData.(Session_type{sess}).linearposition.tsd{mouse,1},(i-1)/10,'Direction','Above') ,...
            thresholdIntervals(OutPutData.(Session_type{sess}).linearposition.tsd{mouse,1},i/10,'Direction','Below'));
        Moving = thresholdIntervals(Speed.(Session_type{sess}).(Mouse_names{mouse}) , 1 ,'Direction','Above');
        Moving_binned.(Session_type{sess}){i} = and(Moving , Lin_binned.(Session_type{sess}){i});
        NewSpeed_binned.(Session_type{sess}){i} = Restrict(NewSpeed , Moving_binned.(Session_type{sess}){i});
        
        NewSpeed_bin(mouse,i) = nanmean(Data(NewSpeed_binned.(Session_type{sess}){i}));
    end
    disp(mouse)
end
NewSpeed_bin(10,9:10) = NaN;


figure
area([-.1 .29] , [13 13] ,'FaceColor',[1 .5 .5],'FaceAlpha',.3)
hold on
area([.29 .447] , [13 13] ,'FaceColor',[1 .5 .5],'FaceAlpha',.2)
area([.447 .552] , [13 13] ,'FaceColor',[1 .5 1],'FaceAlpha',.2)
area([.552 .71] , [13 13] ,'FaceColor',[.5 .5 1],'FaceAlpha',.2)
area([.71 1.1] , [13 13] ,'FaceColor',[.5 .5 1],'FaceAlpha',.3)

b=bar(x , nanmean(NewSpeed_bin) , 'FaceColor', [.3 .3 .3]); hold on
xlabel('linear distance (a.u.)')
box off
errhigh = nanstd(NewSpeed_bin)/sqrt(size(NewSpeed_bin,1));
errlow  = zeros(1,10);
N = nanmean(NewSpeed_bin);
er = errorbar(x,N,errlow,errhigh);
er.Color = [0 0 0]; 
er.LineStyle = 'none'; 
ylabel('Speed (cm/s)'), ylim([3 7.5]), xlim([-.1 1.1])



% hot map speed
sizeMap=100; sess=3;
for mouse=1:length(Mouse_names)
    NewSpeed=tsd(Range(Speed.(Session_type{sess}).(Mouse_names{mouse})),runmean(Data(Speed.(Session_type{sess}).(Mouse_names{mouse})),10));
    Moving=thresholdIntervals(NewSpeed,1,'Direction','Above');
    Moving=mergeCloseIntervals(Moving,0.3*1e4);
    Moving=dropShortIntervals(Moving,0.3*1e4);
    NewSpeed_Moving = Restrict(NewSpeed , Moving);
    Pos_Moving = Restrict(Position_Active_Unblocked.(Session_type{sess}).(Mouse_names{mouse}) , Moving);
    clear D, D = Data(Pos_Moving);
    
    [OccupMap(mouse,:,:) , SpeedMap(mouse,:,:)] = hist3d_BM([D(:,1) ;0; 0; 1; 1] , [D(:,2);0;1;0;1] , [Data(NewSpeed_Moving);0;1;0;1] , sizeMap , sizeMap);
    
    disp(mouse)
end


figure
imagesc(movmean(movmean(squeeze(nanmean(SpeedMap))',5,'omitnan')',5,'omitnan')')
axis xy, axis off, hold on, axis square, caxis([4 8]), c=caxis;
sizeMap=100; Maze_Frame_BM
u=colorbar; u.Ticks=[c(1) c(2)]; u.FontSize=15;
u.Label.String = 'speed (cm/s)'; u.Label.FontSize=12; set(u.Label,'Rotation',270)
colormap hot

a=area([40 62],[74 74]); 
a.FaceColor=[1 1 1];
a.LineWidth=1e-6;




% hot map respi
sizeMap=100; sess=3;
for mouse=1:length(Mouse_names)
    clear D, D = Data(Restrict(Restrict(Position.Cond.(Mouse_names{mouse}) , Epoch1.Cond{mouse,3}) , OutPutData.Cond.respi_freq_bm.tsd{mouse,3}));
    
    [OccupMap(mouse,:,:) , BreathingMap(mouse,:,:)] = hist3d_BM([D(:,1) ;0; 0; 1; 1] , [D(:,2);0;1;0;1] , [Data(OutPutData.Cond.respi_freq_bm.tsd{mouse,3});0;1;0;1] , sizeMap , sizeMap);
    
    disp(mouse)
end
BreathingMap(BreathingMap==0) = NaN;

figure
imagesc(movmean(movmean(squeeze(nanmean(BreathingMap))',10,'omitnan')',10,'omitnan')')
axis xy, axis off, hold on, axis square, caxis([3.5 6]), c=caxis;
sizeMap=100; Maze_Frame_BM
u=colorbar; u.Ticks=[c(1) c(2)]; u.FontSize=15;
u.Label.String = 'Bretahing (Hz)'; u.Label.FontSize=12; set(u.Label,'Rotation',270)
colormap hot

a=area([40 62],[74 74]); 
a.FaceColor=[1 1 1];
a.LineWidth=1e-6;

% C = [linspace(.5,1,100) ; linspace(.5,.5,100) ; linspace(1,.5,100)]';
% colormap(C)














%% maps evolving with time
load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_Physio_Freezing_Saline_all_Fear_2sFullBins.mat')
load('/media/nas7/ProjetEmbReact/DataEmbReact/Trajectories_AllSaline_Fear.mat', 'Position_tsd','Position_tsd_Freeze')


ParToKeep = {[1:8],[2:8],[1,4:8],[1,2,3,6:8],[1:5,7,8],[1:6],[1,4,5,7:8]};
ParNames = {'All','NoResp','NoHeart','NoOB','NoRip','NoHpc','NoRipNoHeart'};
kernels = {'linear','rbf'};
PosLimStep = 0.5;
PosLims = [0.3 0.7];
DoZscore = 0;
SaveLoc = '/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/';
sess=1;
SessionTypes = {'Fear'};
SessType = SessionTypes{sess};


SessType = SessionTypes{sess};
AllMice = fieldnames(DATA.(SessType));
MergedData = [];
MouseId = [];
Pos = [];
for mm = 1:length(AllMice)
    MergedData = cat(2,MergedData,DATA.(SessType).(AllMice{mm})(1:8,:));
    MouseId = cat(2,MouseId,ones(1,size(DATA.(SessType).(AllMice{mm}),2))*mm);
    Pos = cat(2,Pos,DATA.(SessType).(AllMice{mm})(9,:));
end
GoodMice = unique(MouseId);

for parToUse = 1
    for svm_type    = 1
        
        %% Contols train and test
        % Only keep subset of parameters
        DATA2 = MergedData(ParToKeep{parToUse},:);
        
        
        %% LOO iteration
        for mm = 1:length(GoodMice)
            
            
            % Define train and test sets
            train_X = DATA2(:,find(MouseId~=GoodMice(mm)));
            test_X = DATA2(:,find(MouseId==GoodMice(mm)));
            train_Y = Pos(find(MouseId~=GoodMice(mm)));
            test_Y = Pos(find(MouseId==GoodMice(mm)));
            test_Pos =  Pos(find(MouseId==GoodMice(mm)));
            
            % Only keep interpretable positions for training
            Bad = (train_Y<PosLims(2) & train_Y>PosLims(1));
            train_X(:,Bad) = [];
            train_Y(Bad) = [];
            
            % Binarize in the middle of the maze
            train_Y = train_Y'>PosLimStep; % 0 for safe, 1 for shock
            test_Y = test_Y'>PosLimStep; % 0 for safe, 1 for shock
            
            
            % Keep only mice with full set of value
            train_Y(sum(isnan(train_X))>0) = [];
            test_Y(sum(isnan(test_X))>0) = [];
            
            train_X(:,sum(isnan(train_X))>0) = [];
            test_X(:,sum(isnan(test_X))>0) = [];
            size(test_X)
            
            
            if ~isempty(test_X)
                
                % balance the data
                numclass = min([sum(train_Y==0),sum(train_Y==1)]);
                SkId = find(train_Y==1);
                SkId = SkId(randperm(length(SkId),numclass));
                SfId = find(train_Y==0);
                SfId = SfId(randperm(length(SfId),numclass));
                train_Y = train_Y([SkId;SfId]);
                train_X = train_X(:,[SkId;SfId]);
                
                
                classifier_controltrain = fitcsvm(train_X',train_Y,...
                    'ClassNames',[0,1],'KernelFunction',kernels{svm_type});
                [prediction,scores2_test] = predict(classifier_controltrain,test_X');
                
                R = Range(OutPutData.Fear.respi_freq_bm.tsd{mm,3});
                t = interp1(linspace(0,max(R),length(R)) , R , linspace(0,max(R),length(scores2_test)));
                scores2_test_tsd{mm} = tsd(t , scores2_test(:,1));
                
                SVMScores_Sk_Ctrl{svm_type}{parToUse}{mm} = scores2_test(test_Y==0);
                SVMScores_Sf_Ctrl{svm_type}{parToUse}{mm} = scores2_test(test_Y==1);
                SVMChoice_Sk_Ctrl{svm_type}{parToUse}{mm} = prediction(test_Y==0);
                SVMChoice_Sf_Ctrl{svm_type}{parToUse}{mm} = prediction(test_Y==1);
                LinPos_Sk_Ctrl{svm_type}{parToUse}{mm} = test_Pos(test_Y==0);
                LinPos_Sf_Ctrl{svm_type}{parToUse}{mm} = test_Pos(test_Y==1);
                
                SVMScores_Sk_Ctrl_Mn{svm_type}(parToUse,mm) = nanmean(scores2_test(test_Y==0));
                SVMScores_Sf_Ctrl_Mn{svm_type}(parToUse,mm) = nanmean(scores2_test(test_Y==1));
                SVMChoice_Sk_Ctrl_Mn{svm_type}(parToUse,mm) = nanmean(prediction(test_Y==0));
                SVMChoice_Sf_Ctrl_Mn{svm_type}(parToUse,mm) = nanmean(prediction(test_Y==1));
            else
                SVMScores_Sk_Ctrl{svm_type}{parToUse}{mm} = [];
                SVMScores_Sf_Ctrl{svm_type}{parToUse}{mm} = [];
                SVMChoice_Sk_Ctrl{svm_type}{parToUse}{mm} = [];
                SVMChoice_Sf_Ctrl{svm_type}{parToUse}{mm} = [];
                LinPos_Sf_Ctrl{svm_type}{parToUse}{mm} = [];
                LinPos_Sk_Ctrl{svm_type}{parToUse}{mm} = [];
                
                SVMScores_Sk_Ctrl_Mn{svm_type}(parToUse,mm) = NaN;
                SVMScores_Sf_Ctrl_Mn{svm_type}(parToUse,mm) = NaN;
                SVMChoice_Sk_Ctrl_Mn{svm_type}(parToUse,mm) = NaN;
                SVMChoice_Sf_Ctrl_Mn{svm_type}(parToUse,mm) = NaN;
            end
        end
    end
end





clear Respi_Map  SVM_Map
sizeMap=100; sess=1; N=4;
for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    try
        
        Respi_on_Pos = Restrict(OutPutData.Fear.respi_freq_bm.tsd{mouse,3} , Restrict(Position_tsd.(Mouse_names{mouse}).Fear , Epoch1.Fear{mouse,3}));
        SVM_on_Pos = Restrict(scores2_test_tsd{mm} , Restrict(Position_tsd.(Mouse_names{mouse}).Fear , Epoch1.Fear{mouse,3}));
        
        Tmax = max(Range(OutPutData.Fear.respi_freq_bm.tsd{mouse,1}));
        for i=1:N
            BIN = intervalSet((Tmax/N)*(i-1) , (Tmax/N)*i);
            Respi2 = Restrict(Respi_on_Pos , BIN);
            SVM = Restrict(SVM_on_Pos , BIN);
            Pos = Data(Restrict(Position_tsd.(Mouse_names{mouse}).Fear , and(Epoch1.Fear{mouse,3} , BIN)));
            
            [OccupMap(mouse,:,:) , Respi_Map{i}(mouse,:,:)] = hist3d_BM([Pos(:,1) ;0; 0; 1; 1] , [Pos(:,2);0;1;0;1] , [Data(Respi2);0;1;0;1] , sizeMap , sizeMap);
            [OccupMap(mouse,:,:) , SVM_Map{i}(mouse,:,:)] = hist3d_BM([Pos(:,1) ;0; 0; 1; 1] , [Pos(:,2);0;1;0;1] , [Data(SVM);0;1;0;1] , sizeMap , sizeMap);
            
        end
        disp(mouse)
    end
end
for i=1:N
    Respi_Map{i}(Respi_Map{i}==0)=NaN;
    SVM_Map{i}(SVM_Map{i}==0)=NaN;
end

figure
for i=1:N
    subplot(2,N,i)
    imagesc(movmean(movmean(squeeze(nanmean(SVM_Map{i}))',5,'omitnan')',5,'omitnan')')
    axis xy, axis off, hold on, axis square, %caxis([-1 1]), c=caxis;
    sizeMap=100; Maze_Frame_BM
    %     u=colorbar; u.Ticks=[c(1) c(2)]; u.FontSize=15;
    %     u.Label.String = 'speed (cm/s)'; u.Label.FontSize=12; set(u.Label,'Rotation',270)
    colormap hot
    
    a=area([40 62],[74 74]);
    a.FaceColor=[1 1 1];
    a.LineWidth=1e-6;
    
    subplot(2,N,i+4)
    imagesc(movmean(movmean(squeeze(nanmean(Respi_Map{i}))',5,'omitnan')',5,'omitnan')')
    axis xy, axis off, hold on, axis square, caxis([1 7]), c=caxis;
    sizeMap=100; Maze_Frame_BM
    %     u=colorbar; u.Ticks=[c(1) c(2)]; u.FontSize=15;
    %     u.Label.String = 'speed (cm/s)'; u.Label.FontSize=12; set(u.Label,'Rotation',270)
    colormap hot
    
    a=area([40 62],[74 74]);
    a.FaceColor=[1 1 1];
    a.LineWidth=1e-6;
end
