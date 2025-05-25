
%% CH way

clear all, close all

cd('/media/nas6/ProjetEmbReact/transfer')
load('Sess.mat')
Mouse_names={'M1713'}; mouse=1;
Hab_24_Sess = find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Habituation24H'))));
HabSess = find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Habituation_P'))));
HabBlockedShockSess = find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'HabituationBlockedShock'))));
TestPreSess = find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'TestPre'))));
TestPostPreSess = find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'TestPost_Pre'))));
TestPostPostSess = find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'TestPost_Post'))));


for cond = 1:6
    if cond==1
        start=Hab_24_Sess(1); stop=HabSess(1)-1;
    elseif cond==2
        start=HabSess(1); stop=HabBlockedShockSess(1)-1;
    elseif cond==3
        start=HabBlockedShockSess(1); stop=TestPreSess(1)-1;
    elseif cond==4
        start=TestPreSess(1); stop=TestPostPreSess(1)-1;
    elseif cond==5
        start=TestPostPreSess(1); stop=TestPostPostSess(1)-1;
    elseif cond==6
        start=TestPostPostSess(1); stop=length(Sess.(Mouse_names{mouse}));
    end
    
    for f=start:stop
        
        cd(Sess.(Mouse_names{mouse}){f})
        
        load('ExpeInfo.mat')
        if ExpeInfo.SleepSession==0
            
            clear Behav Params Results TTLInfo
            load('behavResources_SB.mat')
            
            if not(isfield(Behav,'LinearDist'))
                if f==start|not(exist('curvexy'))
                    BW=double(bwperim(Params.Zone{1}));
                    imagesc(double(Params.ref)+BW/10)
                    hold on
                    plot(Data(Behav.Xtsd)/Params.pixratio,Data(Behav.Ytsd)/Params.pixratio,'w')
                    title('click on the maze, start with shock')
                    curvexy=ginput(4);
                    title('click on door position, start with shock')
                    doorxy=ginput(2);
                    clf
                end
                
                mapxy=[Data(Behav.Xtsd)';Data(Behav.Ytsd)']';
                [xy,distance,t] = distance2curve(curvexy,mapxy/Params.pixratio,'linear');
                [xybis,distancebis,tbis] = distance2curve(curvexy,doorxy,'linear');
                
                Behav.LinearDist=tsd(Range(Behav.Xtsd),t);
                Params.DoorPos=tbis;
                disp(cd)
                subplot(211)
                imagesc(Params.mask+Params.Zone{1})
                hold on
                plot(Data(Behav.Xtsd)/Params.pixratio,Data(Behav.Ytsd)/Params.pixratio)
                subplot(212)
                plot(t), ylim([0 1]), hold on
                line(xlim,[1 1]*tbis(1))
                line(xlim,[1 1]*tbis(2))
                
                keyboard
                
                clf
                save('behavResources_SB.mat','Behav','Params','-append')
                clear Behav Params TTLInfo Results t xy distance mapxy xybis distancebis tbis
            
            end
        end
    end
end



%% BM way

clear all

cd('/media/nas6/ProjetEmbReact/transfer')
load('Sess.mat')
Mouse_names={'M1594'}; mouse=1;
Hab_24_Sess = find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Habituation24H'))));
HabSess = find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Habituation_'))));
HabBlockedShockSess = find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'HabituationBlockedShock'))));
TestPreSess = find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'TestPre'))));
TestPostSess = find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'TestPost'))));


for cond = 1:5
        if cond==1
            start=Hab_24_Sess(1); stop=HabSess(1)-1;
        elseif cond==2
            start=HabSess(1); stop=HabBlockedShockSess(1)-1;
        elseif cond==3
            start=HabBlockedShockSess(1); stop=TestPreSess(1)-1;
        elseif cond==4
            start=TestPreSess(1); stop=TestPostSess(1)-1;
        elseif cond==5
            start=TestPostSess(1); stop=length(Sess.(Mouse_names{mouse}));
        end
    
%     if cond==1
%         start=Hab_24_Sess(1); stop=HabSess(1)-1;
%     elseif cond==2
%         start=HabSess(1); stop=HabBlockedShockSess(1)-1;
%     elseif cond==3
%         start=HabBlockedShockSess(1); stop=TestPreSess(1)-2;
%     elseif cond==4
%         start=TestPreSess(1); stop=length(Sess.(Mouse_names{mouse}));
%     end
    
    for f=start:stop
        
        cd(Sess.(Mouse_names{mouse}){f})
        
        load('ExpeInfo.mat')
        if ExpeInfo.SleepSession==0
            
            clear Behav Params Results TTLInfo
            load('behavResources_SB.mat')
            
            if not(isfield(Behav,'LinearDist'))
                if f==start
                    BW=double(bwperim(Params.Zone{1}));
                    imagesc(double(Params.ref)+BW/10)
                    hold on
                    plot(Data(Behav.Xtsd)/Params.pixratio,Data(Behav.Ytsd)/Params.pixratio,'w')
                    title('click on the maze, start with shock')
                    curvexy=ginput(4);
                    title('click on door position, start with shock')
                    doorxy=ginput(2);
                    clf
                end
                
                mapxy=[Data(Behav.Xtsd)';Data(Behav.Ytsd)']';
                [xy,distance,t] = distance2curve(curvexy,mapxy/Params.pixratio,'linear');
                [xybis,distancebis,tbis] = distance2curve(curvexy,doorxy,'linear');
                Behav.LinearDist=tsd(Range(Behav.Xtsd),t);
                Params.DoorPos=tbis;
                disp(cd)
                subplot(211)
                imagesc(Params.mask+Params.Zone{1})
                hold on
                plot(Data(Behav.Xtsd)/Params.pixratio,Data(Behav.Ytsd)/Params.pixratio)
                subplot(212)
                plot(t), ylim([0 1]), hold on
                line(xlim,[1 1]*tbis(1))
                line(xlim,[1 1]*tbis(2))
                
                keyboard
                
                clf
                save('behavResources_SB.mat','Behav','Params','-append')
                clear Behav Params TTLInfo Results t xy distance mapxy xybis distancebis tbis
            
            end
        end
    end
end



%% SB way

figure
clear all

% SessNames={  'Habituation_EyeShockTempProt' 'TestPre_EyeShockTempProt' 'WallHabSafe_EyeShockTempProt' 'WallHabShock_EyeShockTempProt' 'WallCondShock_EyeShockTempProt' 'WallCondSafe_EyeShockTempProt' ,...
%     'TestPost_EyeShockTempProt' 'WallExtShock_EyeShockTempProt' 'WallExtSafe_EyeShockTempProt'};


%%%'Habituation24HPre_EyeShock','Habituation_EyeShock','HabituationBlockedSafe_EyeShock','HabituationBlockedShock_EyeShock',...
%'TestPre_EyeShock','UMazeCond_EyeShock','UMazeCondBlockedShock_EyeShock','UMazeCondBlockedSafe_EyeShock',...
%'TestPost_EyeShock','Extinction_EyeShock','ExtinctionBlockedShock_EyeShock','ExtinctionBlockedSafe_EyeShock'};
%
SessNames={'Habituation24HPre_PreDrug' 'Habituation_PreDrug' 'HabituationBlockedShock_PreDrug' 'HabituationBlockedSafe_PreDrug',...
    'TestPre_PreDrug' 'UMazeCondExplo_PreDrug' 'UMazeCondBlockedShock_PreDrug' 'UMazeCondBlockedSafe_PreDrug' ...
    'UMazeCondExplo_PostDrug' 'UMazeCondBlockedShock_PostDrug' 'UMazeCondBlockedSafe_PostDrug',...
    'TestPost_PostDrug'  'ExtinctionBlockedShock_PostDrug' 'ExtinctionBlockedSafe_PostDrug'};

% SessNames={'Habituation24HPre_PreDrug' 'Habituation_PreDrug' 'HabituationBlockedShock_PreDrug' 'HabituationBlockedSafe_PreDrug',...
%     'TestPre_PreDrug' 'UMazeCondExplo_PostDrug' 'UMazeCondBlockedShock_PostDrug' 'UMazeCondBlockedSafe_PostDrug',...
%     'TestPost_PostDrug'  'ExtinctionBlockedShock_PostDrug' 'ExtinctionBlockedSafe_PostDrug'};

% SessNames={'HabituationBlockedShock_PreDrug' 'HabituationBlockedSafe_PreDrug',...
%     'UMazeCondBlockedShock_PostDrug' 'UMazeCondBlockedSafe_PostDrug',...
%     'ExtinctionBlockedShock_PostDrug' 'ExtinctionBlockedSafe_PostDrug'};


MouseNameToDo = [1224 1225 1226 1127 11225 11226 1251 1253 1254 11251 11252 11253 11254];

for ss=1:length(SessNames)
    Dir=PathForExperimentsEmbReact(SessNames{ss});
    MouseToAvoid=[117,431]; % mice with noisy data to exclude
    Dir=RemoveElementsFromDir(Dir,'nmouse',MouseToAvoid);
    disp(SessNames{ss})
    for d=1:length(Dir.path)
        TotTime=0;TotFz=0;TotStims=0;
        if sum(ismember(MouseNameToDo,Dir.ExpeInfo{d}{1}.nmouse))
            %         disp(MouseName{ss,d})
            for dd=1:length(Dir.path{d})
                cd(Dir.path{d}{dd})
                clear Behav Params Results TTLInfo
                load('behavResources_SB.mat')
                if not(isfield(Behav,'LinearDist'))
                    if dd==1
                        BW=double(bwperim(Params.Zone{1}));
                        imagesc(double(Params.ref)+BW/10)
                        hold on
                        plot(Data(Behav.Xtsd)/Params.pixratio,Data(Behav.Ytsd)/Params.pixratio,'w')
                        title('click on the maze, start with shock')
                        curvexy=ginput(4);
                        title('click on door position, start with shock')
                        doorxy=ginput(2);
                        clf
                    end
                    
                    mapxy=[Data(Behav.Xtsd)';Data(Behav.Ytsd)']';
                    [xy,distance,t] = distance2curve(curvexy,mapxy/Params.pixratio,'linear');
                    [xybis,distancebis,tbis] = distance2curve(curvexy,doorxy,'linear');
                    
                    Behav.LinearDist=tsd(Range(Behav.Xtsd),t);
                    Params.DoorPos=tbis;
                    subplot(211)
                    imagesc(Params.mask+Params.Zone{1})
                    hold on
                    plot(Data(Behav.Xtsd)/Params.pixratio,Data(Behav.Ytsd)/Params.pixratio)
                    subplot(212)
                    plot(t), ylim([0 1]), hold on
                    line(xlim,[1 1]*tbis(1))
                    line(xlim,[1 1]*tbis(2))
                    keyboard
                    clf
                    save('behavResources_SB.mat','Behav','Params','-append')
                    %                 end
                    clear Behav Params TTLInfo Results t xy distance mapxy xybis distancebis tbis
                end
            end
        end
    end
end
%
% figure
% clear all
%
% % SessNames={  'Habituation_EyeShockTempProt' 'TestPre_EyeShockTempProt' 'WallHabSafe_EyeShockTempProt' 'WallHabShock_EyeShockTempProt' 'WallCondShock_EyeShockTempProt' 'WallCondSafe_EyeShockTempProt' ,...
% %     'TestPost_EyeShockTempProt' 'WallExtShock_EyeShockTempProt' 'WallExtSafe_EyeShockTempProt'};
%
%
% %%%'Habituation24HPre_EyeShock','Habituation_EyeShock','HabituationBlockedSafe_EyeShock','HabituationBlockedShock_EyeShock',...
% %'TestPre_EyeShock','UMazeCond_EyeShock','UMazeCondBlockedShock_EyeShock','UMazeCondBlockedSafe_EyeShock',...
% %'TestPost_EyeShock','Extinction_EyeShock','ExtinctionBlockedShock_EyeShock','ExtinctionBlockedSafe_EyeShock'};
%
% SessNames={'Habituation24HPre_PreDrug' 'Habituation_PreDrug' 'HabituationBlockedShock_PreDrug' 'HabituationBlockedSafe_PreDrug',...
%     'TestPre_PreDrug' 'UMazeCondExplo_PreDrug' 'UMazeCondBlockedShock_PreDrug' 'UMazeCondBlockedSafe_PreDrug' ...
%     'UMazeCondExplo_PostDrug' 'UMazeCondBlockedShock_PostDrug' 'UMazeCondBlockedSafe_PostDrug',...
%     'TestPost_PostDrug'  'ExtinctionBlockedShock_PostDrug' 'ExtinctionBlockedSafe_PostDrug'};
%
% MouseNameToDo = 859;
%
% for ss=1:length(SessNames)
%     Dir=PathForExperimentsEmbReact(SessNames{ss});
%     MouseToAvoid=[117,431]; % mice with noisy data to exclude
%     Dir=RemoveElementsFromDir(Dir,'nmouse',MouseToAvoid);
%     disp(SessNames{ss})
%     for d=1:length(Dir.path)
%         TotTime=0;TotFz=0;TotStims=0;
%         if Dir.ExpeInfo{d}{1}.nmouse == MouseNameToDo
%             %         disp(MouseName{ss,d})
%             for dd=1:length(Dir.path{d})
%                 cd(Dir.path{d}{dd})
%                 clear Behav Params Results TTLInfo
%                 load('behavResources_SB.mat')
%                 if not(isfield(Behav,'LinearDist'))
%                     if dd==1
%                         BW=double(bwperim(Params.Zone{1}));
%                         imagesc(double(Params.ref)+BW/10)
%                         title('click on the maze, start with shock')
%                         curvexy=ginput(4);
%                         title('click on door position, start with shock')
%                         doorxy=ginput(2);
%                         clf
%                     end
%
%                     mapxy=[Data(Behav.Xtsd)';Data(Behav.Ytsd)']';
%                     [xy,distance,t] = distance2curve(curvexy,mapxy/Params.pixratio,'linear');
%                     [xybis,distancebis,tbis] = distance2curve(curvexy,doorxy,'linear');
%
%                     Behav.LinearDist=tsd(Range(Behav.Xtsd),t);
%                     Params.DoorPos=tbis;
%                     subplot(211)
%                     imagesc(Params.mask+Params.Zone{1})
%                     hold on
%                     plot(Data(Behav.Xtsd)/Params.pixratio,Data(Behav.Ytsd)/Params.pixratio)
%                     subplot(212)
%                     plot(t), ylim([0 1]), hold on
%                     line(xlim,[1 1]*tbis(1))
%                     line(xlim,[1 1]*tbis(2))
%                     keyboard
%                     clf
%                     save('behavResources_SB.mat','Behav','Params','-append')
%                 end
%                 clear Behav Params TTLInfo Results t xy distance mapxy xybis distancebis tbis
%             end
%         end
%     end
% end
