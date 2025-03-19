%% Get Data (not necessary if alligned data is already saved in AverageDensityMap.mat)

clear all
TrajPre = [];
TrajPosPAG = [];
TrajPosMFB = [];

%M863

for m=1:4
    load(['/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-TestPre_0',num2str(m-1),'/cleanBehavResources'])
    if m==1
    [AlignedYtsd,AlignedXtsd,~,XYOutput] = MorphMazeToSingleShape_EmbReact_DB_MO(CleanYtsd,CleanXtsd,Zone{1},ref,Ratio_IMAonREAL);
    TrajPre{1} = [Data(AlignedXtsd) Data(AlignedYtsd)]; 
    else
    [AlignedYtsd,AlignedXtsd,~,~] = MorphMazeToSingleShape_EmbReact_DB_MO(CleanYtsd,CleanXtsd,Zone{1},ref,Ratio_IMAonREAL,XYOutput);
    TrajPre{1} = cat(1,TrajPre{1},[Data(AlignedXtsd) Data(AlignedYtsd)]);
    end
end

for m=1:4
    load(['/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-TestPost_0',num2str(m-1),'/cleanBehavResources'])
    if m==1
    [AlignedYtsd,AlignedXtsd,~,XYOutput] = MorphMazeToSingleShape_EmbReact_DB_MO(CleanYtsd,CleanXtsd,Zone{1},ref,Ratio_IMAonREAL);
    TrajPosPAG{1} = [Data(AlignedXtsd) Data(AlignedYtsd)]; 
    else
    [AlignedYtsd,AlignedXtsd,~,~] = MorphMazeToSingleShape_EmbReact_DB_MO(CleanYtsd,CleanXtsd,Zone{1},ref,Ratio_IMAonREAL,XYOutput);
    TrajPosPAG{1} = cat(1,TrajPosPAG{1},[Data(AlignedXtsd) Data(AlignedYtsd)]);
    end
end

for m=1:4
    load(['/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-TestPost_0',num2str(m+3),'/cleanBehavResources'])
    if m==1
    [AlignedYtsd,AlignedXtsd,~,XYOutput] = MorphMazeToSingleShape_EmbReact_DB_MO(CleanYtsd,CleanXtsd,Zone{1},ref,Ratio_IMAonREAL);
    TrajPosMFB{1} = [Data(AlignedXtsd) Data(AlignedYtsd)]; 
    else
    [AlignedYtsd,AlignedXtsd,~,~] = MorphMazeToSingleShape_EmbReact_DB_MO(CleanYtsd,CleanXtsd,Zone{1},ref,Ratio_IMAonREAL,XYOutput);
    TrajPosMFB{1} = cat(1,TrajPosMFB{1},[Data(AlignedXtsd) Data(AlignedYtsd)]);
    end
end

%M913

for m=1:4
    load(['/media/vador/DataMOBS104/Marcelo/M913/20190529/Reversal/ERC-Mouse-913-29052019-TestPre_0',num2str(m-1),'/cleanBehavResources'])
    if m==1
    [AlignedYtsd,AlignedXtsd,~,XYOutput] = MorphMazeToSingleShape_EmbReact_DB_MO(CleanYtsd,CleanXtsd,Zone{1},ref,Ratio_IMAonREAL);
    TrajPre{2} = [Data(AlignedXtsd) Data(AlignedYtsd)];
    else
    [AlignedYtsd,AlignedXtsd,~,~] = MorphMazeToSingleShape_EmbReact_DB_MO(CleanYtsd,CleanXtsd,Zone{1},ref,Ratio_IMAonREAL,XYOutput);
    TrajPre{2} = cat(1,TrajPre{2},[Data(AlignedXtsd) Data(AlignedYtsd)]);
    end
end

for m=1:4
    load(['/media/vador/DataMOBS104/Marcelo/M913/20190529/Reversal/ERC-Mouse-913-29052019-TestPost_0',num2str(m-1),'/cleanBehavResources'])
    if m==1
    [AlignedYtsd,AlignedXtsd,~,XYOutput] = MorphMazeToSingleShape_EmbReact_DB_MO(CleanYtsd,CleanXtsd,Zone{1},ref,Ratio_IMAonREAL);
    TrajPosPAG{2} = [Data(AlignedXtsd) Data(AlignedYtsd)];
    else
    [AlignedYtsd,AlignedXtsd,~,~] = MorphMazeToSingleShape_EmbReact_DB_MO(CleanYtsd,CleanXtsd,Zone{1},ref,Ratio_IMAonREAL,XYOutput);
    TrajPosPAG{2} = cat(1,TrajPosPAG{2},[Data(AlignedXtsd) Data(AlignedYtsd)]);
    end
end

for m=1:4
    load(['/media/vador/DataMOBS104/Marcelo/M913/20190529/Reversal/ERC-Mouse-913-29052019-TestPost_0',num2str(m+3),'/cleanBehavResources'])
    if m==1
    [AlignedYtsd,AlignedXtsd,~,XYOutput] = MorphMazeToSingleShape_EmbReact_DB_MO(CleanYtsd,CleanXtsd,Zone{1},ref,Ratio_IMAonREAL);
    TrajPosMFB{2} = [Data(AlignedXtsd) Data(AlignedYtsd)];
    else
    [AlignedYtsd,AlignedXtsd,~,~] = MorphMazeToSingleShape_EmbReact_DB_MO(CleanYtsd,CleanXtsd,Zone{1},ref,Ratio_IMAonREAL,XYOutput);
    TrajPosMFB{2} = cat(1,TrajPosMFB{2},[Data(AlignedXtsd) Data(AlignedYtsd)]);
    end
end

%M934

for m=1:4
    load(['/media/vador/DataMOBS104/Marcelo/M934/20190612/Reversal/ERC-Mouse-934-12062019-TestPre_0',num2str(m-1),'/cleanBehavResources'])
    if m==1
    [AlignedYtsd,AlignedXtsd,~,XYOutput] = MorphMazeToSingleShape_EmbReact_DB_MO(CleanYtsd,CleanXtsd,Zone{1},ref,Ratio_IMAonREAL);
    TrajPre{3} = [Data(AlignedXtsd) Data(AlignedYtsd)];
    else
    [AlignedYtsd,AlignedXtsd,~,~] = MorphMazeToSingleShape_EmbReact_DB_MO(CleanYtsd,CleanXtsd,Zone{1},ref,Ratio_IMAonREAL,XYOutput);
    TrajPre{3} = cat(1,TrajPre{3},[Data(AlignedXtsd) Data(AlignedYtsd)]);
    end
end

for m=1:4
    load(['/media/vador/DataMOBS104/Marcelo/M934/20190612/Reversal/ERC-Mouse-934-12062019-TestPost_0',num2str(m-1),'/cleanBehavResources'])
    if m==1
    [AlignedYtsd,AlignedXtsd,~,XYOutput] = MorphMazeToSingleShape_EmbReact_DB_MO(CleanYtsd,CleanXtsd,Zone{1},ref,Ratio_IMAonREAL);
    TrajPosPAG{3} = [Data(AlignedXtsd) Data(AlignedYtsd)];
    else
    [AlignedYtsd,AlignedXtsd,~,~] = MorphMazeToSingleShape_EmbReact_DB_MO(CleanYtsd,CleanXtsd,Zone{1},ref,Ratio_IMAonREAL,XYOutput);
    TrajPosPAG{3} = cat(1,TrajPosPAG{3},[Data(AlignedXtsd) Data(AlignedYtsd)]);
    end
end

for m=1:4
    load(['/media/vador/DataMOBS104/Marcelo/M934/20190612/Reversal/ERC-Mouse-934-12062019-TestPost_0',num2str(m+3),'/cleanBehavResources'])
    if m==1
    [AlignedYtsd,AlignedXtsd,~,XYOutput] = MorphMazeToSingleShape_EmbReact_DB_MO(CleanYtsd,CleanXtsd,Zone{1},ref,Ratio_IMAonREAL);
    TrajPosMFB{3} = [Data(AlignedXtsd) Data(AlignedYtsd)];
    else
    [AlignedYtsd,AlignedXtsd,~,~] = MorphMazeToSingleShape_EmbReact_DB_MO(CleanYtsd,CleanXtsd,Zone{1},ref,Ratio_IMAonREAL,XYOutput);
    TrajPosMFB{3} = cat(1,TrajPosMFB{3},[Data(AlignedXtsd) Data(AlignedYtsd)]);
    end
end

% save('/home/vador/Documents/Marcelo/Results/Reversal/Averages/AverageDensityMap.mat','TrajPre','TrajPosPAG','TrajPosMFB')

%% Plot
clear all
load('/home/vador/Documents/Marcelo/Results/Reversal/Averages/AverageDensityMap.mat')

TrajPreCat = [];
TrajPosPAGCat = [];
TrajPosMFBCat = [];

MiceToUse = [1 2 3];


for i = MiceToUse
    TrajPreCat = cat(1,TrajPreCat,TrajPre{i});
    TrajPosPAGCat = cat(1,TrajPosPAGCat,TrajPosPAG{i});
    TrajPosMFBCat = cat(1,TrajPosMFBCat,TrajPosMFB{i});
end

TrajPreCat = TrajPreCat(all(~isnan(TrajPreCat),2),:);
TrajPosPAGCat = TrajPosPAGCat(all(~isnan(TrajPosPAGCat),2),:);
TrajPosMFBCat = TrajPosMFBCat(all(~isnan(TrajPosMFBCat),2),:);

zRange = [0,0.1];
Maze = [0 0 1 1 0.65 0.65 0.35 0.35 0;0 1 1 0 0 0.8 0.8 0 0]';

figure
subplot(1,3,1)
[occH, x1, x2] = hist2(TrajPreCat(:,2), TrajPreCat(:,1), 240, 320);
        occHS(1:320,1:240) = SmoothDec(occH/15,[3,3]);
        x=x1;
        y=x2;
        
        imagesc(x1,x2,occHS)
        caxis(zRange) % control color intensity here
        colormap(hot)
        set(gca, 'XTickLabel', []);
        set(gca, 'YTickLabel', []);
        set(gca, 'XTick', []);
        set(gca, 'YTick', []);
        set(gca, 'LineWidth', 2);
        hold on
        plot(Maze(:,1),Maze(:,2),'k','linewidth',2)
        title('Occupancy map Pre-tests');
        
subplot(1,3,2)
[occH, x1, x2] = hist2(TrajPosPAGCat(:,2), TrajPosPAGCat(:,1), 240, 320);
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
        title('Occupancy map Post-PAG tests');
        
subplot(1,3,3)
[occH, x1, x2] = hist2(TrajPosMFBCat(:,2), TrajPosMFBCat(:,1), 240, 320);
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
        title('Occupancy map Post-MFB tests');
        