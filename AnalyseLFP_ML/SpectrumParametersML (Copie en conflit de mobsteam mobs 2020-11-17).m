function [params,movingwin,suffix]=SpectrumParametersML(option,askcheck,Displ)

%SpectrumParametersML
%
% inputs:
% option (optional) = 'high' for [20-200Hz], 'low' for [1-20Hz] (default=low)
%
% outputs:
% params = structure containing pad/err/tralave/fpass/tapers/Fs...
% movingwin = 
% 
% example :
% [params,movingwin]=SpectrumParametersML('low',0);
% [params,movingwin]=SpectrumParametersML('high',0);
%
% [Sp,t,f]=LoadSpectrumML('PFCx_deep');
% [Sp,t,f]=LoadSpectrumML(30,pwd,'low'); % to load SpectrumDataL/Spectrum30.mat

%% compute
params.trialave=0;
params.err=[1 0.0500];
params.pad=2;

if exist('option','var') && strcmp(option,'high')
    params.fpass=[20 200];
    params.tapers=[2 3];
    movingwin=[0.1 0.005];
    params.Fs=1250;
    suffix='H';
    
elseif exist('option','var') && strcmp(option,'ultralow')
    params.fpass=[0.1 10];
    params.tapers=[3 5]; %[1 2]
    movingwin=[5 0.2]; %4
    params.Fs=1250;
    suffix='UL';
    
elseif exist('option','var') && strcmp(option,'GammaSO')
    params.fpass=[20 70];
    params.tapers=[2 3];
    movingwin=[0.1 0.005];
    params.Fs=1250;
    suffix='H';   
    
elseif ((exist('option','var') && strcmp(option,'low')) || ~exist('option','var'))
    params.fpass=[0.1 20];
    params.tapers=[3 5];
    movingwin=[3 0.2];
    params.Fs=1250;
    suffix='L'; 
    
elseif ((exist('option','var') && strcmp(option,'newlow')) || ~exist('option','var'))
    params.fpass=[0.1 20];
    params.tapers=[1 2];
    movingwin=[3 0.2];
    params.Fs=1250;
    suffix='L';
end

if  ~exist('option','var'), disp('Using default parameters... ');end

if  ~exist('askcheck','var'), askcheck=0;end

if  ~exist('Displ','var'), Displ=0;end
        
%% ckecking
if Displ
    disp(['movingwin ',option,' = [',num2str(movingwin),']']);
    disp(['params ',option,' =']);
    disp(params);
end

if askcheck
    ok=input('Do you want to change parameters (y/n)? ','s');
    while ok~='n'
        movingwin=input('Enter movingwin (default=[3 0.2]): ');
        params.fpass=input('Enter fpass (default=[0.01 20]): ');
        params.tapers=input('Enter params.tapers (default=[3 5]): ');
        params.Fs=input('Enter params.Fs (low=250, high=1250): ');
        disp(['movingwin = [',num2str(movingwin),']'])
        disp('params = ')
        disp(params)
        ok=input('Do you want to change parameters (y/n)? ','s');
    end
end


