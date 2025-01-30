%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%BilanManipeTotal
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

tr=3; 
renorm=1;
renormAll=1;
DoSuite=1;
sav=1;
plo=0;


%--------------------------------------------------------------------------

Protocol=1; % 1: sleep (n=2-3 ou 5);   2: wake place cell (n=2 ou 3);    3: Wake Manual (n=3)

NumberofManipes=3; 

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------








if Protocol==1
    
%--------------------------------------------------------------------------
% Sleep
%--------------------------------------------------------------------------


cd /media/DISK_2/Data2/ICSS-Sleep/Mouse026/20120109/ICSS-Mouse-26-09012011
load AnalyseResourcesICSS Res

Res1=Res;

load ParametersAnalyseICSS M o varargin

if plo
%VisuQuantifEpoxhTrial(M,o,1)
%VisuQuantifEpochTrialNeuron(M,6,[7, 9 ,11],1)

VisuQuantifEpochTrialNeuron(M,6,[7],1,30)
end

try
fcd /media/DISK_1/Data1/creationData/20120207/ICSS-Mouse-29-07022012
catch
    cd /media/DISK_2/Data2/ICSS-Sleep/Mouse029/20120207
end
load AnalyseResourcesICSS Res

Res2=Res;

load ParametersAnalyseICSS M o varargin

if plo
%VisuQuantifEpoxhTrial(M,o,1)
VisuQuantifEpochTrialNeuron(M,12,[1,2],1,20)
end



cd /media/DISK_2/Data2/ICSS-Sleep/Mouse035/15052012/ICSS-Mouse-35-15052012
load AnalyseResourcesICSS Res

Res3=Res;

if plo
%VisuQuantifEpoxhTrial(M,o,1)
VisuQuantifEpochTrialNeuron(M,23,[4,13],1,15)
end

try
fcd /media/DISK_1/Data1/creationData/20120208/20120208am/ICSS-Mouse-29-08022012
catch
cd /media/DISK_2/Data2/ICSS-Sleep/Mouse029/20120208am/
end

load AnalyseResourcesICSS Res

Res4=Res;

load ParametersAnalyseICSS M o varargin

if plo
%VisuQuantifEpoxhTrial(M,o,1)
VisuQuantifEpochTrialNeuron(M,6,[1,2,8],1,20)

end

try
fcd /media/DISK_1/Data1/creationData/20120208/20120208pm/ICSS-Mouse-29-08022012
catch
cd /media/DISK_2/Data2/ICSS-Sleep/Mouse029/20120208pm/
end

load AnalyseResourcesICSS Res


Res5=Res;
load ParametersAnalyseICSS M o varargin

if plo
%VisuQuantifEpoxhTrial(M,o,1)

VisuQuantifEpochTrialNeuron(M,28,[1,12],1)
end



elseif Protocol==2


%--------------------------------------------------------------------------
% Wake Place cell
%--------------------------------------------------------------------------

cd /media/DISK_2/Data2/ICSS-Sleep/Mouse026/20111128/ICSS-Mouse-26-28112011

load AnalyseResourcesICSS Res

Res1=Res;

load ParametersAnalyseICSS M o varargin


cd /media/DISK_2/Data2/ICSS-Sleep/Mouse029/20120209
load AnalyseResourcesICSS Res

Res2=Res;

load ParametersAnalyseICSS M o



cd /media/DISK_1/Data1/creationData/Mouse017/ICSS-Mouse-17-22062011
load AnalyseResourcesICSS Res

Res3=Res;

load ParametersAnalyseICSS M o










elseif Protocol==3

%--------------------------------------------------------------------------
% wake manual
%--------------------------------------------------------------------------
% 
% 

cd /media/Drobo2/DataD2/ICSS-Sleep/Mouse017/20110614/ICSS-Mouse-17-14062011
load AnalyseResourcesICSS Res

Res1=Res;

load ParametersAnalyseICSS M o


cd /media/Drobo2/DataD2/ICSS-Sleep/Mouse015/ICSS-Mouse-15-15062011
load AnalyseResourcesICSS Res

Res2=Res;

load ParametersAnalyseICSS M o

cd /media/Drobo2/DataD2/ICSS-Sleep/Mouse013/20110420/ICSS-Mouse-13-20042011
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

end



