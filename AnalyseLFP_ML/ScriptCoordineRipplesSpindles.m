function [MATT,UGroupsName,UhighLow]=ScriptCoordineRipplesSpindles(namedFoldersave,NameDir);

% run CoordineRipplesSpindles.m and pool data
% inputs:
% namedFoldersave = 
% NameDir = 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%% INITIATE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~exist('namedFoldersave','var')
    namedFoldersave='/media/DataMOBsRAID5/ProjetAstro';
end

if ~exist('NameDir','var')
    NameDir={'BASAL'};
end

UGroupsName={'WT','dKO','C57'};
UhighLow={'High','Low'};
MATTname={'Mouse','Group','StructureForSpindlesDetection','ChannelDepth','HighOrLowSpindles','nbSpindles','Matrice_RipplesPower_NormBy_GammaPower'};
scrsz = get(0,'ScreenSize')/4;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%% INITIATE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
res=pwd;
PathDone=[];
MATT=[];
Mquantif=[];
col=lines(30);
MouseDone=[];
LegAll=[];
for fi=1:3, figure('Color',[1 1 1]); numF(fi)=gcf;end


for i=1:length(NameDir)
    Dir=PathForExperimentsML(NameDir{i});
    
    for man=1:length(Dir.path)
        
        if sum(strcmp(Dir.path{man},PathDone))==0
            nmouse=str2num(Dir.name{man}(6:end));
            ngroup=find(strcmp(Dir.group{man},UGroupsName));
            if isempty(find(MouseDone==nmouse)), MouseDone=[MouseDone, nmouse];end
                colorimouse=col(find(MouseDone==nmouse),:);
                
            try
                [Mh,Ml,LengthM,structureName,InfoDepth,freqRipples,paramRipRow]=CoordineRipplesSpindles(Dir.path{man},[],Dir.CorrecAmpli(man),0); close;
                [Mhgam,Mlgam,LengthM,structureName,InfoDepth,freqGamma]=CoordineRipplesSpindles(Dir.path{man},[],Dir.CorrecAmpli(man),1); close;
                %numF=gcf; saveFigure(numF,['SpindlesTrigRipples_',nameMouseDay],namedFoldersave);
                
                
                for nn=1:length(structureName)
                    for id=1:length(InfoDepth)
                        try
                            Mhtemp=Mh{nn,id};
                            Mltemp=Ml{nn,id};
                            Mhgamtemp=Mhgam{nn,id};
                            Mlgamtemp=Mlgam{nn,id};
                            
                            if ~exist('Mtime','var') 
                                if ~isempty(Mhtemp),Mtime=Mhtemp(:,1);end
                            else
                                if ~isequal(size(Mtime),size(Mhtemp(:,1))) || ( isequal(size(Mtime),size(Mhtemp(:,1))) && ~isequal(Mtime,Mhtemp(:,1)))
                                    Mhtemp2=interp1(Mhtemp(:,1),Mhtemp(:,2),Mtime); Mhtemp=[Mtime,Mhtemp2];
                                    Mltemp2=interp1(Mltemp(:,1),Mltemp(:,2),Mtime); Mltemp=[Mtime,Mltemp2];
                                    Mhgamtemp2=interp1(Mhgamtemp(:,1),Mhgamtemp(:,2),Mtime); Mhgamtemp=[Mtime,Mhgamtemp2];
                                    Mlgamtemp2=interp1(Mlgamtemp(:,1),Mlgamtemp(:,2),Mtime); Mlgamtemp=[Mtime,Mlgamtemp2];
                                end
                            end
                            
                            % MATT: mouse - group - struct - depth -
                            % highlowspindles - nSpindles -
                            % RipPowerNormByGammaPower
                            MATT=[MATT;[nmouse,ngroup,nn,id,1,LengthM{nn,id}(1),(Mhtemp(:,2)./Mhgamtemp(:,2))']];
                            MATT=[MATT;[nmouse,ngroup,nn,id,2,LengthM{nn,id}(2),(Mltemp(:,2)./Mlgamtemp(:,2))']];
                            
                            Mquantif=[Mquantif ;[nmouse,ngroup,nn,id,1,max(Mhtemp(:,2)./Mhgamtemp(:,2))-min(Mhtemp(:,2)./Mhgamtemp(:,2))]];
                            Mquantif=[Mquantif ;[nmouse,ngroup,nn,id,2,max(Mltemp(:,2)./Mlgamtemp(:,2))-min(Mltemp(:,2)./Mlgamtemp(:,2))]];
                            
                            disp(['  -> ',structureName{nn},InfoDepth{id},' added in MATT'])
                            
                            
                            % ---------------------------------------------
                            % ------------ display ------------------------
                            
                            
                            % ripples
                            figure(numF(1)), subplot(length(structureName),length(InfoDepth)*2,(nn-1)*length(InfoDepth)*2+(id-1)*2+1)
                            title([structureName{nn},InfoDepth{id},'High']), xlabel('Time (s)'); ylabel('RipplesPower')
                            hold on, plot(Mtime,Mhtemp(:,2),'Color',colorimouse);
                            
                            subplot(length(structureName),length(InfoDepth)*2,(nn-1)*length(InfoDepth)*2+(id-1)*2+2)
                            title([structureName{nn},InfoDepth{id},'Low']), xlabel('Time (s)'); ylabel('RipplesPower')
                            hold on, plot(Mtime,Mltemp(:,2),'Color',colorimouse);
                            
                            % gamma
                            figure(numF(2)), subplot(length(structureName),length(InfoDepth)*2,(nn-1)*length(InfoDepth)*2+(id-1)*2+1)
                            title([structureName{nn},InfoDepth{id},'High']), xlabel('Time (s)'); ylabel('GammaPower')
                            hold on, plot(Mtime,Mhgamtemp(:,2),'Color',colorimouse);
                            
                            subplot(length(structureName),length(InfoDepth)*2,(nn-1)*length(InfoDepth)*2+(id-1)*2+2)
                            title([structureName{nn},InfoDepth{id},'Low']), xlabel('Time (s)'); ylabel('GammaPower')
                            hold on, plot(Mtime,Mlgamtemp(:,2),'Color',colorimouse);
                            
                            % ripples normalized by gamma
                            figure(numF(3)), subplot(length(structureName),length(InfoDepth)*2,(nn-1)*length(InfoDepth)*2+(id-1)*2+1)
                            title([structureName{nn},InfoDepth{id},'High']), xlabel('Time (s)'); ylabel('RipplesPower/GammaPower')
                            hold on, plot(Mtime,Mhtemp(:,2)./Mhgamtemp(:,2),'Color',colorimouse);
                            
                            subplot(length(structureName),length(InfoDepth)*2,(nn-1)*length(InfoDepth)*2+(id-1)*2+2)
                            title([structureName{nn},InfoDepth{id},'Low']), xlabel('Time (s)'); ylabel('RipplesPower/GammaPower')
                            hold on, plot(Mtime,Mltemp(:,2)./Mlgamtemp(:,2),'Color',colorimouse);
                            
                            if nn==2 && id==1, LegAll=[LegAll,{['Mouse',num2str(nmouse)]}];end
                            % ---------------------------------------------
                            
                            
                        catch
                            disp(['  -> Problem ',structureName{nn},InfoDepth{id}]);%keyboard 
                        end
                    end
                end
            catch
                disp([' PROBLEM !!!! ',Dir.path{man}])
%                 cd(Dir.path{man}); keyboard
%                 cd(res)
            end
            
            PathDone=[PathDone,Dir.path{man}];
        end
    end
end
figure(numF(3)), subplot(length(structureName),length(InfoDepth)*2,length(InfoDepth)*2+1), legend(LegAll); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%% MANIPULATE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%UGroupsName={'WT','dKO','C57'};
%UhighLow={'High','Low'};
plotAll=1;
Umice=unique(MATT(:,1));
%Umice=Umice([1:find(Umice==82)-1,find(Umice==82)+1:end]);

MatAveraged={};
MquAveraged={};

col=lines(length(Umice));
figure('Color',[1 1 1]);
LegAll=[];
for nn=1:length(structureName)
    for id=1:length(InfoDepth)
        for HigLow=1:length(UhighLow)
            %display
            subplot(length(structureName),length(InfoDepth)*length(UhighLow),(nn-1)*length(InfoDepth)*length(UhighLow)+(id-1)*length(UhighLow)+HigLow)
            title([structureName{nn},InfoDepth{id},UhighLow{HigLow}])
            xlabel('Time (s)'); ylabel('RipplesPower/GammaPower (norm by -mean)')
            
            %compute
            tempMatAveraged=[];
            tempMquAveraged=[];
            LegAll=[];
            for mi=1:length(Umice)
                index=find(MATT(:,1)==Umice(mi) & MATT(:,3)==nn & MATT(:,4)==id & MATT(:,5)==HigLow);

                if length(index)>1
                    NtotSpindles=sum(MATT(index,6));
                    for bi=1:length(index)
                        tempM(bi,1:size(MATT,2)-6)=MATT(index(bi),7:end)*MATT(index(bi),6)/NtotSpindles;
                        
                        hold on, plot(Mtime,MATT(index(bi),7:end)/nanmean(MATT(index(bi),7:end))-mi,'Color',col(mi,:));
                        LegAll=[LegAll,{['Mouse',num2str(Umice(mi))]}];
                    end
                    tempMatAveraged=[tempMatAveraged; [MATT(index(1),[1,2,6]),nanmean(tempM,1)/nanmean(nanmean(tempM,1))]];
                    
                    tempMquAveraged=[tempMquAveraged; [Mquantif(index(1),1:2),nanmean(Mquantif(index,6))]];
                    
                elseif length(index)==1
                    tempMatAveraged=[tempMatAveraged; [MATT(index,[1,2,6]),MATT(index,7:end)/nanmean(MATT(index,7:end))]];
                    
                    hold on, plot(Mtime,MATT(index,7:end)/nanmean(MATT(index,7:end))-mi,'Color',col(mi,:));
                    LegAll=[LegAll,{['Mouse',num2str(Umice(mi))]}];
                    
                    tempMquAveraged=[tempMquAveraged; [Mquantif(index,1:2),Mquantif(index,6)]];
                end
                
            end
            
            MatAveraged{nn,id,HigLow}=tempMatAveraged;
            
            MquAveraged{nn,id,HigLow}=tempMquAveraged;
        end
        
    end
end
legend(LegAll)

if ~plotAll, close; end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%% SAVE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


todayIs=date;
nameFileToSave=['AnalyCoordSpinRip',date];
disp(' '); disp(['Saving in ',namedFoldersave,'/',nameFileToSave,'...'])
try
save([namedFoldersave,'/',nameFileToSave],'MATT','MatAveraged','Mtime','Mquantif','MquAveraged','UGroupsName','UhighLow','namedFoldersave','NameDir','freqRipples','freqGamma','paramRipRow','structureName','InfoDepth','MATTname')
catch, keyboard;end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%% DISPLAY %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure('Color',[1 1 1]);
for nn=1:length(structureName)
    for id=1:length(InfoDepth)
        for HigLow=1:length(UhighLow)
            %display
            subplot(length(structureName),length(InfoDepth)*length(UhighLow),(nn-1)*length(InfoDepth)*length(UhighLow)+(id-1)*length(UhighLow)+HigLow)
            title([structureName{nn},InfoDepth{id},UhighLow{HigLow}])
            
            tempMatAveraged=MatAveraged{nn,id,HigLow};
            indexWT=find(tempMatAveraged(:,2)==1); nWT=length(indexWT);
            indexKO=find(tempMatAveraged(:,2)==2); nKO=length(indexKO);
            
            hold on, plot(Mtime,nanmean(tempMatAveraged(indexWT,4:end),1),'Color','k','LineWidth',2);
            hold on, plot(Mtime,nanmean(tempMatAveraged(indexKO,4:end),1),'Color','b','LineWidth',2);
            legend({['WT (n=',num2str(nWT),')'],['dKO (n=',num2str(nKO),')']})
            hold on, plot(Mtime,nanmean(tempMatAveraged(indexWT,4:end),1)+stdError(tempMatAveraged(indexWT,4:end)),'Color','k');
            hold on, plot(Mtime,nanmean(tempMatAveraged(indexWT,4:end),1)-stdError(tempMatAveraged(indexWT,4:end)),'Color','k');
            hold on, plot(Mtime,nanmean(tempMatAveraged(indexKO,4:end),1)+stdError(tempMatAveraged(indexKO,4:end)),'Color','b');
            hold on, plot(Mtime,nanmean(tempMatAveraged(indexKO,4:end),1)-stdError(tempMatAveraged(indexKO,4:end)),'Color','b');
            
            xlabel('Time (s)'); 
            ylabel('RipplesPower/GammaPower (norm by mean)')
        end
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%% QUANTIF %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


figure('Color',[1 1 1],'Position',scrsz);
for nn=1:length(structureName)
    for id=1:length(InfoDepth)
        for HigLow=1:length(UhighLow)
            %display
            subplot(length(structureName),length(InfoDepth)*length(UhighLow),(nn-1)*length(InfoDepth)*length(UhighLow)+(id-1)*length(UhighLow)+HigLow)
            title([structureName{nn},InfoDepth{id},UhighLow{HigLow}])
            
            tempMquAveraged=MquAveraged{nn,id,HigLow};
            indexWT=find(tempMquAveraged(:,2)==1); nWT=length(indexWT);
            indexKO=find(tempMquAveraged(:,2)==2); nKO=length(indexKO);
            
            hold on, bar(1:2,[mean(tempMquAveraged(indexWT,3));mean(tempMquAveraged(indexKO,3))]);
            xlim([0 3])
            hold on, errorbar([1 2],[mean(tempMquAveraged(indexWT,3)),mean(tempMquAveraged(indexKO,3))],[stdError(tempMquAveraged(indexWT,3)),stdError(tempMquAveraged(indexKO,3))],'+k')

            set(gca,'XTick',1:2)
            set(gca,'XTickLabel',{['WT (n=',num2str(nWT),')'],['dKO (n=',num2str(nKO),')']})
            p=ranksum(tempMquAveraged(indexKO,3),tempMquAveraged(indexWT,3));
            colori='r';
            if p<0.05, signifText='*'; elseif p<0.01, signifText='**'; else,  signifText='NS'; colori='k'; end
            
            text(1.5,max(ylim)*0.95,[signifText,' (p=',num2str(floor(p*1E3)/1E3),')'],'Color',colori)
                
            ylabel('RipplesPower/GammaPower (norm by mean)')
        end
    end
end

%% PlotErrorBarN

figure('Color',[1 1 1],'Position',scrsz);
for nn=1:length(structureName)
    for id=1:length(InfoDepth)
        for HigLow=1:length(UhighLow)
            
            
            tempMquAveraged=MquAveraged{nn,id,HigLow};
            indexWT=find(tempMquAveraged(:,2)==1); nWT=length(indexWT);
            indexKO=find(tempMquAveraged(:,2)==2); nKO=length(indexKO);
            
            subplot(length(structureName),length(InfoDepth)*length(UhighLow),(nn-1)*length(InfoDepth)*length(UhighLow)+(id-1)*length(UhighLow)+HigLow)
            title([structureName{nn},InfoDepth{id},UhighLow{HigLow}])
            
            A=nan(max(length(indexWT),length(indexKO)),2);
            A(1:length(indexWT),1)=tempMquAveraged(indexWT,3);
            A(1:length(indexKO),2)=tempMquAveraged(indexKO,3);
            
            hold on, p=PlotErrorBarN(A,0,0);
            set(gca,'XTick',1:2)
            set(gca,'XTickLabel',{['WT (n=',num2str(nWT),')'],['dKO (n=',num2str(nKO),')']})
            colori='r';
            if p<0.05, signifText='*'; elseif p<0.01, signifText='**'; else,  signifText='NS'; colori='k'; end
            text(1.5,max(ylim)*0.95,[signifText,' (p=',num2str(floor(p*1E3)/1E3),')'],'Color',colori)
            ylabel('RipplesPower/GammaPower (norm by mean)')
        end
    end
end

