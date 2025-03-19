%% Get Data (not necessary if alligned data is already saved in CompareSleepRev.mat)

clear all
TrajPreSleep = [];
TrajPosSleep = [];
HabRev = [];
TrajPreRev = [];

% %M863
for m=1:4
    load(['/media/vador/DataMOBS104/Marcelo/M863/20190520/SleepImport/ERC-Mouse-863-20052019-TestPre_0',num2str(m-1),'/cleanBehavResources'])
    if m==1
    [AlignedYtsd,AlignedXtsd,~,XYOutput] = MorphMazeToSingleShape_EmbReact_DB_MO(CleanYtsd,CleanXtsd,Zone{1},ref,Ratio_IMAonREAL);
    TrajPreSleep{1} = [Data(AlignedXtsd) Data(AlignedYtsd)];
    else
    [AlignedYtsd,AlignedXtsd,~,~] = MorphMazeToSingleShape_EmbReact_DB_MO(CleanYtsd,CleanXtsd,Zone{1},ref,Ratio_IMAonREAL,XYOutput);
    TrajPreSleep{1} = cat(1,TrajPreSleep{1},[Data(AlignedXtsd) Data(AlignedYtsd)]);
    end        
    
end

for m=1:4
    load(['/media/vador/DataMOBS104/Marcelo/M863/20190520/SleepImport/ERC-Mouse-863-20052019-TestPost_0',num2str(m+1),'/cleanBehavResources'])
    if m==1
    [AlignedYtsd,AlignedXtsd,~,XYOutput] = MorphMazeToSingleShape_EmbReact_DB_MO(CleanYtsd,CleanXtsd,Zone{1},ref,Ratio_IMAonREAL);
    TrajPosSleep{1} = [Data(AlignedXtsd) Data(AlignedYtsd)];
    else
    [AlignedYtsd,AlignedXtsd,~,~] = MorphMazeToSingleShape_EmbReact_DB_MO(CleanYtsd,CleanXtsd,Zone{1},ref,Ratio_IMAonREAL,XYOutput);
    TrajPosSleep{1} = cat(1,TrajPosSleep{1},[Data(AlignedXtsd) Data(AlignedYtsd)]);
    end
end

load(['/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-Hab_00/cleanBehavResources'])
[AlignedYtsd,AlignedXtsd,~,XYOutput] = MorphMazeToSingleShape_EmbReact_DB_MO(CleanYtsd,CleanXtsd,Zone{1},ref,Ratio_IMAonREAL);
HabRev{1} =[Data(AlignedXtsd) Data(AlignedYtsd)];

for m=1:4
    load(['/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-TestPre_0',num2str(m-1),'/cleanBehavResources'])
    if m==1
    [AlignedYtsd,AlignedXtsd,~,~] = MorphMazeToSingleShape_EmbReact_DB_MO(CleanYtsd,CleanXtsd,Zone{1},ref,Ratio_IMAonREAL,XYOutput);
    TrajPreRev{1} = [Data(AlignedXtsd) Data(AlignedYtsd)]; 
    else
    [AlignedYtsd,AlignedXtsd,~,~] = MorphMazeToSingleShape_EmbReact_DB_MO(CleanYtsd,CleanXtsd,Zone{1},ref,Ratio_IMAonREAL,XYOutput);
    TrajPreRev{1} = cat(1,TrajPreRev{1},[Data(AlignedXtsd) Data(AlignedYtsd)]);
    end
end

%M913
for m=1:4
    load(['/media/vador/DataMOBS104/Marcelo/M913/20190521/SleepImport/ERC-Mouse-913-21052019-TestPre_0',num2str(m-1),'/cleanBehavResources'])
    if m==1
    [AlignedYtsd,AlignedXtsd,~,XYOutput] = MorphMazeToSingleShape_EmbReact_DB_MO(CleanYtsd,CleanXtsd,Zone{1},ref,Ratio_IMAonREAL);
    TrajPreSleep{2} = [Data(AlignedXtsd) Data(AlignedYtsd)]; 
    else
    [AlignedYtsd,AlignedXtsd,~,~] = MorphMazeToSingleShape_EmbReact_DB_MO(CleanYtsd,CleanXtsd,Zone{1},ref,Ratio_IMAonREAL,XYOutput);
    TrajPreSleep{2} = cat(1,TrajPreSleep{2},[Data(AlignedXtsd) Data(AlignedYtsd)]);
    end
end

for m=1:4
    load(['/media/vador/DataMOBS104/Marcelo/M913/20190521/SleepImport/ERC-Mouse-913-21052019-TestPost_0',num2str(m),'/cleanBehavResources'])
    if m==1
    [AlignedYtsd,AlignedXtsd,~,XYOutput] = MorphMazeToSingleShape_EmbReact_DB_MO(CleanYtsd,CleanXtsd,Zone{1},ref,Ratio_IMAonREAL);
    TrajPosSleep{2} = [Data(AlignedXtsd) Data(AlignedYtsd)];
    else
    [AlignedYtsd,AlignedXtsd,~,~] = MorphMazeToSingleShape_EmbReact_DB_MO(CleanYtsd,CleanXtsd,Zone{1},ref,Ratio_IMAonREAL,XYOutput);
    TrajPosSleep{2} = cat(1,TrajPosSleep{2},[Data(AlignedXtsd) Data(AlignedYtsd)]);    
    end
end

load(['/media/vador/DataMOBS104/Marcelo/M913/20190529/Reversal/ERC-Mouse-913-29052019-Hab_00/cleanBehavResources'])
[AlignedYtsd,AlignedXtsd,~,XYOutput] = MorphMazeToSingleShape_EmbReact_DB_MO(CleanYtsd,CleanXtsd,Zone{1},ref,Ratio_IMAonREAL);
HabRev{2} = [Data(AlignedXtsd) Data(AlignedYtsd)];

for m=1:4
    load(['/media/vador/DataMOBS104/Marcelo/M913/20190529/Reversal/ERC-Mouse-913-29052019-TestPre_0',num2str(m-1),'/cleanBehavResources'])
    if m==1
    [AlignedYtsd,AlignedXtsd,~,~] = MorphMazeToSingleShape_EmbReact_DB_MO(CleanYtsd,CleanXtsd,Zone{1},ref,Ratio_IMAonREAL);
    TrajPreRev{2} = [Data(AlignedXtsd) Data(AlignedYtsd)];
    else
    [AlignedYtsd,AlignedXtsd,~,~] = MorphMazeToSingleShape_EmbReact_DB_MO(CleanYtsd,CleanXtsd,Zone{1},ref,Ratio_IMAonREAL,XYOutput);
    TrajPreRev{2} = cat(1,TrajPreRev{2},[Data(AlignedXtsd) Data(AlignedYtsd)]);
    end
end

%M934
for m=1:4
    load(['/media/vador/DataMOBS104/Marcelo/M934/20190531/SleepImport/ERC-Mouse-934-31052019-TestPre_0',num2str(m-1),'/cleanBehavResources'])
    if m==1
    [AlignedYtsd,AlignedXtsd,~,XYOutput] = MorphMazeToSingleShape_EmbReact_DB_MO(CleanYtsd,CleanXtsd,Zone{1},ref,Ratio_IMAonREAL);
    TrajPreSleep{3} = [Data(AlignedXtsd) Data(AlignedYtsd)];
    else
    [AlignedYtsd,AlignedXtsd,~,~] = MorphMazeToSingleShape_EmbReact_DB_MO(CleanYtsd,CleanXtsd,Zone{1},ref,Ratio_IMAonREAL,XYOutput);
    TrajPreSleep{3} = cat(1,TrajPreSleep{3},[Data(AlignedXtsd) Data(AlignedYtsd)]);
   end
end

for m=1:4
    load(['/media/vador/DataMOBS104/Marcelo/M934/20190531/SleepImport/ERC-Mouse-934-31052019-TestPost_0',num2str(m),'/cleanBehavResources'])
    if m==1
    [AlignedYtsd,AlignedXtsd,~,XYOutput] = MorphMazeToSingleShape_EmbReact_DB_MO(CleanYtsd,CleanXtsd,Zone{1},ref,Ratio_IMAonREAL);
    TrajPosSleep{3} = [Data(AlignedXtsd) Data(AlignedYtsd)];
    else
    [AlignedYtsd,AlignedXtsd,~,~] = MorphMazeToSingleShape_EmbReact_DB_MO(CleanYtsd,CleanXtsd,Zone{1},ref,Ratio_IMAonREAL,XYOutput);
    TrajPosSleep{3} = cat(1,TrajPosSleep{3},[Data(AlignedXtsd) Data(AlignedYtsd)]);
    end
end

load(['/media/vador/DataMOBS104/Marcelo/M934/20190612/Reversal/ERC-Mouse-934-12062019-Hab_00/cleanBehavResources'])
[AlignedYtsd,AlignedXtsd,~,XYOutput] = MorphMazeToSingleShape_EmbReact_DB_MO(CleanYtsd,CleanXtsd,Zone{1},ref,Ratio_IMAonREAL);
HabRev{3} =[Data(AlignedXtsd) Data(AlignedYtsd)];

for m=1:4
    load(['/media/vador/DataMOBS104/Marcelo/M934/20190612/Reversal/ERC-Mouse-934-12062019-TestPre_0',num2str(m-1),'/cleanBehavResources'])
    if m==1
    [AlignedYtsd,AlignedXtsd,~,~] = MorphMazeToSingleShape_EmbReact_DB_MO(CleanYtsd,CleanXtsd,Zone{1},ref,Ratio_IMAonREAL,XYOutput);
    TrajPreRev{3} = [Data(AlignedXtsd) Data(AlignedYtsd)];
    else
    [AlignedYtsd,AlignedXtsd,~,~] = MorphMazeToSingleShape_EmbReact_DB_MO(CleanYtsd,CleanXtsd,Zone{1},ref,Ratio_IMAonREAL,XYOutput);
    TrajPreRev{3} = cat(1,TrajPreRev{3},[Data(AlignedXtsd) Data(AlignedYtsd)]);
    end
end

%M935
for m=1:4
    load(['/media/vador/DataMOBS104/Marcelo/M935/20190603/SleepImport/ERC-Mouse-935-03062019-TestPre_0',num2str(m-1),'/cleanBehavResources'])
    if m==1
    [AlignedYtsd,AlignedXtsd,~,XYOutput] = MorphMazeToSingleShape_EmbReact_DB_MO(CleanYtsd,CleanXtsd,Zone{1},ref,Ratio_IMAonREAL);
    TrajPreSleep{4} = [Data(AlignedXtsd) Data(AlignedYtsd)];
    else
    [AlignedYtsd,AlignedXtsd,~,~] = MorphMazeToSingleShape_EmbReact_DB_MO(CleanYtsd,CleanXtsd,Zone{1},ref,Ratio_IMAonREAL,XYOutput);
    TrajPreSleep{4} = cat(1,TrajPreSleep{4},[Data(AlignedXtsd) Data(AlignedYtsd)]);
    end
end

for m=1:4
    load(['/media/vador/DataMOBS104/Marcelo/M935/20190603/SleepImport/ERC-Mouse-935-03062019-TestPost_0',num2str(m),'/cleanBehavResources'])
    if m==1
    [AlignedYtsd,AlignedXtsd,~,XYOutput] = MorphMazeToSingleShape_EmbReact_DB_MO(CleanYtsd,CleanXtsd,Zone{1},ref,Ratio_IMAonREAL);
    TrajPosSleep{4} = [Data(AlignedXtsd) Data(AlignedYtsd)];
    else
    [AlignedYtsd,AlignedXtsd,~,~] = MorphMazeToSingleShape_EmbReact_DB_MO(CleanYtsd,CleanXtsd,Zone{1},ref,Ratio_IMAonREAL,XYOutput);
    TrajPosSleep{4} = cat(1,TrajPosSleep{4},[Data(AlignedXtsd) Data(AlignedYtsd)]);
    end
end

load(['/media/vador/DataMOBS104/Marcelo/M935/20160613/ReversalControl/ERC-Mouse-935-13062019-Hab_00/cleanBehavResources'])
[AlignedYtsd,AlignedXtsd,~,XYOutput] = MorphMazeToSingleShape_EmbReact_DB_MO(CleanYtsd,CleanXtsd,Zone{1},ref,Ratio_IMAonREAL);
HabRev{4} =[Data(AlignedXtsd) Data(AlignedYtsd)];

for m=1:4
    load(['/media/vador/DataMOBS104/Marcelo/M935/20160613/ReversalControl/ERC-Mouse-935-13062019-TestPre_0',num2str(m-1),'/cleanBehavResources'])
    if m==1
    [AlignedYtsd,AlignedXtsd,~,XYOutput] = MorphMazeToSingleShape_EmbReact_DB_MO(CleanYtsd,CleanXtsd,Zone{1},ref,Ratio_IMAonREAL,XYOutput);
    TrajPreRev{4} = [Data(AlignedXtsd) Data(AlignedYtsd)];
    else
    [AlignedYtsd,AlignedXtsd,~,~] = MorphMazeToSingleShape_EmbReact_DB_MO(CleanYtsd,CleanXtsd,Zone{1},ref,Ratio_IMAonREAL,XYOutput);
    TrajPreRev{4} = cat(1,TrajPreRev{4},[Data(AlignedXtsd) Data(AlignedYtsd)]);
    end
end

%M938
for m=1:4
    load(['/media/vador/DataMOBS104/Marcelo/M938/SleepImport/ERC-Mouse-938-06062019-TestPre_0',num2str(m-1),'/cleanBehavResources'])
    if m==1
    [AlignedYtsd,AlignedXtsd,~,XYOutput] = MorphMazeToSingleShape_EmbReact_DB_MO(CleanYtsd,CleanXtsd,Zone{1},ref,Ratio_IMAonREAL);
    TrajPreSleep{5} = [Data(AlignedXtsd) Data(AlignedYtsd)];
    else
    [AlignedYtsd,AlignedXtsd,~,~] = MorphMazeToSingleShape_EmbReact_DB_MO(CleanYtsd,CleanXtsd,Zone{1},ref,Ratio_IMAonREAL,XYOutput);
    TrajPreSleep{5} = cat(1,TrajPreSleep{5},[Data(AlignedXtsd) Data(AlignedYtsd)]);
    end
end

for m=1:4
    load(['/media/vador/DataMOBS104/Marcelo/M938/SleepImport/ERC-Mouse-938-06062019-TestPost_0',num2str(m),'/cleanBehavResources'])
    if m==1
    [AlignedYtsd,AlignedXtsd,~,XYOutput] = MorphMazeToSingleShape_EmbReact_DB_MO(CleanYtsd,CleanXtsd,Zone{1},ref,Ratio_IMAonREAL);
    TrajPosSleep{5} = [Data(AlignedXtsd) Data(AlignedYtsd)];
    else
    [AlignedYtsd,AlignedXtsd,~,~] = MorphMazeToSingleShape_EmbReact_DB_MO(CleanYtsd,CleanXtsd,Zone{1},ref,Ratio_IMAonREAL,XYOutput);
    TrajPosSleep{5} = cat(1,TrajPosSleep{5},[Data(AlignedXtsd) Data(AlignedYtsd)]);
    end
end

load(['/media/vador/DataMOBS104/Marcelo/M938/ReversalControl/ERC-Mouse-938-18062019-Hab_00/cleanBehavResources'])
[AlignedYtsd,AlignedXtsd,~,XYOutput] = MorphMazeToSingleShape_EmbReact_DB_MO(CleanYtsd,CleanXtsd,Zone{1},ref,Ratio_IMAonREAL);
HabRev{5} = [Data(AlignedXtsd) Data(AlignedYtsd)];

for m=1:4
    load(['/media/vador/DataMOBS104/Marcelo/M938/ReversalControl/ERC-Mouse-938-18062019-TestPre_0',num2str(m-1),'/cleanBehavResources'])
    if m==1
    [AlignedYtsd,AlignedXtsd,~,XYOutput] = MorphMazeToSingleShape_EmbReact_DB_MO(CleanYtsd,CleanXtsd,Zone{1},ref,Ratio_IMAonREAL,XYOutput);
    TrajPreRev{5} = [Data(AlignedXtsd) Data(AlignedYtsd)];
    else
    [AlignedYtsd,AlignedXtsd,~,~] = MorphMazeToSingleShape_EmbReact_DB_MO(CleanYtsd,CleanXtsd,Zone{1},ref,Ratio_IMAonREAL,XYOutput);
    TrajPreRev{5} = cat(1,TrajPreRev{5},[Data(AlignedXtsd) Data(AlignedYtsd)]);
    end
end

% save('/home/vador/Documents/Marcelo/Results/CompareSleepRev/CompareSleepRev.mat','TrajPreSleep','TrajPosSleep','HabRev','TrajPreRev')
%% Plot single mice
clear all
load('/home/vador/Documents/Marcelo/Results/CompareSleepRev/CompareSleepRev.mat')

Maze = [0 0 1 1 0.65 0.65 0.35 0.35 0;0 1 1 0 0 0.8 0.8 0 0]';


for i = 1:5
TrajPreSleep{i} = TrajPreSleep{i}(all(~isnan(TrajPreSleep{i}),2),:);
TrajPosSleep{i} = TrajPosSleep{i}(all(~isnan(TrajPosSleep{i}),2),:);
HabRev{i} = HabRev{i}(all(~isnan(HabRev{i}),2),:);
TrajPreRev{i} = TrajPreRev{i}(all(~isnan(TrajPreRev{i}),2),:);
zRange = [0,0.3]; 

figure
subplot(2,2,1)
[occH, x1, x2] = hist2(TrajPreSleep{i}(:,2), TrajPreSleep{i}(:,1), 240, 320);
        occHS(1:320,1:240) = SmoothDec(occH/15,[3,3]);
        x=x1;
        y=x2;
        
        imagesc(x1,x2,occHS)
        caxis(zRange) % control color intensity here
%         colormap(hot)
        set(gca, 'XTickLabel', []);
        set(gca, 'YTickLabel', []);
        set(gca, 'XTick', []);
        set(gca, 'YTick', []);
        set(gca, 'LineWidth', 2);
        hold on
        plot(Maze(:,1),Maze(:,2),'k','linewidth',2)
        
        title('Occupancy map Pre-tests - Sleep Importance');
        
subplot(2,2,2)
[occH, x1, x2] = hist2(TrajPosSleep{i}(:,2), TrajPosSleep{i}(:,1), 240, 320);
        occHS(1:320,1:240) = SmoothDec(occH/15,[3,3]);
        x=x1;
        y=x2;
        
        imagesc(x1,x2,occHS)
        caxis(zRange) % control color intensity here
%         colormap(hot)
        set(gca, 'XTickLabel', []);
        set(gca, 'YTickLabel', []);
        set(gca, 'XTick', []);
        set(gca, 'YTick', []);
        set(gca, 'LineWidth', 2);
        hold on
        plot(Maze(:,1),Maze(:,2),'k','linewidth',2)
        title('Occupancy map Post-tests - Sleep Importance');
        
subplot(2,2,3)
[occH, x1, x2] = hist2(HabRev{i}(:,2), HabRev{i}(:,1), 240, 320);
        occHS(1:320,1:240) = SmoothDec(occH/15,[3,3]);
        x=x1;
        y=x2;
        
        imagesc(x1,x2,occHS)
        caxis([zRange]) % control color intensity here
%         colormap(hot)
       set(gca, 'XTickLabel', []);
        set(gca, 'YTickLabel', []);
        set(gca, 'XTick', []);
        set(gca, 'YTick', []);
        set(gca, 'LineWidth', 2);
        hold on
        plot(Maze(:,1),Maze(:,2),'k','linewidth',2)
        title('Occupancy map Pre-explorations - Reversal');
        
subplot(2,2,4)
[occH, x1, x2] = hist2(TrajPreRev{i}(:,2), TrajPreRev{i}(:,1), 240, 320);
        occHS(1:320,1:240) = SmoothDec(occH/15,[3,3]);
        x=x1;
        y=x2;
        
        imagesc(x1,x2,occHS)
        caxis(zRange) % control color intensity here
%         colormap(hot)
        set(gca, 'XTickLabel', []);
        set(gca, 'YTickLabel', []);
        set(gca, 'XTick', []);
        set(gca, 'YTick', []);
        set(gca, 'LineWidth', 2);
        hold on
        plot(Maze(:,1),Maze(:,2),'k','linewidth',2)
        
        title('Occupancy map Pre-tests - Reversal');
        
end

%% Plot selected mice

clear all
load('/home/vador/Documents/Marcelo/Results/CompareSleepRev/CompareSleepRev.mat')


TrajPreSleepCat = [];
TrajPosSleepCat = [];
HabRevCat = [];
TrajPreRevCat = [];

Maze = [0 0 1 1 0.65 0.65 0.35 0.35 0;0 1 1 0 0 0.8 0.8 0 0]';


MiceToUse = [2 3 4 5];


for i = MiceToUse
    TrajPreSleepCat = cat(1,TrajPreSleepCat,TrajPreSleep{i});
    TrajPosSleepCat = cat(1,TrajPosSleepCat,TrajPosSleep{i});
    HabRevCat = cat(1,HabRevCat,HabRev{i});
    TrajPreRevCat = cat(1,TrajPreRevCat,TrajPreRev{i});
end

TrajPreSleepCat = TrajPreSleepCat(all(~isnan(TrajPreSleepCat),2),:);
TrajPosSleepCat = TrajPosSleepCat(all(~isnan(TrajPosSleepCat),2),:);
HabRevCat = HabRevCat(all(~isnan(HabRevCat),2),:);
TrajPreRevCat = TrajPreRevCat(all(~isnan(TrajPreRevCat),2),:);

zRange = [0,0.1]; 

figure
subplot(2,2,1)
[occH, x1, x2] = hist2(TrajPreSleepCat(:,2), TrajPreSleepCat(:,1), 240, 320);
        occHS(1:320,1:240) = SmoothDec(occH/15,[3,3]);
        x=x1;
        y=x2;
        
        imagesc(x1,x2,occHS)
        caxis(zRange) % control color intensity here
%          colormap(hot)
        set(gca, 'XTickLabel', []);
        set(gca, 'YTickLabel', []);
        set(gca, 'XTick', []);
        set(gca, 'YTick', []);
        set(gca, 'LineWidth', 2);
        hold on
        plot(Maze(:,1),Maze(:,2),'k','linewidth',2)
        
        title('Occupancy map Pre-tests - Sleep Importance');
        
subplot(2,2,2)
[occH, x1, x2] = hist2(TrajPosSleepCat(:,2), TrajPosSleepCat(:,1), 240, 320);
        occHS(1:320,1:240) = SmoothDec(occH/15,[3,3]);
        x=x1;
        y=x2;
        
        imagesc(x1,x2,occHS)
        caxis(zRange) % control color intensity here
%         colormap(hot)
       set(gca, 'XTickLabel', []);
        set(gca, 'YTickLabel', []);
        set(gca, 'XTick', []);
        set(gca, 'YTick', []);
        set(gca, 'LineWidth', 2);
        hold on
        plot(Maze(:,1),Maze(:,2),'k','linewidth',2)
        
        title('Occupancy map Post-tests - Sleep Importance');
        
subplot(2,2,3)
[occH, x1, x2] = hist2(HabRevCat(:,2), HabRevCat(:,1), 240, 320);
        occHS(1:320,1:240) = SmoothDec(occH/15,[3,3]);
        x=x1;
        y=x2;
        
        imagesc(x1,x2,occHS)
        caxis([zRange]) % control color intensity here
%         colormap(hot)
        set(gca, 'XTickLabel', []);
        set(gca, 'YTickLabel', []);
        set(gca, 'XTick', []);
        set(gca, 'YTick', []);
        set(gca, 'LineWidth', 2);
        hold on
        plot(Maze(:,1),Maze(:,2),'k','linewidth',2)
        
        title('Occupancy map Pre-explorations - Reversal');
        
subplot(2,2,4)
[occH, x1, x2] = hist2(TrajPreRevCat(:,2), TrajPreRevCat(:,1), 240, 320);
        occHS(1:320,1:240) = SmoothDec(occH/15,[3,3]);
        x=x1;
        y=x2;
        
        imagesc(x1,x2,occHS)
        caxis(zRange) % control color intensity here
%         colormap(hot)
        set(gca, 'XTickLabel', []);
        set(gca, 'YTickLabel', []);
        set(gca, 'XTick', []);
        set(gca, 'YTick', []);
        set(gca, 'LineWidth', 2);
        hold on
        plot(Maze(:,1),Maze(:,2),'k','linewidth',2)
        
        title('Occupancy map Pre-tests - Reversal');
        