 function StatsBulbSham(freezeTh,varargin)

% stats on already saved data using BarPlotBulbSham
% used here for freezing behavior

% INPUTS
% nocsperiod : if 0, the first 2 min wihtout sound are not plotted and not taken into account for statistics
% save : to save figure
% savestats : to save statistics

% default values :
savestats=0; 
noCSper=1;
sav=0;
datatype='fear';
for i = 1:2:length(varargin),
    switch(lower(varargin{i})),
        case 'save',
            sav = varargin{i+1};            
        case 'savestats',
            savestats = varargin{i+1};  
        case 'nocsperiod',
            noCSper = varargin{i+1};  
        case 'datatype',
            datatype = varargin{i+1};  
    end
end
 
%Gpcolor={'k','r'};
%Gpcolor={[0.7 0.7 0.7 ];'k'};
Gpcolor={[0 0 0.7 ];[0.8 0 0]};
%test='kruskal';
test='ranksum';
groupname={'sham','obx'};

h_ploterrorbarN=figure('color',[1 1 1],'Position',[1200 20 500 1000]);
h_StatsShamBulb=figure('Color',[1 1 1]); 
set(h_StatsShamBulb,'color',[1 1 1],'Position',[1200 20 500 1000])


a=1;
if strcmp(datatype, 'fear')
    StepName={'HAB grille';'COND';'EXT envC';'EXT envB'};
elseif strcmp(datatype, 'explo')
    StepName={'pre';'post';'+6j';'+2wk';'+3wk'};
elseif strcmp(datatype, 'pain')
    StepName={'RearNb';'AutoRearNb';'JumpNb';'LickNb'};
    set(h_ploterrorbarN,'color',[1 1 1],'Position',[300 20 1100 1000])
end
for i=1:length(StepName)
    if strcmp(datatype, 'fear')

        load (['shamAllMiceBilan_' num2str(freezeTh) '_grille.mat']);
        %load (['shamAllMiceBilan_' num2str(freezeTh) '_envC.mat'])
        %load (['shamAllMiceBilan_' num2str(freezeTh) '.mat'])
        Table{1,1}=bilan{1,i};
        load (['bulbAllMiceBilan_' num2str(freezeTh) '_grille.mat']);
        %load (['bulbAllMiceBilan_' num2str(freezeTh) '_envC.mat'])
        %load (['bulbAllMiceBilan_' num2str(freezeTh) '.mat'])
        Table{1,2}=bilan{1,i};
        
        if noCSper==0
        Table{1,1}(:,1)=[];
        Table{1,2}(:,1)=[];
        end
    
        info.nocsperiod=noCSper;
        figure(h_StatsShamBulb)
        BarPlotBulbSham(Table,StepName{i},Gpcolor,test,length(StepName),1,a, info,'savestats',savestats,'legendtype','freezing', 'errorbar','sem','indivdots',0);

        a=a+1;
        if i==1
            legend ('sham','bulb')
        end
        
    elseif strcmp(datatype, 'pain')
        load (['PainData_22souris.mat'])
        eval([ 'Table{1,1}=' StepName{i} '{1,1}']);
        eval([ 'Table{1,2}=' StepName{i} '{1,2}']);
    
        if noCSper==0
            Table{1,1}(:,1)=[];
            Table{1,2}(:,1)=[];
        end

        info.nocsperiod=noCSper;

        BarPlotBulbSham(Table,StepName{i},Gpcolor,test,length(StepName),1,a, info,'savestats',savestats);
        a=a+1;
        if i==1
            legend ('sham','bulb')
        end
    end
    
    for g=1:2
        figure(h_ploterrorbarN)
        subplot(length(StepName),2,2*(i-1)+g)
        PlotErrorBarN(Table{1,g},0,1,'ranksum');
        ylabel(StepName{i})
        title(groupname{g})
    end

end

if sav
    %set(gcf, 'PaperPosition', [1 1 13 42])
    set(h_StatsShamBulb, 'PaperPosition', [1 1 7 21])
    saveas(h_StatsShamBulb, [datatype 'BarComp_' num2str(freezeTh) '.fig'])
    %saveas(gcf, ['Freez_BarComp_' num2str(freezeTh) '.png'])
    currFold=pwd;
    saveFigure(h_StatsShamBulb, [datatype 'BarComp_' num2str(freezeTh)], currFold)
    

    set(gcf, 'PaperPosition', [1 1 13 21])
    saveas(h_ploterrorbarN, [datatype 'Bar_' num2str(freezeTh) '.fig'])
    currFold=pwd;
    saveFigure(h_ploterrorbarN, [datatype 'Bar_' num2str(freezeTh)], currFold)

end
