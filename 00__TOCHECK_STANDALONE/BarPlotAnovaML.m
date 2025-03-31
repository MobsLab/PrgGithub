function BarPlotAnovaML(A,B,KeepFigure,NamesAB,inverseFactor)

% BarPlotAnovaML(A,B,KeepFigure)
% A = vector with data
% B = Cell array. Cell i contains values of factor i for each data of A
%   (so each cell must be the length of A). max 2 factor
% KeepFigure (optional) = 1 to plot in current figure (default =0)
% NamesAB (optional) = cell array with names of {'data' 'factor1' 'factor2'} 
% inverseFactor (optional) = for reverse barplot

%% initialisation

if ~exist('A','var') || ~exist('B','var')
    error('Missing input arguments')
end
if ~exist('KeepFigure','var')
    KeepFigure = 0;
end

if ~exist('NamesAB','var') 
    NamesAB = {'data' 'factor1' 'factor2'};
end

if ~exist('inverseFactor','var') 
    inverseFactor = 0;
end

%% format data
for i = 1:length(B)
    Unique_temp{i} = unique(B{i});
end

BarStd=[];
BarLine=[];
position_errorbar=[];


if inverseFactor
    fact_errorbar=-length(Unique_temp{1})*0.05:length(Unique_temp{1})*0.1/(length(Unique_temp{1})-1):length(Unique_temp{1})*0.05;
    for i=1:length(Unique_temp{2}), position_errorbar_temp(i,1:length(Unique_temp{1}))=i+fact_errorbar;end
else
    fact_errorbar=-length(Unique_temp{2})*0.05:length(Unique_temp{2})*0.1/(length(Unique_temp{2})-1):length(Unique_temp{2})*0.05; 
    for i=1:length(Unique_temp{1}), position_errorbar_temp(i,1:length(Unique_temp{2}))=i+fact_errorbar;end
end

for i = 1:length(B)
    for j = 1:length(Unique_temp{i})
        
        try
            BarData(i,j) = nanmean(A(B{i}==Unique_temp{i}(j)));
            BarStd_temp(i,j)= stdError(A(B{i}==Unique_temp{i}(j)));
            legend_factor{i,j}=[NamesAB{i+1},' = ',num2str(Unique_temp{i}(j))];
        catch
            BarData(i,j) = nanmean(A(strcmp(B{i},Unique_temp{i}(j))));
            BarStd_temp(i,j)= stdError(A(strcmp(B{i},Unique_temp{i}(j))));
            legend_factor{i,j}=[NamesAB{i+1},' = ',Unique_temp{i}{j}];
        end

        if inverseFactor, 
            BarStd=[BarStd,BarStd_temp(i,j) ];
            BarLine=[BarLine,BarData(i,j) ];
            position_errorbar=[position_errorbar, position_errorbar_temp(j,i)];
        end
        
    end
    if ~inverseFactor,
        BarStd=[BarStd,BarStd_temp(i,:)];
        BarLine=[BarLine,BarData(i,:)];
        position_errorbar=[position_errorbar, position_errorbar_temp(i,1:length(BarData(i,:)))];
    end
end

%% bar plot display

if KeepFigure
    NumF = gcf;
else
    figure('color',[1 1 1]),
end

if inverseFactor
    bar(BarData')
    legend(legend_factor{1,1:length(Unique_temp{1})})
    set(gca,'xtick',[1:length(Unique_temp{2})]);
    set(gca,'xticklabel',legend_factor(2,1:length(Unique_temp{2})));
else
    bar(BarData)
    legend(legend_factor{2,1:length(Unique_temp{2})})
    set(gca,'xtick',[1:length(Unique_temp{1})]);
    set(gca,'xticklabel',legend_factor(1,1:length(Unique_temp{1})));
end
ylabel(NamesAB{1});
hold on, errorbar(position_errorbar,BarLine,BarStd,'+','color','k')
keyboard;



%% stats

% ttest for each injection period

if length(Strains)==2
    for inj=1:length(InjName)
        Temp1 = AnovData(AnovFactor_Injection==inj & AnovFactor_Strains==1);
        Temp2 = AnovData(AnovFactor_Injection==inj & AnovFactor_Strains==2);
        p = ranksum(Temp1,Temp2);
        if p<pval
            text(inj,1.1*max(nanmean(Temp1),nanmean(Temp2)),['p=',num2str(floor(1000*p)/1000)],'Color','r')
        else
            text(inj,1.1*max(nanmean(Temp1),nanmean(Temp2)),['p=',num2str(floor(1000*p)/1000)])
        end
    end
    ylabel(['Spectrum power ',num2str(FreqBand(1)),'-',num2str(FreqBand(2)),'Hz    (p, ranksum)']);
end

try
    if length(InjName)>1 && length(Strains)>1
        [p,table] = anovan(AnovData,{AnovFactor_Strains AnovFactor_Injection},'model','full');
        title({['strains: p=',num2str(floor(1E4*p(1))/1E4),'; Injection: p=',num2str(floor(1E4*p(2))/1E4)],['ANOVA Interaction p=',num2str(floor(1E4*p(3))/1E4)]});
    elseif length(InjName)>1 && length(Strains)<2
        [p,table] = anovan(AnovData,{AnovFactor_Injection});
        title(['ANOVA Injection: p=',num2str(floor(1E4*p(1))/1E4)]);
    elseif length(InjName)<2 && length(Strains)>1
        [p,table] = anovan(AnovData,{AnovFactor_Strains});
        title(['ANOVA strains: p=',num2str(floor(1E4*p(1))/1E4)]);
    end
catch
    disp('problem stats');keyboard
end