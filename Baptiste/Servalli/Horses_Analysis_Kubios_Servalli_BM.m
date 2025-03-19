
%% generate data
file=dir('*.csv'); 
for f=1:25
    filename{f}=file(f).name;
    pathname=pwd;
    Kubios_val{f} = csvread(fullfile(pathname,filename{f}),1,1,[52,1,70,1]);
    Kubios_val2{f} = dlmread(fullfile(pathname,filename{f}),',',1,1,[75,1,104,2]);
    KubiosVal(f,:) = Kubios_val{f}([2:4 7:17 19 20],2);
    KubiosVal2(f,:) = [Kubios_val2{f}([2:4 6:11 13:15 17:20 23:27 29:30],2) ; Kubios_val2{f}([2:4 6:11 13:15 17:20],3)];
    Kubios_values(f,:) = [KubiosVal(f,:) KubiosVal2(f,:)];
end

Noms = {'Jinenca' 'Jazz' 'Florida' 'Henao' 'Hades' 'Kigigotte'...
    'Ludo' 'Karen' 'Aragon' 'Cheik' 'Early' 'Fairs' 'Flute' 'Hidalgo'...
'Hiya' 'Itchoui' 'Ludmila' 'Malice' 'Mavis' 'Nemo' 'Tarfa' 'Varga' 'Version' 'Yallah' 'Elagante'};

Parameters = {'PNS index','SNS index','Stress index','Mean RR  (ms)','SDNN (ms)','Mean HR (beats/min)',...
    'SD HR (beats/min)','Min HR (beats/min)','Max HR (beats/min)','RMSSD (ms)','NNxx (beats)',...
    'pNNxx (%)','SDANN (ms)','SDNN index (ms)','RR tri index','TINN (ms)',...
    'VLF (Hz)' 'LF (Hz)','HF (Hz)','VLF (ms^2)','LF (ms^2)','HF (ms^2)',...
    'VLF (log)','LF (log)','HF (log)','VLF (%)','LF (%)','HF (%)','LF (n.u.)',...
    'HF (n.u.)','Total power (ms^2)','LF/HF ratio','SD1 (ms)','SD2 (ms)',...
    'SD2/SD1 ratio','Approximate entropy (ApEn)','Sample entropy (SampEn)',...
    'alpha 1','alpha 2','2 VLF (Hz)' '2 LF (Hz)','2 HF (Hz)','2 VLF (ms^2)','2 LF (ms^2)','2 HF (ms^2)',...
    '2 VLF (log)','2 LF (log)','2 HF (log)','2 VLF (%)','2 LF (%)','2 HF (%)','2 LF (n.u.)',...
    '2 HF (n.u.)','2 Total power (ms^2)','2 LF/HF ratio'};

ScoreDouleur = [1 1 2 1 1 1 1 7,5 8 9 8 9 5 7 4 4 9 5 10 9 5 8 6 6];
ScoreDouleurCL = logical([0 0 0 0 0 0 0 0 1 1 1 1 1 0 1 0 0 1 0 1 1 0 1 0 0]);
DouleurCL = logical([0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1]);

for param=1:length(Kubios_values) 
    [R(param),P(param)] = corr(ScoreDouleur' , Kubios_values(:,param),'type','spearman');
    [R2(param),P2(param)] = corr(ScoreDouleur(ScoreDouleurCL)' , Kubios_values(ScoreDouleurCL,param),'type','spearman');    
    [R3(param),P3(param)] = corr(ScoreDouleur(DouleurCL)' , Kubios_values(DouleurCL,param),'type','spearman');    
end
R = abs(R); R2 = abs(R2) ; R3 = abs(R3);


%% figures
figure
subplot(121)
imagesc(R')
colorbar
yticks([1:length(Parameters)]), yticklabels(Parameters)
title('R')

subplot(122)
imagesc(1-P')
colorbar
title('1-P')

colormap magma
a=suptitle('R & P analysis from Kubios parameters values, Spearman, all horses'); a.FontSize=20;

% Score Douleur CL
figure
subplot(121)
imagesc(R2')
colorbar
yticks([1:length(Parameters)]), yticklabels(Parameters)
title('R')

subplot(122)
imagesc(1-P2')
colorbar
title('1-P')
hold on, plot(1,find(P2<.05),'*r')

colormap magma
a=suptitle('R & P analysis from Kubios parameters values, Spearman, painfull horses, ScoreDouleurCL'); a.FontSize=15;

% Douleur CL
figure
subplot(121)
imagesc(R3')
colorbar
yticks([1:length(Parameters)]), yticklabels(Parameters)
title('R')

subplot(122)
imagesc(1-P3')
colorbar
title('1-P')
hold on, plot(1,find(P3<.05),'*r')

colormap magma
a=suptitle('R & P analysis from Kubios parameters values, Spearman, painfull horses, DouleurCL'); a.FontSize=15;


%% correlations
figure, i=1;
for param=find(P2<.05)
    subplot(2,2,i)
    PlotCorrelations_BM(ScoreDouleur(ScoreDouleurCL) , Kubios_values(ScoreDouleurCL,param)')
    xlim([4 11])
    if i>2
        xlabel('Score Douleur 1')
    end
    title(Parameters{param})
    i=i+1;
end


figure, i=1;
for param=find(P3<.05)
    PlotCorrelations_BM(ScoreDouleur(DouleurCL) , Kubios_values(DouleurCL,param)' , 'method','Spearman')
    axis square
    xlim([3 11])
    xlabel('Pain score 2 (a.u.)')
    title(Parameters{param})
    i=i+1;
end
a=suptitle('Significative correlations, second pain method, Spearman, painfull horses'); a.FontSize=20;



figure, i=1;
for param=36
    PlotCorrelations_BM(ScoreDouleur , Kubios_values(:,param)' , 'method','Spearman')
    axis square, xlim([0 11])
    xlabel('Pain score (a.u.)')
    title(Parameters{param})
    i=i+1;
end
a=suptitle('Significative correlation, pain method, Spearman, all horses'); a.FontSize=20;


%% Kubios inter-dependencies
[Rx,Px] = corr(Kubios_values,'type','spearman');
Rx=abs(Rx);
[~,ind_x] = sortrows(Rx);

figure
imagesc(Rx(ind_x,ind_x))
xticks([1:55]), yticks([1:55])
xticklabels(Parameters(ind_x)), yticklabels(Parameters(ind_x))
xtickangle(45), ytickangle(0)
colormap magma
axis square

a=suptitle('Kubios interdependencies'); a.FontSize=20;


[Rx,Px] = corr(Kubios_values','type','spearman');
Rx=abs(Rx);
[~,ind_x] = sortrows(Rx);

figure
imagesc(Rx(ind_x,ind_x))
xticks([1:25]), yticks([1:25])
xticklabels(Noms), yticklabels(Noms)
xtickangle(90), ytickangle(0)
colormap magma
axis square
c=vline(8.5,'-r'); b=hline(8.5,'-r'); 
c.LineWidth=4; b.LineWidth=4;

a=suptitle('Horses interdependencies'); a.FontSize=20;


%%
filename=file.name;
pathname=pwd;
DLC=csvread(fullfile(pathname,filename),113,1); %loads the csv from line 3 to the end (to skip the Header)

HR = 1./DLC(:,2);
RR = DLC(:,2);
HR_tsd = tsd(DLC(:,1)*1e4 , HR);
LFP_rand = tsd([0:8:max(DLC(:,1))*1e4],ones(length([0:8:max(DLC(:,1))*1e4]),1));
HR_corr = Restrict(HR_tsd , LFP_rand);
LFP = HR_corr;
save('LFP0.mat','LFP')

LowSpectrumSB(pwd , 0 , 'HR')

histogram(DLC(:,2))

h=histogram(DLC(:,2),'BinLimits',[1 1.7],'NumBins',14); 

SI = sqrt((191/579)*100/(median(RR) * 2*.7))






