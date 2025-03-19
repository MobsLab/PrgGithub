function stim=EventsTrigLFP_ML(nameDO,nameImposed,nameStructure,plotPETH,SizBin_ETaverage,NbBin_ETaverage,SizBin_PETH,NbBin_PETH,save_metAverage,save_PETH)

% function EventsTrigLFP_ML
%
% inputs:
% nameDO = name of electrode for DO events (e.g. 'e14' for MC_rack)
% nameImposed (optional) = e.g. 'ICSS' or 'hcs'
% nameStructure (optional) = see listLFP_to_InfoLFP_ML.m
% e.g. nameImposed='hcs'
%
% outputs:
% stim = 
% [m_PETH,t_PETH,e_PETH] = metaverage outputs

% stim=EventsTrigLFP_ML('e12','hcs','dHPC',1,5,1000,10,1000,1,1);

res=pwd;
if res(1)=='\', sepMark='\'; else sepMark='/'; end

%% inputs check
if ~exist('nameDO','var')
    error('Sepcify nameDO used')
end

if ~exist('nameStructure','var')
    nameStructure='All';
end

if ~exist('plotPETH','var')
    plotPETH=0;
end

if  ~exist('nameImposed','var')
    nameImposed='';
end

if  ~exist('NbBin_ETaverage','var')
    NbBin_ETaverage= 100;     
end


%% get files concatenation events

SetCurrentSession('same')
Concat_evt=GetEvents('output','Descriptions');
for i=1:length(Concat_evt)
    Concat_tpsEvt{i}=GetEvents(Concat_evt{i});
end
Concat_evt= Concat_evt(2:end);
Concat_tpsEvt=Concat_tpsEvt(2:end); 


%% set current session

global DATA;
path = DATA.session.path;
basename = DATA.session.basename;
DATA = LoadParameters([path sepMark basename '.xml']);


%% get stim events

eventDO = dir([path sepMark basename '*',nameImposed,'*.',nameDO,'.evt']);

if ~isempty(eventDO),
    stim_temp=[];
    
    for i = 1:length(eventDO),
        disp(['Loading events for ' eventDO(i).name]);
        events = LoadEvents([path sepMark eventDO(i).name]);
        for j=1:length(Concat_evt)
            if strcmp(Concat_evt{j}(1:5),'begin') && ~isempty(strfind(Concat_evt{j},eventDO(i).name(strfind(eventDO(i).name,basename):strfind(eventDO(i).name,['.',nameDO])-1)));
                disp(['      Adding start time from ',Concat_evt{j},': ',num2str(Concat_tpsEvt{j})]);
                stim_temp=[stim_temp;events.time+Concat_tpsEvt{j}];
            end
        end
    end
    stim=tsd(stim_temp(1:2:end)*1E4,stim_temp(1:2:end)*1E4);
else
    disp('... (no event file found)');
end

if ~exist([nameImposed,'Stim_',nameDO,'file'])
    save([nameImposed,'Stim_',nameDO],'stim')
else
    disp([nameImposed,'Stim_',nameDO,'.mat already exists. stim has not been saved: consider function output'])
end

%% LFP to average

if exist([res,sepMark,'LFPData',sepMark,'InfoLFP.mat'],'file')
    load([res,sepMark,'LFPData',sepMark,'InfoLFP.mat']);
else
    disp('No InfoLFP in LFPData, consider running makeDataBulb or load manually InfoLFP at keyboard...')
    keyboard;
end

if strcmp(nameStructure,'All')
    LFP_Channels=InfoLFP.channel;
    LFP_Names=InfoLFP.structure;
elseif sum(strcmp(InfoLFP.structure,nameStructure))~=0
    LFP_Channels=InfoLFP.channel(strcmp(InfoLFP.structure,nameStructure));
    LFP_Names=InfoLFP.structure(strcmp(InfoLFP.structure,nameStructure));
else
    disp('Error in the definition of LFP channels to analyze')
    keyboard;
end


%% mETAverage for each chosen LFP channels

for cc=1:length(LFP_Channels)
    disp(['   processing ',LFP_Names{cc},' Ch',num2str(LFP_Channels(cc))]  )
    
    clear LFP m_PETH t_PETH e_PETH fh_PETH rasterAx_PETH histAx_PETH matVal_PETH
    load([res,sepMark,'LFPData',sepMark,'LFP',num2str(LFP_Channels(cc))],'LFP')
    [m_PETH,t_PETH,e_PETH]=mETAverage(stim,Range(LFP),Data(LFP),SizBin_ETaverage,NbBin_ETaverage);
    
    figure('Color',[1 1 1]),
    plot(e_PETH/1E3,m_PETH,'k','Linewidth',2)
    title([LFP_Names{cc},' Ch',num2str(LFP_Channels(cc))])
    
    if save_metAverage
        save([res,sepMark,'save_metAverage_ch',num2str(LFP_Channels(cc))],'m_PETH','t_PETH','e_PETH','SizBin_ETaverage','NbBin_ETaverage')
    end
    
    if plotPETH
        figure('Color',[1 1 1]), 
        [fh_PETH, rasterAx_PETH, histAx_PETH, matVal_PETH] = ImagePETH(LFP,stim, -NbBin_PETH, +NbBin_PETH,'BinSize',SizBin_PETH);
        title([LFP_Names{cc},' Ch',num2str(LFP_Channels(cc))])
        caxis([-0.5 0.8]/1E3)
        
        if save_PETH
            save([res,sepMark,'save_PETH_ch',num2str(LFP_Channels(cc))],'fh_PETH','rasterAx_PETH','histAx_PETH','matVal_PETH')
        end
    end
    
end



