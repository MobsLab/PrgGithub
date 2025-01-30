%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%BilanManipeTotalMac
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

filename='/Users/karimbenchenane/Documents/Data/DataEnCours/ManipesICSSok/Data/';
cd(filename)

tr=4; 
renorm=1;
renormAll=1;
DoSuite=1;
sav=0;
plo=1;


%--------------------------------------------------------------------------

Protocol=1; % 1: sleep (n=2-3 ou 5);   2: wake place cell (n=2 ou 3);    3: Wake Manual (n=3)

NumberofManipes=6; 

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------








if Protocol==1

%--------------------------------------------------------------------------    
%--------------------------------------------------------------------------
% Sleep
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

cd([filename,'Mouse026/20120109'])
%cd /media/DISK_2/Data2/ICSS-Sleep/Mouse026/20120109/ICSS-Mouse-26-09012011

load AnalyseResourcesICSS Res

Res1=Res;

load ParametersAnalyseICSS M o varargin

if plo
%VisuQuantifEpoxhTrial(M,o,1)
%VisuQuantifEpochTrialNeuron(M,6,[7, 9 ,11],1)
VisuQuantifEpochTrialNeuron(M,6,[7],1,30)
end


%--------------------------------------------------------------------------

cd([filename,'Mouse029/20120207'])


% try
% fcd /media/DISK_1/Data1/creationData/20120207/ICSS-Mouse-29-07022012
% catch
%     cd /media/DISK_2/Data2/ICSS-Sleep/Mouse029/20120207
% end



load AnalyseResourcesICSS Res

Res2=Res;

load ParametersAnalyseICSS M o varargin

if plo
%VisuQuantifEpoxhTrial(M,o,1)
VisuQuantifEpochTrialNeuron(M,12,[1,2],1,20)
end



%--------------------------------------------------------------------------

cd([filename,'Mouse035/20120515'])


%cd /media/DISK_2/Data2/ICSS-Sleep/Mouse035/15052012/ICSS-Mouse-35-15052012
load AnalyseResourcesICSS Res

Res3=Res;

if plo
%VisuQuantifEpoxhTrial(M,o,1)
VisuQuantifEpochTrialNeuron(M,23,[4,13],1,15)
end





%--------------------------------------------------------------------------

cd([filename,'Mouse042/20120801'])


%cd /media/DISK_2/Data2/ICSS-Sleep/Mouse035/15052012/ICSS-Mouse-35-15052012
load AnalyseResourcesICSS Res

Res4=Res;

if plo
%VisuQuantifEpoxhTrial(M,o,1)
% VisuQuantifEpochTrialNeuron(M,23,[4,13],1,15)
VisuQuantifEpochTrialNeuron(10:13,12,[4,12],2,15);
end







%--------------------------------------------------------------------------

cd([filename,'Mouse029/20120208am'])

% 
% try
% fcd /media/DISK_1/Data1/creationData/20120208/20120208am/ICSS-Mouse-29-08022012
% catch
% cd /media/DISK_2/Data2/ICSS-Sleep/Mouse029/20120208am/
% end

load AnalyseResourcesICSS Res

Res5=Res;

load ParametersAnalyseICSS M o varargin

if plo
%VisuQuantifEpoxhTrial(M,o,1)
VisuQuantifEpochTrialNeuron(M,6,[1,2,8],1,20)

end


%--------------------------------------------------------------------------

cd([filename,'Mouse029/20120208pm'])

% 
% try
% fcd /media/DISK_1/Data1/creationData/20120208/20120208pm/ICSS-Mouse-29-08022012
% catch
% cd /media/DISK_2/Data2/ICSS-Sleep/Mouse029/20120208pm/
% end

load AnalyseResourcesICSS Res


Res6=Res;
load ParametersAnalyseICSS M o varargin

if plo
%VisuQuantifEpoxhTrial(M,o,1)

VisuQuantifEpochTrialNeuron(M,28,[1,12],1,15)
end









elseif Protocol==2


%--------------------------------------------------------------------------
% Wake Place cell
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------

cd([filename,'Mouse026/20111128'])

%cd /media/DISK_2/Data2/ICSS-Sleep/Mouse026/20111128/ICSS-Mouse-26-28112011

load AnalyseResourcesICSS Res

Res1=Res;

load ParametersAnalyseICSS M o varargin


%--------------------------------------------------------------------------

cd([filename,'Mouse029/20120209'])

%cd /media/DISK_2/Data2/ICSS-Sleep/Mouse029/20120209

load AnalyseResourcesICSS Res

Res2=Res;

load ParametersAnalyseICSS M o


%--------------------------------------------------------------------------

cd([filename,'Mouse017/20110622'])

%cd /media/DISK_1/Data1/creationData/Mouse017/ICSS-Mouse-17-22062011

load AnalyseResourcesICSS Res

Res3=Res;

load ParametersAnalyseICSS M o










elseif Protocol==3

%--------------------------------------------------------------------------
% wake manual
%--------------------------------------------------------------------------
% 
% 

%--------------------------------------------------------------------------

cd([filename,'Mouse017/20110614'])
%cd /media/Drobo2/DataD2/ICSS-Sleep/Mouse017/20110614/ICSS-Mouse-17-14062011


load AnalyseResourcesICSS Res

Res1=Res;

load ParametersAnalyseICSS M o



%--------------------------------------------------------------------------

cd([filename,'Mouse015/20110615'])

%cd /media/Drobo2/DataD2/ICSS-Sleep/Mouse015/ICSS-Mouse-15-15062011


load AnalyseResourcesICSS Res

Res2=Res;

load ParametersAnalyseICSS M o

%--------------------------------------------------------------------------

cd([filename,'Mouse013/20110420'])


%cd /media/Drobo2/DataD2/ICSS-Sleep/Mouse013/20110420/ICSS-Mouse-13-20042011
load AnalyseResourcesICSS Res

Res3=Res;

load ParametersAnalyseICSS M o


%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------


end



if NumberofManipes==2
BilanManipeFor2

elseif NumberofManipes==3
BilanManipeFor3

elseif NumberofManipes==4
BilanManipeFor4

elseif NumberofManipes==5
BilanManipeFor5

elseif NumberofManipes==6
BilanManipeFor6

end

cd(filename)

