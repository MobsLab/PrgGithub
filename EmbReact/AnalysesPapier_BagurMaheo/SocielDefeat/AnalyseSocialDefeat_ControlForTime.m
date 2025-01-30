clear all
[Dir_CD1_CD1cage,Dir_CD1_C57cage,Dir_Sleep_CD1InCage,Dir_Sleep_CD1NOTInCage,Dir_Sleep_Ctrl,...
    Info_CD1_CD1cage,Info_CD1_C57cage,Info_Sleep_CD1InCage,Info_Sleep_CD1NOTInCage,Info_Sleep_Ctrl] = Get_SD_Path_UmazeComp;

%% need to add baseline mice to see if they are freezing more or less than after SDS
AllDir = {Dir_CD1_CD1cage,Dir_CD1_C57cage,Dir_Sleep_CD1InCage,Dir_Sleep_CD1NOTInCage,Dir_Sleep_Ctrl};
Allinfo = {Info_CD1_CD1cage,Info_CD1_C57cage,Info_Sleep_CD1InCage,Info_Sleep_CD1NOTInCage,Info_Sleep_Ctrl};
GroupNames = {'CD1_Exp','C57_Exp','C57_Sleep','CD1_Sleep','Ctrl_Sleep'};

%% Get data SDS mice
clear Data
for dirnum  = 1:2
    mouse_num = 1;
    for dd = 1:length(AllDir{dirnum})
        for ddd = 1:length(AllDir{dirnum}{dd}.path)
            ddd
            % Get data
                TempData = GetBreathingStartEndFromDir_SDS_UmazeComp(AllDir{dirnum}{dd}.path{ddd}{1});
            Fields = fieldnames(TempData);
            % Reorganize
            try
                Data.(GroupNames{dirnum}).MouseId(mouse_num) = AllDir{dirnum}{dd}.nMice{ddd};
            catch
                Data.(GroupNames{dirnum}).MouseId(mouse_num) =  eval(Dir_Sleep_Ctrl{dd}.name{ddd}(6:end));
            end
            Data.(GroupNames{dirnum}).FileLoc{mouse_num} = AllDir{dirnum}{dd}.path{ddd}{1};
            Data.(GroupNames{dirnum}).AllSpec_Lo1(mouse_num,:) = TempData.OBSpec_Lo1;
            Data.(GroupNames{dirnum}).AllSpec_Lo2(mouse_num,:) = TempData.OBSpec_Lo2;
            Data.(GroupNames{dirnum}).FzTime1(mouse_num) = TempData.FzTime1;
            Data.(GroupNames{dirnum}).FzTime2(mouse_num) = TempData.FzTime2;
            mouse_num = mouse_num+1;
        end
    end
end


%Get the OB peaks manually
fLow = [1+0.076:0.076:20-0.076];
for dirnum  = 1:2
    for mouse_num = 1:size(Data.(GroupNames{dirnum}).AllSpec_Lo1,1)
        if Data.(GroupNames{dirnum}).FzTime1(mouse_num)>0
            % first half
            plot(fLow,Data.(GroupNames{dirnum}).AllSpec_Lo1(mouse_num,:)),
            title(num2str(Data.(GroupNames{dirnum}).FzTime1(mouse_num)))
            xlim([0 20])
            hold on
            [Data.(GroupNames{dirnum}).OBFreq(mouse_num,1),y] = ginput(1);
            if Data.(GroupNames{dirnum}).OBFreq(mouse_num,1)<0.5
                Data.(GroupNames{dirnum}).OBFreq(mouse_num,1) = NaN;
            end
            clf
        else
            
        end
        if Data.(GroupNames{dirnum}).FzTime2(mouse_num)>0
            
            % second half
            plot(fLow,Data.(GroupNames{dirnum}).AllSpec_Lo2(mouse_num,:)),
            title(num2str(Data.(GroupNames{dirnum}).FzTime2(mouse_num)))
            xlim([0 20])
            hold on
            [Data.(GroupNames{dirnum}).OBFreq(mouse_num,2),y] = ginput(1);
            if Data.(GroupNames{dirnum}).OBFreq(mouse_num,2)<0.5
                Data.(GroupNames{dirnum}).OBFreq(mouse_num,2) = NaN;
            end
            clf
        end
    end
end


A{1} =  Data.(GroupNames{1}).OBFreq(:,1);
A{1}(A{1}==0) = NaN;
A{2} =  Data.(GroupNames{1}).OBFreq(:,2);
A{2}(A{2}==0) = NaN;
A{3} =  Data.(GroupNames{2}).OBFreq(:,1);
A{3}(A{3}==0) = NaN;
A{4} =  Data.(GroupNames{2}).OBFreq(:,2);
A{4}(A{4}==0) = NaN;

Cols = {[1,0.4,0.4],[1,0.4,0.4]*0.8,[0.4,0,0.8],[0.4,0,0.8]*0.8};

MakeSpreadAndBoxPlot2_SB(A,Cols,[1:4],...
    {'CD1_Exp early','CD1_Exp late','C57_Exp early','C57_Exp late'},'showsigstar','all','paired',0)
ylim([0 8])
ylabel('mean OB freq')
makepretty
title('all mice')

% Only mie that froze in both cases - paired statistics
matchedmice = 1;
for mm = 1 :size(Data.CD1_Exp.OBFreq,1)
    
    matched_C57_mouse = find(Data.C57_Exp.MouseId==Data.CD1_Exp.MouseId(mm),1,'last');
    if not(isempty(matched_C57_mouse))
        Freqmatched(1,matchedmice) = Data.CD1_Exp.OBFreq(mm,1);
        Freqmatched(2,matchedmice) = Data.CD1_Exp.OBFreq(mm,2);
        Freqmatched(3,matchedmice) = Data.C57_Exp.OBFreq(matched_C57_mouse,1);
        Freqmatched(4,matchedmice) = Data.C57_Exp.OBFreq(matched_C57_mouse,2);
        matchedmice = matchedmice+1;
    end
end

All = [A{1};A{2};A{3};A{4}];

Freqmatched(Freqmatched==0) = NaN;
MakeSpreadAndBoxPlot2_SB(num2cell(Freqmatched,2),Cols,[1:4],...
    {'CD1_Exp early','CD1_Exp late','C57_Exp early','C57_Exp late'},'showsigstar','all','paired',0)
ylim([0 8])
plot(Freqmatched,'color',[0.6 0.6 0.6])
ylabel('mean OB freq')
makepretty


% Only mie that froze in both hlaves
figure
subplot(131)
clear A
A{1} =  Data.(GroupNames{1}).OBFreq(:,1);
A{1}(A{1}==0) = NaN;
A{2} =  Data.(GroupNames{1}).OBFreq(:,2);
A{2}(A{2}==0) = NaN;
GoodGuys = find(A{1}>0 & A{2}>0);
A{1} = A{1}(GoodGuys);
A{2} = A{2}(GoodGuys);
MakeSpreadAndBoxPlot2_SB(A,Cols(1:2),[1:2],...
    {'CD1_Exp early','CD1_Exp late'},'showsigstar','all','paired',1)
title('mice freezing in both halves of CD1 session')
ylim([1 7])

subplot(132)
clear A
A{1} =  Data.(GroupNames{2}).OBFreq(:,1);
A{1}(A{1}==0) = NaN;
A{2} =  Data.(GroupNames{2}).OBFreq(:,2);
A{2}(A{2}==0) = NaN;
GoodGuys = find(A{1}>0 & A{2}>0);
A{1} = A{1}(GoodGuys);
A{2} = A{2}(GoodGuys);
MakeSpreadAndBoxPlot2_SB(A,Cols(3:4),[1:2],...
    {'C57_Exp early','C57_Exp late'},'showsigstar','all','paired',1)
title('mice freezing in both halves of C57 session')
ylim([1 7])

subplot(133)
clear A
A{1} =  Freqmatched(2,:);
A{1}(A{1}==0) = NaN;
A{2} =  Freqmatched(3,:);
A{2}(A{2}==0) = NaN;
GoodGuys = find(A{1}>0 & A{2}>0);
A{1} = A{1}(GoodGuys);
A{2} = A{2}(GoodGuys);
MakeSpreadAndBoxPlot2_SB(A,Cols([2,3]),[1:2],...
    {'CD1_Exp late','C57_Exp early'},'showsigstar','all','paired',1)
title('mice freezing at end CD1 and beg C57')
ylim([1 7])

