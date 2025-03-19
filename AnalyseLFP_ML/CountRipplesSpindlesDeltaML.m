function CountRipplesSpindlesDeltaML(NameDir)

%% INITIATE
Dir=PathForExperimentsML(NameDir);
NameStructSpind={'SpindlesPaCxDeep','SpindlesPaCxSup','SpindlesPFCxDeep','SpindlesPFCxSup'};
UGroupsName={'WT','dKO'};

MAT=nan(length(Dir.path),3+2*length(NameStructSpind));

for man=1:length(Dir.path)
    disp([Dir.path{man}(max(strfind(Dir.path{man},'Mouse')):end)])
    nmouse=str2num(Dir.name{man}(6:end));
    ngroup=find(strcmp(Dir.group{man},UGroupsName));
    
    
    % SWS Epoch
    tempLoad=load([Dir.path{man},'/StateEpoch.mat'],'SWSEpoch','NoiseEpoch','GndNoiseEpoch');
    Epoch=tempLoad.SWSEpoch-tempLoad.GndNoiseEpoch;
    LengthEpoch=sum(Stop(Epoch,'s')-Start(Epoch,'s'))/60;% in minute
    
    % Ripples
    clear dHPCrip
    try eval(['load(''',Dir.path{man},'/RipplesdHPC25.mat'',''dHPCrip'');']);end
    if exist('dHPCrip','var')
        disp(['Ripples/min = ',num2str(size(dHPCrip,1)/LengthEpoch)]);
        MAT(man,1:3)=[nmouse,ngroup,size(dHPCrip,1)/LengthEpoch];
    else
        disp('  No HPC Ripples')
    end
    
    % Spindles
    for nn=1:length(NameStructSpind)
        clear SpiTot
        try eval(['load(''',Dir.path{man},'/',NameStructSpind{nn},'.mat'',''SpiTot'');']);end
        if exist('SpiTot','var')
            disp([NameStructSpind{nn},'/min = ',num2str(size(SpiTot,1)/LengthEpoch),'  (mean Fcy = ',num2str(floor(10*nanmean(SpiTot(:,6)))/10),' Hz)']);
            MAT(man,1:2)=[nmouse,ngroup];
            MAT(man,3+2*nn-1)=size(SpiTot,1)/LengthEpoch;
            MAT(man,3+2*nn)=nanmean(SpiTot(:,6));
        else
            disp(['  No ',NameStructSpind{nn}])
        end
    end
    
    % Delta
    
end

%% POOL DATA fROM SAME MOUSE
Umice=unique(MAT(:,1)); Umice=Umice(~isnan(Umice));
Matmi=nan(length(Umice),size(MAT,2));
for mi=1:length(Umice)
    indexmi=find(MAT(:,1)==Umice(mi));
    Matmi(mi,:)=nanmean(MAT(indexmi,:),1);
end



%% PLOT RIPPLES
figure('Color',[1 1 1])
subplot(3,length(NameStructSpind),1)

indexWT=find(Matmi(:,2)==1 & ~isnan(Matmi(:,3)));
indexKO=find(Matmi(:,2)==2 & ~isnan(Matmi(:,3)));
A=nan(max(length(indexWT),length(indexKO)),2);
A(1:length(indexWT),1)=Matmi(indexWT,3);
A(1:length(indexKO),2)=Matmi(indexKO,3);

p=PlotErrorBarN(A,0,0);
set(gca,'XTick',1:2), set(gca,'XTickLabel',{['WT (n=',num2str(length(indexWT)),')'],['dKO (n=',num2str(length(indexKO)),')']})
colori='r'; if p<0.05, signifText='*'; elseif p<0.01, signifText='**'; else,  signifText='NS'; colori='k'; end
title([signifText,' (p=',num2str(floor(p*1E3)/1E3),')'])
ylabel('Hippocampal Ripples per min (SWS)')

%% PLOT SPINDLES

for nn=1:length(NameStructSpind)
    
    % number of spindles
    subplot(3,length(NameStructSpind),length(NameStructSpind)+nn)
    
    indexWT=find(Matmi(:,2)==1 & ~isnan(Matmi(:,3+2*nn-1)));
    indexKO=find(Matmi(:,2)==2 & ~isnan(Matmi(:,3+2*nn-1)));
    A=nan(max(length(indexWT),length(indexKO)),2);
    A(1:length(indexWT),1)=Matmi(indexWT,3+2*nn-1);
    A(1:length(indexKO),2)=Matmi(indexKO,3+2*nn-1);
    
    p=PlotErrorBarN(A,0,0);
    set(gca,'XTick',1:2), set(gca,'XTickLabel',{['WT (n=',num2str(length(indexWT)),')'],['dKO (n=',num2str(length(indexKO)),')']})
    colori='r'; if p<0.05, signifText='*'; elseif p<0.01, signifText='**'; else,  signifText='NS'; colori='k'; end
    title([signifText,' (p=',num2str(floor(p*1E3)/1E3),')'])
    ylabel([NameStructSpind{nn},' per min (SWS)'])
    
    % frequency of spindles
    subplot(3,length(NameStructSpind),2*length(NameStructSpind)+nn)
    
    indexWT=find(Matmi(:,2)==1 & ~isnan(Matmi(:,3+2*nn)));
    indexKO=find(Matmi(:,2)==2 & ~isnan(Matmi(:,3+2*nn)));
    A=nan(max(length(indexWT),length(indexKO)),2);
    A(1:length(indexWT),1)=Matmi(indexWT,3+2*nn);
    A(1:length(indexKO),2)=Matmi(indexKO,3+2*nn);
    
    p=PlotErrorBarN(A,0,0);
    set(gca,'XTick',1:2), set(gca,'XTickLabel',{['WT (n=',num2str(length(indexWT)),')'],['dKO (n=',num2str(length(indexKO)),')']})
    colori='r'; if p<0.05, signifText='*'; elseif p<0.01, signifText='**'; else,  signifText='NS'; colori='k'; end
    title([signifText,' (p=',num2str(floor(p*1E3)/1E3),')'])
    ylabel(['Frequency of ',NameStructSpind{nn}])
    
end
