function [Sp,t,f,channelToAnalyse]=ComputeSpectrogramML(LFP,movingwin,params,FileToSave,nameStructure,info)
 

% ComputeSpectrogramML
%
% inputs:
% LFP =
% movingwin =
% params =
% FileToSave = 
% nameStructure =
% info = structure file with info.name info.depth info.channels
% 
% outputs:
% [Sp,t,f] =
% channelToAnalyse =

%% initialization

if exist('LFP','var')==0 || exist('movingwin','var')==0 || exist('params','var')==0
    error('Not enough input arguments')
end

if exist('FileToSave','var')==0 
    res=pwd;
    FileToSave=[res,'/AnalyseSpectrumAllchannels'];
end

if exist('nameStructure','var')==0
    StructName='All';
    StructNickName='';
    info.name{1}=StructName;
    info.channels{1}=1:length(LFP);
    info.depth{1}=ones(1,length(info.channels));
else
    if length(nameStructure)>1
        StructName=nameStructure{1};
        StructNickName=nameStructure{2};
    else
        StructName=nameStructure;
        StructNickName=nameStructure;
    end
end

colori={'b','r','k','g','c','m','b','r','k','g','c','m','b','r','k','g','c','m'};
typo={ '-','-','-','-','-','-','--','--','--','--','--','--','-.','-.','-.','-.','-.','-.'};

%% choose channels to analyze

try
    load(FileToSave,['Channels',StructNickName],['UniqueChannel',StructNickName])
    eval(['Channels=Channels',StructNickName,';'])
    eval(['channelToAnalyse=UniqueChannel',StructNickName,';'])
    
    legendL=[]; 
    try
        for i=info.channels{strcmp(info.name,StructName)},
            depthi=info.depth{strcmp(info.name,StructName)}(info.channels{strcmp(info.name,StructName)}==i);
            legendL=[legendL,{[StructName,' -Ch',num2str(i),' (prof',num2str(depthi),')']}];
        end
    catch
        for i=1:length(info.channels)
            legendL=[legendL,{[StructName,' -Ch',num2str(info.channels(i)),' (prof',num2str(info.depth(i)),')']}];
        end
    end
catch
    
    indxFileToSave=strfind(FileToSave,'/');
    disp(['Creating Sp',StructNickName,' for all channels and saving in ',FileToSave(indxFileToSave(end):end)])   
    
    figure('color',[1 1 1]),
    a=0; b=0;
    legendL=[];
    I=intervalSet(0,30*1E4);
    
    try
        for i=info.channels{strcmp(info.name,{StructName})}
            a=a+1;
            b=b+max(Data(Restrict(LFP{i},I)))-min(Data(Restrict(LFP{i},I)));
            hold on, plot(Range(Restrict(LFP{i},I),'s'),Data(Restrict(LFP{i},I))+b,[colori{a},typo{a}]); 
            depthi=info.depth{strcmp(info.name,{StructName})}(info.channels{strcmp(info.name,{StructName})}==i);
            legendL=[legendL,{[StructName,' -Ch',num2str(i),' (prof',num2str(depthi),')']}];
        end
    catch
        
        for i=1:length(info.channels)
            a=a+1;
            b=b+max(Data(Restrict(LFP{i},I)))-min(Data(Restrict(LFP{i},I)));
            hold on, plot(Range(Restrict(LFP{i},I),'s'),Data(Restrict(LFP{i},I))+b,[colori{a},typo{a}]); 
            legendL=[legendL,{[StructName,' -Ch',num2str(i),' (prof',num2str(info.depth(i)),')']}];
        end 
    end
    legend(legendL)
    Channels=input('Enter channels to be analysed (e.g. [1:4]): ');
    close

    
    % save
    eval(['Channels',StructNickName,'=Channels;'])
    try 
        save(FileToSave,['Channels',StructNickName],'-append');
    catch
        save(FileToSave,['Channels',StructNickName]);
    end
end



%% compute Spectrogramms

figure('Color',[1 1 1])

for cc=Channels
   clear Sp_temp t_temp f_temp
    try
        load(FileToSave,['Sp',StructNickName,num2str(cc)])
        eval(['Sp_temp=Sp',StructNickName,num2str(cc),'{1};t_temp=Sp',StructNickName,num2str(cc),'{2};f_temp=Sp',StructNickName,num2str(cc),'{3};']);
        
    catch
        try, ChannelTocompute=info.channels{strcmp(info.name,{StructName})}(cc); catch, ChannelTocompute=info.channels(cc);end
        [Sp_temp,t_temp,f_temp]=mtspecgramc(Data(LFP{ChannelTocompute}),movingwin,params);
        eval(['Sp',StructNickName,num2str(cc),'={Sp_temp,t_temp,f_temp,cc};'])
        save(FileToSave,['Sp',StructNickName,num2str(cc)],'-append');
    end
    hold on, plot(f_temp,mean(Sp_temp,1),[colori{cc},typo{cc}],'linewidth',2)
end
try
    legend(legendL)
end
try 
    title(['BO lfp ',FileToSave(strfind(FileToSave,'Mouse'):end)])
catch 
    title('BO lfp ')
end

try 
    load(FileToSave,['UniqueChannel',StructNickName])
    eval(['channelToAnalyse=UniqueChannel',StructNickName,';'])
catch
    channelToAnalyse=input('Enter unique channel for display (e.g. 8): ');
    eval(['UniqueChannel',StructNickName,'=channelToAnalyse;'])
    save(FileToSave,['UniqueChannel',StructNickName],'movingwin','params','-append');
end


load(FileToSave,['Sp',StructNickName,num2str(channelToAnalyse)])
eval(['Sp=Sp',StructNickName,num2str(channelToAnalyse),'{1};t=Sp',StructNickName,num2str(channelToAnalyse),'{2};f=Sp',StructNickName,num2str(channelToAnalyse),'{3};']);





    
