% ActiToData.m
 %
% other related scripts and functions :
%   - sleepscoringML.m (StateEpoch.mat)
%   - BulbSleepScriptGL.m (StateEpochSB.mat and B_High_Spectrum.mat)
%   - AnalyseActimeterML.m 
%   - ActimetrySleepScorCompar.m 
%   - ActimetryQuantifSleep.m

savRes=pwd;
if isempty(strfind(savRes,'/'))
    res='\media\DataMOBsRAID5\ProjetAstro\SlowOscillationsML';mark='\';
else
    res='/media/DataMOBsRAID5/ProjetAstro/SlowOscillationsML'; mark='/';
end

try
    load('Actimeter.mat')
    ActiScoring;
catch
    %% info manipe Antoine
    disp('-------------------');
    disp('act_0026-2015-05-15');
    disp('Mouse 241 = #4');
    disp('Mouse 242 = #3');
    disp('-------------------');
    disp('act_0032-2015-05-21');
    disp('Mouse 241 = #4');
    disp('Mouse 242 = #3');
    disp('-------------------');
    disp('act_0034-2015-06-04');
    disp('Mouse 241 = #6');
    disp('Mouse 242 = #5');
    disp('-------------------');
    disp('act_0035-2015-06-08');
    disp('Mouse 241 = #6');
    disp('Mouse 242 = #5');
    
    %% Get data
    
    answer= inputdlg({'day folder','channel'},'Indicate files',1,{'act_0026-2015-05-15','#4'}) ;
    nCh=answer{2};
    nameFile=[res,mark,answer{1}];
    
    % get corresponding data files
    disp(' ')
    disp(answer{1})
    list=dir(nameFile);
    for li=3:length(list)
        L=list(li).name;
        if length(L)>9 && ~isempty(strfind(L,nCh)) && strcmp(L(end-8:end),'block.dat')
            disp(['... adding scoring from ',L,' in Actimeter.mat '])
            ActiScoring=load([nameFile,mark,L]);
        elseif length(L)>8 && ~isempty(strfind(L,nCh)) && strcmp(L(end-7:end),'signal.dat')
            disp(['... adding data from ',L,' in Actimeter.mat '])
            ActiData=load([nameFile,mark,L]);
        end
        
    end
    
    % saving
    save Actimeter ActiScoring ActiData nCh nameFile
    
end

%% plot figure

figure('Color',[1 1 1])
plot(ActiData(:,1),ActiData(:,2))
hold on,
plot(ActiScoring(:,1),ActiScoring(:,2)+mean(ActiData(:,2)),'-r')

