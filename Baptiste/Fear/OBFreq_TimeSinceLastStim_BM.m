

clear all

%% path & load data
% eyelid
Group=22;
Drug_Group={'Saline'};
GetAllSalineSessions_BM
l{1} = load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_Physio_Freezing_Saline_Eyelid_Cond_2sFullBins.mat');

% DZP
Group=[13 15];
Drug_Group={'Saline','Diazepam'};
GetEmbReactMiceFolderList_BM
l{1} = load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_Physio_Freezing_SalineShort_Cond_2sFullBin.mat');
l{2} = load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_Physio_Freezing_DZPShort_Cond_2sFullBin.mat');

% rip inhib
Group=[7 8];
Drug_Group={'RipControl','RipInhib'};
GetEmbReactMiceFolderList_BM
l{1} = load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_Physio_Freezing_RipInhib_Cond_2sFullBins.mat');
l{2} = load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_Physio_Freezing_RipInhib_Ctrl_Cond_2sFullBins.mat');



% for sess=1:length(Session_type)
%     [OutPutData.(Session_type{sess}) , Epoch1.(Session_type{sess})] = ...
%         MeanValuesPhysiologicalParameters_BM('all_saline',Mouse,lower(Session_type{sess}),'respi_freq_bm');
% end

%% parameters
Session_type={'Cond'}; sess=1;
max_time = 100;
x=1:max_time;

%% data collection
for group=1:length(Drug_Group)
    Mouse=Drugs_Groups_UMaze_BM(Group(group));
    for mouse=1:length(Mouse)
        St = Start(l{group}.Epoch1.(Session_type{sess}){mouse,2});
        i=1;
        for stim=1:length(St)
            if stim~=length(St)
                InterStim = intervalSet(St(stim) , St(stim+1));
            else
                InterStim = intervalSet(St(stim) , max(Range(l{group}.OutPutData.(Session_type{sess}).respi_freq_bm.tsd{mouse,1})));
            end
            InterStimDur = ceil(DurationEpoch(InterStim)/1e4)-1;
            InterStimDur_all(mouse,stim) = InterStimDur;
            if and(InterStimDur~=30 , InterStimDur~=29)
                InterStimDur_all_free(mouse,i) = InterStimDur;
                MeanDur_TSLS_safe(mouse,i) = (nanmean(Range(Restrict(l{group}.OutPutData.Cond.respi_freq_bm.tsd{mouse,6} , InterStim)))-St(stim))/1e4;
                i=i+1;
            end
            if InterStimDur>max_time
                InterStimDur =max_time;
            end
            for bin=1:InterStimDur
                
                Bin = intervalSet(St(stim)+(bin-1)*1e4 , St(stim)+bin*1e4);
                
                Respi_all{group}{mouse}(stim,bin) = nanmean(Data(Restrict(l{group}.OutPutData.Cond.respi_freq_bm.tsd{mouse,3} , Bin)));
                Respi_shock{group}{mouse}(stim,bin) = nanmean(Data(Restrict(l{group}.OutPutData.Cond.respi_freq_bm.tsd{mouse,5} , Bin)));
                Respi_safe{group}{mouse}(stim,bin) = nanmean(Data(Restrict(l{group}.OutPutData.Cond.respi_freq_bm.tsd{mouse,6} , Bin)));
                
            end
        end
        Respi_all{group}{mouse}(Respi_all{group}{mouse}==0) = NaN;
        Respi_shock{group}{mouse}(Respi_shock{group}{mouse}==0) = NaN;
        Respi_safe{group}{mouse}(Respi_safe{group}{mouse}==0) = NaN;
        
        disp(mouse)
    end
end
InterStimDur_all(InterStimDur_all==0) = NaN;
InterStimDur_all_free(InterStimDur_all_free==0) = NaN;
MeanDur_TSLS_safe(MeanDur_TSLS_safe==0) = NaN;


clear FirstStim_shock_Respi LastStim_shock_Respi FirstStim_safe_Respi LastStim_safe_Respi
for group=1:length(Drug_Group)
    Mouse=Drugs_Groups_UMaze_BM(Group(group));
    for mouse=1:length(Mouse)
        
        Respi_shock{group}{mouse}(size(Respi_shock{group}{mouse},1),length(x)) = 0;
        Respi_safe{group}{mouse}(size(Respi_safe{group}{mouse},1),length(x)) = 0;
        Respi_shock{group}{mouse}(Respi_shock{group}{mouse}==0) = NaN;
        Respi_safe{group}{mouse}(Respi_safe{group}{mouse}==0) = NaN;
                FirstStim_all_Respi{group}(mouse,:) = nanmean(Respi_all{group}{mouse}(1:3,:));
                LastStim_all_Respi{group}(mouse,:) = nanmean(Respi_all{group}{mouse}(end-2:end,:));
        try
            FirstStim_shock_Respi{group}(mouse,:) = nanmean(Respi_shock{group}{mouse}(1:5,:));
            LastStim_shock_Respi{group}(mouse,:) = nanmean(Respi_shock{group}{mouse}(end-4:end,:));
            FirstStim_safe_Respi{group}(mouse,:) = nanmean(Respi_safe{group}{mouse}(1:5,:));
            LastStim_safe_Respi{group}(mouse,:) = nanmean(Respi_safe{group}{mouse}(end-4:end,:));
        
                VeryFirstStim_shock_Respi{group}(mouse,:) = Respi_shock{group}{mouse}(1,:);
        
                AllStim_Respi_all{group}(mouse,:) = nanmean(Respi_all{group}{mouse});
                AllStim_Respi_shock{group}(mouse,:) = nanmean(Respi_shock{group}{mouse});
                AllStim_Respi_safe{group}(mouse,:) = nanmean(Respi_safe{group}{mouse});
             end
   
    end
end
FirstStim_shock_Respi{group}(FirstStim_shock_Respi{group}==0) = NaN;
LastStim_shock_Respi{group}(LastStim_shock_Respi{group}==0) = NaN;
FirstStim_safe_Respi{group}(FirstStim_safe_Respi{group}==0) = NaN;
LastStim_safe_Respi{group}(LastStim_safe_Respi{group}==0) = NaN;
AllStim_Respi_shock{group}(AllStim_Respi_shock{group}==0) = NaN;
AllStim_Respi_safe{group}(AllStim_Respi_safe{group}==0) = NaN;
AllStim_Respi_all{group}(AllStim_Respi_all{group}==0) = NaN;


FirstStim_safe_Respi(25,3) = NaN;

%% figures
figure
subplot(121)
clear D, D = FirstStim_safe_Respi{1}(:,x);
plot(x , movmean(nanmean(D),20,'omitnan') , '.' , 'MarkerSize' , 20 , 'Color' , [.5 .5 1]), hold on
errhigh = nanstd(D)/sqrt(size(D,1));
errlow  = zeros(1,length(x));
er = errorbar(x,movmean(nanmean(D),20,'omitnan'),errlow,errhigh);
er.Color = [0 0 0]; er.LineStyle = 'none'; er.CapSize=1;
clear D, D = LastStim_safe_Respi{1}(:,x);
plot(x , movmean(nanmean(D),20,'omitnan') , '.' , 'MarkerSize' , 20 , 'Color' , [.3 .3 .7]), hold on
errhigh = nanstd(D)/sqrt(size(D,1));
errlow  = zeros(1,length(x));
er = errorbar(x,movmean(nanmean(D),20,'omitnan'),errlow,errhigh);
er.Color = [0 0 0]; er.LineStyle = 'none'; er.CapSize=1;
ylim([2 6.5]), grid on
f=get(gca,'Children'); legend([f(4),f(2)],'First','Last');
xlabel('time since last shock'), ylabel('Breathing (Hz)')
makepretty_BM2


subplot(122)
clear D, D = FirstStim_shock_Respi{1}(:,x);
plot(x , movmean(nanmean(D),20,'omitnan') , '.' , 'MarkerSize' , 20 , 'Color' , [1 .5 .5]), hold on
errhigh = nanstd(D)/sqrt(size(D,1));
errlow  = zeros(1,length(x));
er = errorbar(x,movmean(nanmean(D),20,'omitnan'),errlow,errhigh);
er.Color = [0 0 0]; er.LineStyle = 'none'; er.CapSize=1;
clear D, D = LastStim_shock_Respi{1}(:,x);
plot(x , movmean(nanmean(D),20,'omitnan') , '.' , 'MarkerSize' , 20 , 'Color' , [.7 .3 .3]), hold on
errhigh = nanstd(D)/sqrt(size(D,1));
errlow  = zeros(1,length(x));
er = errorbar(x,movmean(nanmean(D),20,'omitnan'),errlow,errhigh);
er.Color = [0 0 0]; er.LineStyle = 'none'; er.CapSize=1;
ylim([2 6.5]), grid on
xlabel('time since last shock')
f=get(gca,'Children'); legend([f(4),f(2)],'First','Last');
makepretty_BM2




figure
subplot(5,1,1:2)
clear D, D = AllStim_Respi_shock{1}(:,x);
plot(x , movmean(nanmean(D),5,'omitnan') , '.' , 'MarkerSize' , 20 , 'Color' , [1 .5 .5]), hold on
errhigh = nanstd(D)/sqrt(size(D,1));
errlow  = zeros(1,length(x));
er = errorbar(x,movmean(nanmean(D),5,'omitnan'),errlow,errhigh);
er.Color = [0 0 0]; er.LineStyle = 'none'; er.CapSize=1;
clear D, D = AllStim_Respi_safe{1}(:,x);
plot(x , movmean(nanmean(D),5,'omitnan') , '.' , 'MarkerSize' , 20 , 'Color' , [.5 .5 1]), hold on
errhigh = nanstd(D)/sqrt(size(D,1));
errlow  = zeros(1,length(x));
er = errorbar(x,movmean(nanmean(D),5,'omitnan'),errlow,errhigh);
er.Color = [0 0 0]; er.LineStyle = 'none'; er.CapSize=1;
xlim([0 max_time]), ylim([2 6.5]), grid on
f=get(gca,'Children'); legend([f(4),f(2)],'shock','safe');
xlabel('time since last shock'), ylabel('Breathing (Hz)')
makepretty_BM2

subplot(513)
b=bar(movmean(nanmean(AllStim_Respi_shock{1}(:,x))-nanmean(AllStim_Respi_safe{1}(:,x)),5,'omitnan')); b.FaceColor=[.1 .1 .1]; box off
xlim([0 max_time]), ylim([-2 4]), ylabel('Breathing diff (Hz)')

subplot(514)
a=bar(sum(~isnan(AllStim_Respi_shock{1}))); a.FaceColor=[1 .5 .5]; box off
xlim([0 max_time]), ylim([0 22]), ylabel('mice (#)')

subplot(515)
a=bar(sum(~isnan(AllStim_Respi_safe{1}))); a.FaceColor=[.5 .5 1]; box off
xlim([0 max_time]), ylim([0 22]), ylabel('mice (#)')
xlabel('time since last shock'),




figure
clear D, D = AllStim_Respi_all{1}(:,x);
plot(x , movmean(nanmean(D),20,'omitnan') , '.' , 'MarkerSize' , 20 , 'Color' , [.5 .5 1]), hold on
errhigh = nanstd(D)/sqrt(size(D,1));
errlow  = zeros(1,length(x));
er = errorbar(x,movmean(nanmean(D),20,'omitnan'),errlow,errhigh);
er.Color = [0 0 0]; er.LineStyle = 'none'; er.CapSize=1;



figure
[R,P,a,b,LINE]=PlotCorrelations_BM(x,log2(nanmean(AllStim_Respi_all{1})));

figure
[R,P,a,b,LINE]=PlotCorrelations_BM(log(x),nanmean(AllStim_Respi_all{1}));


figure
[R,P,a,b,LINE]=PlotCorrelations_BM(x,nanmean(AllStim_Respi_all{1}));




figure
x = [1:max_time];
clear D, D = AllStim_Respi_all(:,x);
plot(x , nanmean(D) , '.' , 'MarkerSize' , 10 , 'Color' , [.3 .3 .3]), hold on
errhigh = nanstd(D)/sqrt(size(D,1));
errlow  = zeros(1,length(x));
er = errorbar(x,nanmean(D),errlow,errhigh);
er.Color = [0 0 0]; er.LineStyle = 'none'; er.CapSize=1;
ylim([3.5 6.5]), grid on
xlabel('time since last shock (s)'), ylabel('Breathing (Hz)')
makepretty_BM2



figure
subplot(6,1,1:2)
x = [1:100];
clear D, D = FirstStim_shock_Respi{1}(:,x);
plot(x , movmean(nanmean(D),5,'omitnan') , '.' , 'MarkerSize' , 20 , 'Color' , [1 .5 .5]), hold on
errhigh = nanstd(D)/sqrt(size(D,1));
errlow  = zeros(1,length(x));
er = errorbar(x,movmean(nanmean(D),5,'omitnan'),errlow,errhigh);
er.Color = [0 0 0]; er.LineStyle = 'none'; er.CapSize=1;

% clear Y
% [ind1,ind2] = find(~isnan(FirstStim_shock_Respi{1}));
% for i=ind1
%     for j=ind2
%         Y(i,j) = FirstStim_safe_Respi{1}(i,j);
%     end
% end
% Y(size(Y,1),100)=0;
% Y(Y==0)=NaN;

clear D, D = FirstStim_safe_Respi{1}(:,x);
plot(x , movmean(nanmean(D),5,'omitnan') , '.' , 'MarkerSize' , 20 , 'Color' , [.5 .5 1]), hold on
errhigh = nanstd(D)/sqrt(size(D,1));
errlow  = zeros(1,length(x));
er = errorbar(x,movmean(nanmean(D),5,'omitnan'),errlow,errhigh);
er.Color = [0 0 0]; er.LineStyle = 'none'; er.CapSize=1;
ylim([2 6.5]), grid on
xlabel(''), ylabel('Breathing (Hz)')
makepretty_BM2
f=get(gca,'Children'); legend([f(4),f(2)],'Shock','Safe');
title('First stims')

subplot(613)
Data_to_use = movmean(nanmean(FirstStim_shock_Respi{1}(:,x)),5,'omitnan')-movmean(nanmean(FirstStim_safe_Respi{1}(:,x)),5,'omitnan');
b=bar(x , Data_to_use); b.FaceColor=[.5 .5 .5]; hold on
ylabel('diff')
makepretty, ylim([-2 2])

subplot(6,1,4:5)
clear D, D = LastStim_shock_Respi{1}(:,x);
plot(x , movmean(nanmean(D),5,'omitnan') , '.' , 'MarkerSize' , 20 , 'Color' , [.7 .3 .3]), hold on
errhigh = nanstd(D)/sqrt(size(D,1));
errlow  = zeros(1,length(x));
er = errorbar(x,movmean(nanmean(D),5,'omitnan'),errlow,errhigh);
er.Color = [0 0 0]; er.LineStyle = 'none'; er.CapSize=1;

% clear Y
% [ind1,ind2] = find(~isnan(LastStim_shock_Respi{1}));
% for i=ind1
%     for j=ind2
%         Y(i,j) = FirstStim_safe_Respi{1}(i,j);
%     end
% end
% Y(Y==0)=NaN;

clear D, D = LastStim_safe_Respi{1}(:,x);
plot(x , movmean(nanmean(D),3,'omitnan') , '.' , 'MarkerSize' , 20 , 'Color' , [.3 .3 .7]), hold on
errhigh = nanstd(D)/sqrt(size(D,1));
errlow  = zeros(1,length(x));
er = errorbar(x,movmean(nanmean(D),3,'omitnan'),errlow,errhigh);
er.Color = [0 0 0]; er.LineStyle = 'none'; er.CapSize=1;
ylim([2 6.5]), grid on
ylabel('Breathing (Hz)')
makepretty_BM2
f=get(gca,'Children'); legend([f(4),f(2)],'Shock','Safe');
title('Last stims')

subplot(616)
Data_to_use = movmean(nanmean(LastStim_shock_Respi{1}(:,x)),5,'omitnan')-movmean(nanmean(LastStim_safe_Respi{1}(:,x)),5,'omitnan');
b=bar(x , Data_to_use); b.FaceColor=[.5 .5 .5]; hold on
xlabel('time since last shock'), ylabel('diff')
makepretty, ylim([-2 2])


%% drugs groups
figure
subplot(6,2,[1 3])
x = [1:100];
clear D, D = FirstStim_shock_Respi{1}(:,x);
plot(x , movmean(nanmean(D),5,'omitnan') , '.' , 'MarkerSize' , 20 , 'Color' , [1 .5 .5]), hold on
errhigh = nanstd(D)/sqrt(size(D,1));
errlow  = zeros(1,length(x));
er = errorbar(x,movmean(nanmean(D),5,'omitnan'),errlow,errhigh);
er.Color = [0 0 0]; er.LineStyle = 'none'; er.CapSize=1;

clear D, D = FirstStim_safe_Respi{1}(:,x);
plot(x , movmean(nanmean(D),5,'omitnan') , '.' , 'MarkerSize' , 20 , 'Color' , [.5 .5 1]), hold on
errhigh = nanstd(D)/sqrt(size(D,1));
errlow  = zeros(1,length(x));
er = errorbar(x,movmean(nanmean(D),5,'omitnan'),errlow,errhigh);
er.Color = [0 0 0]; er.LineStyle = 'none'; er.CapSize=1;
ylim([2 6.5]), grid on
xlabel(''), ylabel('Breathing (Hz)')
makepretty_BM2
f=get(gca,'Children'); legend([f(4),f(2)],'Shock','Safe');
title('First stims')

subplot(625)
Data_to_use = movmean(nanmean(FirstStim_shock_Respi{1}(:,x)),5,'omitnan')-movmean(nanmean(FirstStim_safe_Respi{1}(:,x)),5,'omitnan');
b=bar(x , Data_to_use); b.FaceColor=[.5 .5 .5]; hold on
ylabel('diff'), ylim([-2 2])
makepretty


subplot(6,2,[7 9])
clear D, D = LastStim_shock_Respi{1}(:,x);
plot(x , movmean(nanmean(D),5,'omitnan') , '.' , 'MarkerSize' , 20 , 'Color' , [.7 .3 .3]), hold on
errhigh = nanstd(D)/sqrt(size(D,1));
errlow  = zeros(1,length(x));
er = errorbar(x,movmean(nanmean(D),5,'omitnan'),errlow,errhigh);
er.Color = [0 0 0]; er.LineStyle = 'none'; er.CapSize=1;

clear D, D = LastStim_safe_Respi{1}(:,x);
plot(x , movmean(nanmean(D),3,'omitnan') , '.' , 'MarkerSize' , 20 , 'Color' , [.3 .3 .7]), hold on
errhigh = nanstd(D)/sqrt(size(D,1));
errlow  = zeros(1,length(x));
er = errorbar(x,movmean(nanmean(D),3,'omitnan'),errlow,errhigh);
er.Color = [0 0 0]; er.LineStyle = 'none'; er.CapSize=1;
ylim([2 6.5]), grid on
ylabel('Breathing (Hz)')
makepretty_BM2
f=get(gca,'Children'); legend([f(4),f(2)],'Shock','Safe');
title('Last stims')

subplot(6,2,11)
Data_to_use = movmean(nanmean(LastStim_shock_Respi{1}(:,x)),5,'omitnan')-movmean(nanmean(LastStim_safe_Respi{1}(:,x)),5,'omitnan');
b=bar(x , Data_to_use); b.FaceColor=[.5 .5 .5]; hold on
xlabel('time since last shock'), ylabel('diff')
makepretty, ylim([-2 2])




subplot(6,2,[2 4])
x = [1:100];
clear D, D = FirstStim_shock_Respi{2}(:,x);
plot(x , movmean(nanmean(D),5,'omitnan') , '.' , 'MarkerSize' , 20 , 'Color' , [1 .5 .5]), hold on
errhigh = nanstd(D)/sqrt(size(D,1));
errlow  = zeros(1,length(x));
er = errorbar(x,movmean(nanmean(D),5,'omitnan'),errlow,errhigh);
er.Color = [0 0 0]; er.LineStyle = 'none'; er.CapSize=1;

clear D, D = FirstStim_safe_Respi{2}(:,x);
plot(x , movmean(nanmean(D),5,'omitnan') , '.' , 'MarkerSize' , 20 , 'Color' , [.5 .5 1]), hold on
errhigh = nanstd(D)/sqrt(size(D,1));
errlow  = zeros(1,length(x));
er = errorbar(x,movmean(nanmean(D),5,'omitnan'),errlow,errhigh);
er.Color = [0 0 0]; er.LineStyle = 'none'; er.CapSize=1;
ylim([2 6.5]), grid on
xlabel(''), ylabel('Breathing (Hz)')
makepretty_BM2
f=get(gca,'Children'); legend([f(4),f(2)],'Shock','Safe');
title('First stims')

subplot(626)
Data_to_use = movmean(nanmean(FirstStim_shock_Respi{2}(:,x)),5,'omitnan')-movmean(nanmean(FirstStim_safe_Respi{2}(:,x)),5,'omitnan');
b=bar(x , Data_to_use); b.FaceColor=[.5 .5 .5]; hold on
ylabel('diff'), ylim([-2 2])
makepretty


subplot(6,2,[8 10])
clear D, D = LastStim_shock_Respi{2}(:,x);
plot(x , movmean(nanmean(D),5,'omitnan') , '.' , 'MarkerSize' , 20 , 'Color' , [.7 .3 .3]), hold on
errhigh = nanstd(D)/sqrt(size(D,1));
errlow  = zeros(1,length(x));
er = errorbar(x,movmean(nanmean(D),5,'omitnan'),errlow,errhigh);
er.Color = [0 0 0]; er.LineStyle = 'none'; er.CapSize=1;

clear D, D = LastStim_safe_Respi{2}(:,x);
plot(x , movmean(nanmean(D),3,'omitnan') , '.' , 'MarkerSize' , 20 , 'Color' , [.3 .3 .7]), hold on
errhigh = nanstd(D)/sqrt(size(D,1));
errlow  = zeros(1,length(x));
er = errorbar(x,movmean(nanmean(D),3,'omitnan'),errlow,errhigh);
er.Color = [0 0 0]; er.LineStyle = 'none'; er.CapSize=1;
ylim([2 6.5]), grid on
ylabel('Breathing (Hz)')
makepretty_BM2
f=get(gca,'Children'); legend([f(4),f(2)],'Shock','Safe');
title('Last stims')

subplot(6,2,12)
Data_to_use = movmean(nanmean(LastStim_shock_Respi{2}(:,x)),5,'omitnan')-movmean(nanmean(LastStim_safe_Respi{2}(:,x)),5,'omitnan');
b=bar(x , Data_to_use); b.FaceColor=[.5 .5 .5]; hold on
xlabel('time since last shock'), ylabel('diff')
makepretty, ylim([-2 2])













