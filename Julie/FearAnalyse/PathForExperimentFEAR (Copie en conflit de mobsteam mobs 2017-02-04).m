function Dir=PathForExperimentFEAR(experiment,datatype,check)

% INPUTS
% experiment = name of the experiment.
%     possible choices: 
%    'ManipDec14Bulbectomie' : EXT24h Pleth, EXT48H envB (nCTRL=7, nOBX =7)
%    'ManipFeb15Bulbectomie' : EXT24h  envC, EXT48H envB (nCTRL=8, nOBX =9)
%    'Fear-electrophy'
%    'Fear-electrophy-opto'
% datatype = fear or explo
% check = 1 for debug mode, give info while generating structure Dir

% OUTPUT
% Dir = structure containing paths / names / strains / name of experiment
%
% example:
% Dir=PathForExperimentsML('BASAL');
%
% 	merge two Dir:
% Dir=MergePathForExperiment(Dir1,Dir2);
%
%   restrict Dir to mice or group:
% Dir=RestrictPathForExperiment(Dir,'nMice',[245 246])
% Dir=RestrictPathForExperiment(Dir,'Group',{'OBX','hemiOBX'})
% Dir=RestrictPathForExperiment(Dir,'Group','OBX')
%
% similar functions:
% PathForExperimentsBULB.m
% PathForExperimentsDeltaSleep.m
% PathForExperimentsKB.m PathForExperimentsKBnew.m 
% PathForExperimentsML.m 

% -------------------------------------------------------------------------
%% strains inputs
MICEgroups={'OBX','hemiOBX','CTRL'};

nameSession={'HAB','COND','EXT-24h','EXT-48h','EXT-72h'};
nameEnvt={'envC','envB','pleth'};

nameTreatment={'control','CNO1','CNO2','laser4','laser10'};
    
OBX=[207 208 209 210 214 215 216 , 222 226 228 232 234 236 238 240 , 230 247,  249 250, 291 297 298,270:279];
hemiOBX=[245 246];

CTRL=[211 212 213 217 218 219 220, 223 224 225 227 229 233 235 237 239 , 231 248, 241 242,  243 244, 253 254, 258 259 299,269,280:290, 363,367]; 

implanted=[230 231 241 242 247 248 245 246  243 244 249 250 253 254 291 297 298 258 259 299 363 367];

% -------------------------------------------------------------------------
%% Path
if ~exist('datatype','var'),datatype='fear';end
if ~exist('check','var'),check=0;end

% if strcmp(datalocation, 'server')     
%     FolderPath='/media/DataMOBsRAID/ProjetAversion/';
% elseif strcmp(datalocation, 'DataMOBs14')    
%     FolderPath='/media/DataMOBs14/ProjetAversion/';    
% elseif strcmp(datalocation, 'manip')    
%     FolderPath='C:\Users\Cl�mence\Desktop\chgtordinateur\Fear\DATA-ACQUISITION\';  
% else
%     FolderPath='';
% end

a=0;
if strcmp(experiment, 'ManipFeb15Bulbectomie') %  ' : EXT24h  envC, EXT48H envB (nCTRL=8, nOBX =9)
    FolderPath='/media/DataMOBsRAID/ProjetAversion/';
    if strcmp(datatype,'fear')
        for m=222:229
            a=a+1; Dir.path{a}=[FolderPath experiment '/M' ,num2str(m),'/20150203/FEAR-Mouse-' num2str(m), '-03022015-HABenvC/'];
            %a=a+1; Dir.path{a}=[FolderPath experiment '/M' ,num2str(m),'/20150203/FEAR-Mouse-' num2str(m), '-03022015-HABenvB/'];
            %a=a+1; Dir.path{a}=[FolderPath experiment '/M' ,num2str(m),'/20150203/FEAR-Mouse-' num2str(m), '-04022015-HABenvA/'];
            a=a+1; Dir.path{a}=[FolderPath experiment '/M' ,num2str(m),'/20150204/FEAR-Mouse-' num2str(m), '-04022015-COND/'];
            a=a+1; Dir.path{a}=[FolderPath experiment '/M' ,num2str(m),'/20150205/FEAR-Mouse-' num2str(m), '-05022015-EXTenvC/'];
            a=a+1; Dir.path{a}=[FolderPath experiment '/M' ,num2str(m),'/20150206/FEAR-Mouse-' num2str(m), '-06022015-EXTenvB/'];
        end
        
        for m=230:240
            a=a+1; Dir.path{a}=[FolderPath experiment '/M' ,num2str(m),'/20150210/FEAR-Mouse-' num2str(m), '-10022015-HABenvC/'];
            %a=a+1; Dir.path{a}=[FolderPath experiment '/M' ,num2str(m),'/20150210/FEAR-Mouse-' num2str(m), '-10022015-HABenvB/'];
            %a=a+1; Dir.path{a}=[FolderPath experiment '/M' ,num2str(m),'/20150211/FEAR-Mouse-' num2str(m), '-11022015-HABenvA/'];
            a=a+1; Dir.path{a}=[FolderPath experiment '/M' ,num2str(m),'/20150211/FEAR-Mouse-' num2str(m), '-11022015-COND/'];
            a=a+1; Dir.path{a}=[FolderPath experiment '/M' ,num2str(m),'/20150212/FEAR-Mouse-' num2str(m), '-12022015-EXTenvC/'];
            a=a+1; Dir.path{a}=[FolderPath experiment '/M' ,num2str(m),'/20150213/FEAR-Mouse-' num2str(m), '-13022015-EXTenvB/'];
        end
    elseif strcmp(datatype,'explo')
        for m=222:229
            a=a+1; Dir.path{a}=[FolderPath experiment '/M' ,num2str(m),'/20150202/FEAR-Mouse-' num2str(m), '-02022015-EXPLOpre/'];
            a=a+1; Dir.path{a}=[FolderPath experiment '/M' ,num2str(m),'/20150206/FEAR-Mouse-' num2str(m), '-06022015-EXPLOpost'];
            a=a+1; Dir.path{a}=[FolderPath experiment '/M' ,num2str(m),'/20150212/FEAR-Mouse-' num2str(m), '-12022015-EXPLO+6j/'];
            a=a+1; Dir.path{a}=[FolderPath experiment '/M' ,num2str(m),'/20150302/FEAR-Mouse-' num2str(m), '-02032015-EXPLO+3wk/'];
        end
        for m=230:240
            a=a+1; Dir.path{a}=[FolderPath experiment '/M' ,num2str(m),'/20150209/FEAR-Mouse-' num2str(m), '-09022015-EXPLOpre/'];
            a=a+1; Dir.path{a}=[FolderPath experiment '/M' ,num2str(m),'/20150213/FEAR-Mouse-' num2str(m), '-13022015-EXPLOpost/'];
            a=a+1; Dir.path{a}=[FolderPath experiment '/M' ,num2str(m),'/20150219/FEAR-Mouse-' num2str(m), '-19022015-EXPLO+6j/'];
            a=a+1; Dir.path{a}=[FolderPath experiment '/M' ,num2str(m),'/20150309/FEAR-Mouse-' num2str(m), '-09032015-EXPLO+3wk/'];
        end
    end

elseif strcmp(experiment, 'ManipDec14Bulbectomie')   % : EXT24h Pleth, EXT48H envB (nCTRL=7, nOBX =7)
    FolderPath='/media/DataMOBsRAID/ProjetAversion/';
    if strcmp(datatype,'fear')
        for m=207:213
            %a=a+1; Dir.path{a}=[FolderPath experiment '/M' ,num2str(m),'/20141209/FEAR-Mouse-' num2str(m), '-09122014-HABpleth/'];
            %a=a+1; Dir.path{a}=[FolderPath experiment '/M' ,num2str(m),'/20141209/FEAR-Mouse-' num2str(m), '-09122014-HABenvB/'];
            a=a+1; Dir.path{a}=[FolderPath experiment '/M' ,num2str(m),'/20141210/FEAR-Mouse-' num2str(m), '-10122014-HABenvA/'];
            a=a+1; Dir.path{a}=[FolderPath experiment '/M' ,num2str(m),'/20141210/FEAR-Mouse-' num2str(m), '-10122014-COND/'];
            a=a+1; Dir.path{a}=[FolderPath experiment '/M' ,num2str(m),'/20141211/FEAR-Mouse-' num2str(m), '-11122014-EXTpleth/'];
            a=a+1; Dir.path{a}=[FolderPath experiment '/M' ,num2str(m),'/20141212/FEAR-Mouse-' num2str(m), '-12122014-EXTenvB/'];
        end
        for m=214:220
            %a=a+1; Dir.path{a}=[FolderPath experiment '/M' num2str(m) '/20141216/FEAR-Mouse-' num2str(m) '-16122014-HABpleth/'];
            %a=a+1; Dir.path{a}=[FolderPath experiment '/M' num2str(m) '/20141216/FEAR-Mouse-' num2str(m) '-16122014-HABenvB/'];
            a=a+1; Dir.path{a}=[FolderPath experiment '/M' num2str(m) '/20141217/FEAR-Mouse-' num2str(m) '-17122014-HABenvA/'];
            a=a+1; Dir.path{a}=[FolderPath experiment '/M' num2str(m) '/20141217/FEAR-Mouse-' num2str(m) '-17122014-COND/'];
            a=a+1; Dir.path{a}=[FolderPath experiment '/M' num2str(m) '/20141218/FEAR-Mouse-' num2str(m) '-18122014-EXTpleth/'];
            a=a+1; Dir.path{a}=[FolderPath experiment '/M' num2str(m) '/20141219/FEAR-Mouse-' num2str(m) '-19122014-EXTenvB/'];
        end
        
    elseif strcmp(datatype,'explo')
        for m=207:213
            a=a+1; Dir.path{a}=[FolderPath experiment '/M' num2str(m) '\20141208\FEAR-Mouse-' num2str(m) '-08122014-EXPLOpre'];
            a=a+1; Dir.path{a}=[FolderPath experiment '/M' num2str(m) '\20141212\FEAR-Mouse-' num2str(m) '-12122014-EXPLOpost'];
            a=a+1; Dir.path{a}=[FolderPath experiment '/M' num2str(m) '\20141218\FEAR-Mouse-' num2str(m) '-18122014-EXPLO+6j'];
            a=a+1; Dir.path{a}=[FolderPath experiment '/M' num2str(m) '\20150105\FEAR-Mouse-' num2str(m) '-05012015-EXPLO+3wk'];
        end
        for m=214:220
            a=a+1; Dir.path{a}=[FolderPath experiment '/M' num2str(m) '\20141215\FEAR-Mouse-' num2str(m) '-15122014-EXPLOpre'];
            a=a+1; Dir.path{a}=[FolderPath experiment '/M' num2str(m) '\20141219\FEAR-Mouse-' num2str(m) '-19122014-EXPLOpost'];
            a=a+1; Dir.path{a}=[FolderPath experiment '/M' num2str(m) '\20141225\FEAR-Mouse-' num2str(m) '-25122014-EXPLO+6j'];
            a=a+1; Dir.path{a}=[FolderPath experiment '/M' num2str(m) '\20150112\FEAR-Mouse-' num2str(m) '-12012015-EXPLO+3wk'];
        end
    end
    
elseif strcmp(experiment, 'FearMLavr2015')
   FolderPath='/media/DataMOBsRAID/ProjetAstro/';
    %mouse 245-246 hemiOBX-hemiOcclusion
    for m=245:246;
        a=a+1; Dir.path{a}=[FolderPath  'Mouse' num2str(m) '/20151125/FEAR-Mouse-270-25112015-01-COND']; 
        a=a+1; Dir.path{a}=[FolderPath  'Mouse' num2str(m) '/20150410/EXTenvB/BULB-Mouse-' num2str(m) '-10042015']; 
        %a=a+1; Dir.path{a}=[FolderPath  'Mouse' num2str(m) '/20150414/EXTenvB/BULB-Mouse-' num2str(m) '-14042015'];
        %a=a+1; Dir.path{a}=[FolderPath  'Mouse' num2str(m) '/20150420/EXTenvC/BULB-Mouse-' num2str(m) '-20042015'];
        a=a+1; Dir.path{a}=[FolderPath  'Mouse' num2str(m) '/20150508/EXTenvB/BULB-Mouse-' num2str(m) '-08052015'];
        a=a+1; Dir.path{a}=[FolderPath  'Mouse' num2str(m) '/20150509/EXTenvC/BULB-Mouse-' num2str(m) '-09052015'];
    end
    
elseif strcmp(experiment, 'FearCBNov15')
FolderPath='/media/DataMOBsRAID/ProjetAversion/ManipNov15Bulbectomie/';
    %mouse 270-279 big BBX mice and 269,280-290 sham
    for m=269:290
%         a=a+1; Dir.path{a}=[FolderPath  'M' num2str(m) '/20151123/FEAR-Mouse-' num2str(m) '23112015-01-EXPLOpre']; 
        a=a+1; Dir.path{a}=[FolderPath  'M' num2str(m) '/20151124/FEAR-Mouse-' num2str(m) '-24112015-01-HABenvB'];
        a=a+1; Dir.path{a}=[FolderPath  'M' num2str(m) '/20151124/FEAR-Mouse-' num2str(m) '-24112015-01-HABenvC'];         
        a=a+1; Dir.path{a}=[FolderPath  'M' num2str(m) '/20151125/FEAR-Mouse-' num2str(m) '-25112015-01-COND']; 
        a=a+1; Dir.path{a}=[FolderPath  'M' num2str(m) '/20151125/FEAR-Mouse-' num2str(m) '-25112015-01-HABgrille']; 
        a=a+1; Dir.path{a}=[FolderPath  'M' num2str(m) '/20151126/FEAR-Mouse-' num2str(m) '-26112015-01-EXT24-envC']; 
        a=a+1; Dir.path{a}=[FolderPath  'M' num2str(m) '/20151127/FEAR-Mouse-' num2str(m) '-27112015-01-EXT48-envB'];
%         a=a+1; Dir.path{a}=[FolderPath  'M' num2str(m) '/20151127/FEAR-Mouse-' num2str(m) '27112015-01-ExploPOST'];        
%         a=a+1; Dir.path{a}=[FolderPath  'M' num2str(m) '/20151203/FEAR-Mouse-' num2str(m) '03122015-01-EXPLO+6d']; 
%         a=a+1; Dir.path{a}=[FolderPath  'M' num2str(m) '/20151210/FEAR-Mouse-' num2str(m) '10122015-01-EXPLO+2wk']; 
%         a=a+1; Dir.path{a}=[FolderPath  'M' num2str(m) '/20151221/FEAR-Mouse-' num2str(m) '21122015-01-EXPLO+3wk']; 
    end

    
elseif strcmp(experiment, 'Fear-electrophy')
    
   FolderPath='/media/DataMOBsRAID/ProjetAstro/';
   for m=245:246;   
       a=a+1; Dir.path{a}=[FolderPath  'Mouse' num2str(m) '/20150410/EXTenvB/BULB-Mouse-' num2str(m) '-10042015']; 
       a=a+1; Dir.path{a}=[FolderPath  'Mouse' num2str(m) '/20150414/EXTenvB/BULB-Mouse-' num2str(m) '-14042015'];
       a=a+1; Dir.path{a}=[FolderPath  'Mouse' num2str(m) '/20150508/EXTenvB/BULB-Mouse-' num2str(m) '-08052015'];
       a=a+1; Dir.path{a}=[FolderPath  'Mouse' num2str(m) '/20150509/EXTenvC/BULB-Mouse-' num2str(m) '-09052015'];
       %a=a+1; Dir.path{a}=[FolderPath  'Mouse' num2str(m)
       %'/20150420/EXTenvB/BULB-Mouse-' num2str(m) '-20042015'];
   end
   for m=242:242;
       a=a+1; Dir.path{a}=[FolderPath  'Mouse' num2str(m) '/20150418/EXTenvB/BULB-Mouse-' num2str(m) '-18042015']; 
       a=a+1; Dir.path{a}=[FolderPath  'Mouse' num2str(m) '/20150509/EXTenvB/BULB-Mouse-' num2str(m) '-09052015']; 
   end
   a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse241/20150418-EXT-48h-envB/'; % reprocessed with RefSub
   a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse241/20150509-EXT-24h-envB'; % reprocessed with RefSub
   
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse230/20150212-EXT-24h-envC'; % ref intan soustraite
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse231/20150212-EXT-24h-envC'; % ref intan soustraite
    
    % a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse247/20150326-EXT-24h-envC';% souris sans hippocampe droit- à exclure des analyses
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse248/20150326-EXT-24h-envC'; % pas de ref à sourstraire - analyser que pendant freezing
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse248/20150327-EXT-48h-envB'; % pas de ref à sourstraire - analyser que pendant freezing
    
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse244/20150506-EXT-24h-envC';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse244/20150507-EXT-24h-envB'; 
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse244/20150508-EXT-48h-envC';
    
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse243/20150506-EXT-24h-envC';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse243/20150507-EXT-24h-envB'; 
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse243/20150508-EXT-48h-envC';
    
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse249/20150506-EXT-24h-envC';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse249/20150507-EXT-24h-envB'; 
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse249/20150508-EXT-48h-envC';
    
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse250/20150506-EXT-24h-envC';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse250/20150507-EXT-24h-envB'; 
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse250/20150508-EXT-48h-envC';
    
    
    
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse253/20150703-EXT-24h-envC/FEAR-Mouse-253-03072015'; 
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse253/20150704-EXT-48h-envB/FEAR-Mouse-253-04072015';  
    
%     a=a+1; Dir.path{a}='/media/DataMOBs29/M253/20150701-04-manip-control/20150703-EXT-24h-envC/FEAR-Mouse-253-03072015'; 
%     a=a+1; Dir.path{a}='/media/DataMOBs29/M253/20150701-04-manip-control/20150704-EXT-48h-envB/FEAR-Mouse-253-04072015';  
%     a=a+1; Dir.path{a}='/media/DataMOBs29/M253/20150706-09-manip-CNO1/20150707-EXT-24h-envC/FEAR-Mouse-253-07072015'; 
%     a=a+1; Dir.path{a}='/media/DataMOBs29/M253/20150706-09-manip-CNO1/20150708-EXT-48h-envB/FEAR-Mouse-253-08072015'; 
%     a=a+1; Dir.path{a}='/media/DataMOBs29/M253/20150713-15_manip-CNO2/20150714-EXT-24h-envC/FEAR-Mouse-253-14072015'; 
%     a=a+1; Dir.path{a}='/media/DataMOBs29/M253/20150713-15_manip-CNO2/20150715-EXT-48h-envB/FEAR-Mouse-253-15072015';      
    
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse254/20150703-EXT-24h-envC'; 
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse254/20150704-EXT-48h-envB/FEAR-Mouse-254-04072015';
%     
%     a=a+1; Dir.path{a}='/media/DataMOBs29/M254/20150701-04-manip-control/20150703-EXT-24h-envC/FEAR-Mouse-254-03072015'; 
%     a=a+1; Dir.path{a}='/media/DataMOBs29/M254/20150701-04-manip-control/20150704-EXT-48h-envB/FEAR-Mouse-254-04072015';
%     a=a+1; Dir.path{a}='/media/DataMOBs29/M254/20150706-09-manip-CNO1/20150714-EXT-24h-envC/FEAR-Mouse-254-07072015'; 
%     a=a+1; Dir.path{a}='/media/DataMOBs29/M254/20150706-09-manip-CNO1/20150715-EXT-48h-envC/FEAR-Mouse-254-08072015'; 
%     a=a+1; Dir.path{a}='/media/DataMOBs29/M254/20150713-15-manip-CNO2/20150714-EXT-24h-envC/FEAR-Mouse-254-14072015'; 
%     a=a+1; Dir.path{a}='/media/DataMOBs29/M254/20150713-15-manip-CNO2/20150715-EXT-48h-envB/FEAR-Mouse-254-15072015';

% % % Manip Sophie Dec 2015 :
    %a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse258/20151203-HABgrille'; 
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse258/20151204-EXT-24h-envC';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse258/20151205-EXT-48h-envB';
    
    %a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse259/20151203-HABgrille'; 
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse259/20151204-EXT-24h-envC';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse259/20151205-EXT-48h-envB'; % a refaire
    
    
    %a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse291/20151203-HABgrille'; %%
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse291/20151204-EXT-24h-envC';%
    %a=a+1;Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse291/20151205-EXT-48h-envB';% crise d'epilepsie 

    
    %a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse297/20151216-HABgrille'; % 
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse297/20151217-EXT-24h-envC';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse297/20151218-EXT-48h-envB';% 
    
    %a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse298/20151216-HABgrille'; 
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse298/20151217-EXT-24h-envC';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse298/20151218-EXT-48h-envB';
    
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse299/20151217-EXT-24h-envC';% 
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse299/20151218-EXT-48h-envB';
   
    
    elseif strcmp(experiment, 'Sleep-OBX')
        a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse249/20150527-SLEEP-post/';
        
    elseif strcmp(experiment, 'Fear-electrophy-opto')
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse363/20160717-EXT-24h-laser10';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse363/20160718-EXT-48h-laser10';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse363/20160719-EXT-72h-laser4';
    
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse367/20160717-EXT-24h-laser10';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse367/20160718-EXT-48h-laser10';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse367/20160719-EXT-72h-laser4';
end



% -------------------------------------------------------------------------
%% names

for i=1:length(Dir.path)
    Dir.manipe{i}=experiment;
    temp=strfind(Dir.path{i},'Mouse-');
    if isempty(temp)
        Dir.name{i}=Dir.path{i}(strfind(Dir.path{i},'Mouse'):strfind(Dir.path{i},'Mouse')+7);
    else
        Dir.name{i}=['Mouse',Dir.path{i}(temp+6:temp+8)];
    end
    %fprintf(Dir.name{i});
end

% -------------------------------------------------------------------------
%% Strain

for i=1:length(Dir.path)
    for mi=1:length(MICEgroups)
        eval(['temp(mi)=sum(ismember(str2double(Dir.name{i}(6:8)),',MICEgroups{mi},'));']);
    end
    
    if sum(temp)==0
        Dir.group{i}=nan;
    else
        Dir.group{i}=MICEgroups{temp==1};
    end
    
end
% -------------------------------------------------------------------------
%% session / environment
for i=1:length(Dir.path)
%     nameSession={'HAB','COND','EXT'};
%     nameEnvt={'envC','envB','pleth'};

    for mi=1:length(nameSession)
        if ~isempty(strfind(lower(Dir.path{i}),lower(nameSession{mi})))
            tempS{i}=nameSession{mi};
        end
    end
    
    try tempS{i};
    catch
        if ~isempty(strfind(lower(Dir.path{i}),lower('Ext')))
            if ~isempty(strfind(lower(Dir.path{i}),lower('24')))
                tempS{i}='EXT-24h';
            elseif ~isempty(strfind(lower(Dir.path{i}),lower('48')))
                tempS{i}='EXT-48h';
            end
        end
    end
    
    try tempS{i};
    catch
        if ~isempty(strfind(lower(Dir.path{i}),lower('Ext')))
            
            if ~isempty(strfind(lower(Dir.path{i}),lower('envC')))
                tempS{i}='EXT-24h';
            elseif ~isempty(strfind(lower(Dir.path{i}),lower('envB')))
                tempS{i}='EXT-48h';
            end
        end
    end
    

    
    for mi=1:length(nameEnvt)
        if ~isempty(strfind(lower(Dir.path{i}),lower(nameEnvt{mi})))
            Environment{i}=nameEnvt{mi};
        end
        try 
            Environment{i};
        catch
            if exist('tempS','var') && strcmp(tempS{i},'COND')
                Environment{i}='grille';
            else
                Environment{i}='NaN';
            end
        end
    end
    
   if exist('tempS','var') , 
       Dir.Session{i}=[tempS{i} '-' Environment{i}];
   else
       Dir.Session{i}='';
   end
end


% -------------------------------------------------------------------------
%% Treatment
for i=1:length(Dir.path)
%     nameSession={'HAB','COND','EXT'};
%     nameEnvt={'envC','envB','pleth'};

    for mi=1:length(nameTreatment)
        if ~isempty(strfind(Dir.path{i},nameTreatment{mi}))
            tempT{i}=nameTreatment{mi};
        end
    end
   
   if exist('tempT','var') , 
       Dir.Treatment{i}=[tempT{i}];
   else
       Dir.Treatment{i}='control';
   end
end

% -------------------------------------------------------------------------
%% checks
if check,
    for i=1:length(Dir.path)
        disp([Dir.name{i},' -> ',Dir.group{i},'  ',Dir.Session{i} ]);
    end
end

% -------------------------------------------------------------------------
%% change '\' into '/'
for man =1:length(Dir.path)
    Dir.path{man}(strfind(Dir.path{man},'\'))='/';
end
