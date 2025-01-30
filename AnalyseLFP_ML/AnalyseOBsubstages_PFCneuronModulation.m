%AnalyseOBsubstages_PFCneuronModulation.m

% see also
% 1. AnalyseOBsubstages_Bilan.m
% 2. AnalyseOBsubstages_BilanRespi.m
% 3. AnalyseOBsubstages_NREMsubstages.m
% 4. AnalyseOBsubstages_NREMsubstagesPlethysmo.m
% 5. AnalyseOBsubstages_Rhythms.m
% 6. AnalyseOBsubstages_SleepCycle.m
% 7. AnalyseOBsubstages_PFCneuronModulation.m

%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<<< GENERAL INPUTS <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

FolderToSave='/media/DataMOBsRAID/ProjetAstro/AnalyseOBsubstages/FiguresOBslowDistribSubstages/FiguresOBmodulatePFCneurons';
res='/media/DataMOBsRAID/ProjetAstro/AnalyseOBsubstages/AnalysesOB';

ZTh=[11,12.5; 16.5,18]*3600;%en second
freq=[2 4];

SavFig=1;

colori=[0.5 0.2 0.1;0.1 0.7 0 ;0.5 0.5 0.5 ;0 0 0;1 0 1 ];
Dir1=PathForExperimentsDeltaSleepNew('BASAL');
Dir1=RestrictPathForExperiment(Dir1,'nMice',[243 244 251 252]);
Dir2=PathForExperimentsML('BASAL');
Dir2=RestrictPathForExperiment(Dir2,'Group','WT');
Dir=MergePathForExperiment(Dir1,Dir2);

strains=unique(Dir.group);

%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<< PercModNeuronsInFctOfEpoch.m <<<<<<<<<<<<<<<<<<<<<<<
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% see ModulationPFCneuronsByLFP.m
% ModulationTheta.m

% ---------------------- INPUTS ---------------------------
Dir=RestrictPathForExperiment(Dir,'nMice',[243 244 251]);% 252 has no neurons
mice=unique(Dir.name);
%Analyname='AnalyseOBsubstages-PFCneuronModulation.mat';
Analyname='AnalyseOBsubstages-PFCneuronModulation-new.mat';
FreqRange =[2 5];
nameEp={'WAKE','REM','N1','N2','N3','wholeEpoch','NREM',...
    'HiOB','LoOB','N1wd','N2wd','N3wd','NREMwd'};%wd=without down states

% ---------------------- compute ---------------------------
clear MatKappa
try 
    load([res,'/',Analyname]); MatKappa;
    disp([Analyname,' already exists. Loaded.'])
   
catch
    MatKappa=nan(length(Dir.path),length(nameEp),100);
    MatPval=MatKappa; 
    MatFR=MatKappa; 
    MatFRz=MatKappa;
    MatMu=MatKappa;
    MatC=nan(length(Dir.path),length(nameEp),100,25);
    
    for man=1:length(Dir.path)
        %
        disp(' '); disp(Dir.path{man})
        cd(Dir.path{man})
        %%%%%%%%%%%%%%%%%%%% GET SUBSTAGES %%%%%%%%%%%%%%%%%%%%%%%%
        clear WAKE REM N1 N2 N3 noise wholeEpoch NREM
        disp('- RunSubstages.m')
        try [WAKE,REM,N1,N2,N3,~,~,noise]=RunSubstages;close;end
        NREM=or(or(N1,N2),N3);
        wholeEpoch=or(or(WAKE,REM),NREM);
        SLEEP=or(NREM,REM);
        %
        SLEEP=mergeCloseIntervals(SLEEP,1);
        wholeEpoch=mergeCloseIntervals(wholeEpoch,1);
        NREM=mergeCloseIntervals(NREM,1);
        
        %%%%%%%%%%%%%%%%%%%% GET Down states %%%%%%%%%%%%%%%%%%%%%%%%
        clear Down RemoDown N1wd N2wd N3wd NREMwd
        load DownSpk.mat Down
        tDown=ts(Start(Down));
        RemoDown=intervalSet(Start(Down)-100,Stop(Down)+100); %remove 100ms ou 10ms???
        N1wd=N1-RemoDown; N1wd=mergeCloseIntervals(N1wd,1);
        N2wd=N2-RemoDown; N2wd=mergeCloseIntervals(N2wd,1);
        N3wd=N3-RemoDown; N3wd=mergeCloseIntervals(N3wd,1);
        NREMwd=NREM-RemoDown; NREMwd=mergeCloseIntervals(NREMwd,1);
        
        
        if exist('N1','var')

            %%%%%%%%%%%%%%%%%%%% GET ZT %%%%%%%%%%%%%%%%%%%%%%%%%%
            clear NewtsdZT rgZT
            disp('... loading rec time with GetZT_ML.m')
            NewtsdZT=GetZT_ML(Dir.path{man});
            rgZT=Range(NewtsdZT);
            
            %%%%%%%%%%%%%%%%%% GET OB LFP 2-4z %%%%%%%%%%%%%%%%%%%
            clear channel LFP filOB
            disp('... loading and filtering LFP Bulb_deep')
            load ChannelsToAnalyse/Bulb_deep.mat channel
            eval(['load LFPData/LFP',num2str(channel),'.mat'])
            filOB=FilterLFP(LFP,FreqRange,2048);
            
            %%%%%%%%%%%%%%%%%% GET OB spectrum 2-4z %%%%%%%%%%%%%%%%%%%
            clear Sptsd t f Sp HiOB LoOB
            disp('... loading spectrum Bulb_deep')
            eval(['load SpectrumDataL/Spectrum',num2str(channel),'.mat'])
            Sptsd=tsd(t*1E4,mean(Sp(:,find(f>=FreqRange(1) & f<FreqRange(2))),2));
            temp=Data(Restrict(Sptsd,SLEEP));
            [y,x]=hist(temp,1000);
            LowThresh=x(min(find(cumsum(y)>0.2*sum(y))));
            HighThresh=x(min(find(cumsum(y)>0.8*sum(y))));
            
            HiOB=thresholdIntervals(Sptsd,HighThresh,'Direction','Above');
            HiOB=and(HiOB,SLEEP); HiOB=mergeCloseIntervals(HiOB,3*1E4); HiOB=dropShortIntervals(HiOB,2*1E4);
            LoOB=thresholdIntervals(Sptsd,LowThresh,'Direction','Below');
            LoOB=and(LoOB,SLEEP); LoOB=mergeCloseIntervals(LoOB,3*1E4); LoOB=dropShortIntervals(LoOB,2*1E4);
            
            % %%%%%%%%%%%%%%%%%%%% GET PFCx SPIKES %%%%%%%%%%%%%%%%%%
            disp('... loading Spikes from PFCx')
            [S,numNeurons,numtt,TT]=GetSpikesFromStructure('PFCx');
            % remove MUA from the analysis
            nN=numNeurons;
            for s=1:length(numNeurons)
                if TT{numNeurons(s)}(2)==1
                    nN(nN==numNeurons(s))=[];
                end
            end
            disp(sprintf('there are %d PFCx neurons',length(nN)))
            
            % %%%%%%%%%%%%%%%%%%%%%%% GET FR %%%%%%%%%%%%%%%%%%%%%%%%%%
            disp('... Calculating instantaneous FR')
            % calculate instataneous firing rate
            t_step=0:0.1:max(Range(filOB,'s'));
            InstantFR=nan(length(nN),length(t_step));
            iFRz=nan(length(nN),length(t_step));
            for s=1:length(nN)
                InstantFR(s,:)=hist(Range(S{nN(s)},'s'),t_step);
                iFRz(s,:)=zscore(hist(Range(S{nN(s)},'s'),t_step));
            end
            tsdFRz=tsd(t_step*1E4,iFRz');
            
            % %%%%%%%%%%%%%%%%%%% Compute Modulation %%%%%%%%%%%%%%%%%%%%
            for n=1:length(nameEp)
                eval(['epoch=',nameEp{n},';'])
                durEp=sum(Stop(epoch,'s')-Start(epoch,'s'));
                disp(nameEp{n})
                MatFRz(man,n,1:length(nN))=nanmean(Data(Restrict(tsdFRz,epoch)))';
               
                for s=1:length(nN)+1
                    if s==length(nN)+1
                        if sum(strcmp(nameEp{n},{'N1','N2','N3','wholeEpoch','NREM', 'HiOB','LoOB'}))
                            % down state modulated by OB
                            [ph,mu, Kappa, pval,B,C]=ModulationTheta(tDown,filOB,epoch,25,1);
                            text(-1,1.05*max(ylim),sprintf([nameEp{n},' %d DOWN'],man)); 
                            nb=length(Range(Restrict(tDown,epoch)));
                        else
                            nb=NaN; Kappa=NaN; pval=NaN; mu=NaN; C=nan(1,25);
                        end
                    else
                        [ph,mu, Kappa, pval,B,C]=ModulationTheta(S{nN(s)},filOB,epoch,25,1);
                        nb=length(Range(Restrict(S{nN(s)},epoch)));
                    end
                    % mu = circular_mean phase, kappa= strength of modulation
                    MatFR(man,n,s)=nb/durEp;
                    MatKappa(man,n,s)=Kappa;
                    MatPval(man,n,s)=pval;
                    MatMu(man,n,s)=mu;
                    MatC(man,n,s,:)=C;
                    % plot best modulated neurons
                     
                    if s<=length(nN) && sum(strcmp(nameEp{n},{'REM','wholeEpoch','NREM'})) && Kappa>0.15 && nb>5E3
                        text(-1,1.05*max(ylim),sprintf([nameEp{n},' %d #%d'],man,nN(s)));
                    else
                        if s<=length(nN), close;end
                    end
                end
                 
                
                
            end
            disp('Done.')
        else 
            disp('Problem, skip.')
        end
    end
    disp(['saving in ',Analyname])
    save([res,'/',Analyname],'MatKappa','MatPval','MatFR','MatFRz','MatMu','MatC','FreqRange','nameEp','Dir','B'); 
end

%% plot Bilan
ThreshKappa=0.06;
L=[1:5,8,9];


tempKa=[];tempP=[];tempFR=[];tempMu=[];
for man=1:length(Dir.path)
    temp=squeeze(MatKappa(man,L,:)); 
    N=max(find(~isnan(nanmean(temp))));
    tempKa=[tempKa,squeeze(MatKappa(man,L,1:N-1))];
    tempP=[tempP,squeeze(MatPval(man,L,1:N-1))];
    tempFR=[tempFR,squeeze(MatFR(man,L,1:N-1))];
    tempMu=[tempMu,squeeze(MatMu(man,L,1:N-1))];
end
%
Matbar=nan(length(L),2);
Matbar2=Matbar;Matbar3=Matbar;Matbar4=Matbar;
legKA={'Ranksum:'};legFR={'Ranksum:'};legMu={'Ranksum:'};
for n=1:length(L)
    iMod=find(tempP(n,:)<0.05);
    for n2=n+1:length(L)
        iMod2=find(tempP(n2,:)<0.05);
        p = ranksum(tempKa(n,iMod),tempKa(n2,iMod2));
        legKA=[legKA,sprintf([nameEp{L(n)},' vs ',nameEp{L(n2)},': n=%d, p=%1.4f'],length(iMod),p)];
        p = ranksum(tempFR(n,iMod),tempFR(n2,iMod2));
        legFR=[legFR,sprintf([nameEp{L(n)},' vs ',nameEp{L(n2)},': n=%d, p=%1.4f'],length(iMod),p)];
        p = ranksum(mod(2*pi+tempMu(n,iMod),2*pi),mod(2*pi+tempMu(n2,iMod2),2*pi));
        legMu=[legMu,sprintf([nameEp{L(n)},' vs ',nameEp{L(n2)},': n=%d, p=%1.4f'],length(iMod),p)];
    end
    Matbar(n,1:2)=[length(iMod),length(tempKa)];
    
    Matbar2(n,1)=nanmean(tempKa(n,iMod));
    Matbar2(n,2)=stdError(tempKa(n,iMod));
    
    Matbar3(n,1)=circ_mean(tempMu(n,iMod)');
    Matbar3(n,2)=circ_std(tempMu(n,iMod))/sqrt(iMod);
    
    Matbar4(n,1)=nanmean(tempFR(n,iMod));
    Matbar4(n,2)=stdError(tempFR(n,iMod));
    
end

figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.3 0.35 0.6])
subplot(3,4,1), bar([100*Matbar(:,1)./Matbar(:,2),100-100*Matbar(:,1)./Matbar(:,2)],'Stacked'); 
ylabel('% modulated neurons (p<0.05)'); title(sprintf('n=%d neurons, 3 mice, %d expe',mean(Matbar(:,2)),length(Dir.path)))
set(gca,'Xtick',1:length(L)); set(gca,'XtickLabel',nameEp(L))
colormap pink

subplot(3,4,2), bar(Matbar2(:,1)); 
hold on, errorbar(Matbar2(:,1),Matbar2(:,2),'+k');
ylabel('Kappa for neurons with p<0.05'); 
set(gca,'Xtick',1:length(L)); set(gca,'XtickLabel',nameEp(L))
subplot(3,4,[6 10]),text(-0.1,0.5,legKA); axis off

subplot(3,4,3), bar(mod(Matbar3(:,1)+2*pi,2*pi)); 
hold on, errorbar(mod(Matbar3(:,1)+2*pi,2*pi),Matbar3(:,2),'+k');
ylabel('mu for neurons with p<0.05'); ylim([0 2*pi])
set(gca,'Xtick',1:length(L)); set(gca,'XtickLabel',nameEp(L))
set(gca,'Ytick',[0 pi 2*pi]); set(gca,'YtickLabel',{'0' 'pi' '2pi'})
subplot(3,4,[7 11]),text(-0.1,0.5,legMu); axis off

subplot(3,4,4), bar(Matbar4(:,1)); 
hold on, errorbar(Matbar4(:,1),Matbar4(:,2),'+k');
ylabel('FR for neurons with p<0.05'); 
set(gca,'Xtick',1:length(L)); set(gca,'XtickLabel',nameEp(L))
subplot(3,4,[8 12]),text(-0.1,0.5,legFR); axis off


%% differentiate depending on Neuronal type (REM, WAKE,...)


ThreshKappa=0.06;
DoEP={'WAKE','REM','N1wd','N2wd','N3wd'};
L=[]; 
for ep=1:length(DoEP)
    L=[L,find(strcmp(DoEP{ep},nameEp))];
    MatN{ep}=[];
    Matperc{ep}=zeros(length(DoEP),2);
end

% identify neurons
for man=1:length(Dir.path)
    tempFR=squeeze(MatFR(man,L,:));
    N=max(find(~isnan(nanmean(tempFR))));
    tempFR=tempFR(:,1:N-1);
    tempP=squeeze(MatPval(man,L,1:N-1));
    idp=find(min(tempP)<0.05);
    
    [BE,id]=max(tempFR);
    for ep=1:length(DoEP)
        temp=MatN{ep};
        indtot=find(id==ep);
        ind=indtot(ismember(indtot,idp));
        MatN{ep}=[temp;[man*ones(length(ind),1),ind']];
    end
    
    % for % of modulated neurons
    for ep=1:length(DoEP)
        tPerc=Matperc{ep};
        indtot=find(id==ep);
        for n=1:length(L)
            ind=find(tempP(n,indtot)<0.05);
            tPerc(n,:)=tPerc(n,:)+[length(ind),length(indtot)];
        end
        Matperc{ep}=tPerc;
    end
    
end

clear Matbar2 Matbar3 Matbar2s Matbar3s Matbar4
for n=1:length(L)
    tempKa=squeeze(MatKappa(:,L(n),:));
    tempMu=squeeze(MatMu(:,L(n),:));
    
    for ep=1:length(DoEP),
        N=MatN{ep};
        temp2=[];temp3=[];
        for i=1:size(N,1), 
            temp2=[temp2,tempKa(N(i,1),N(i,2))];
            temp3=[temp3,tempMu(N(i,1),N(i,2))];
        end
        Matbar2(n,ep)= nanmean(temp2);
        Matbar2s(n,ep)= stdError(temp2);
        Matbar3(n,ep)= circ_mean(temp3');
        Matbar3s(n,ep)= circ_std(temp3')/sqrt(length(temp3));
        
        tPerc=Matperc{ep};
        Matbar4(n,ep)=100*tPerc(n,1)/tPerc(n,2);
    end
end
%
xbin=ones(5,1)*[-0.3 -0.15 0 0.15 0.3]+[1:5]'*ones(1,5);

figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.1 0.4 0.4]), 
subplot(2,3,1), bar(Matbar2)
hold on, errorbar(xbin,Matbar2,Matbar2s,'+k');
set(gca,'Xtick',1:length(L)); set(gca,'XtickLabel',nameEp(L))
xlabel('sleep phase'); ylabel('Kappa for neuron p<0.05')

subplot(2,3,2), bar(mod(Matbar3+2*pi,2*pi)); ylim([0 2*pi])
hold on, errorbar(xbin,mod(Matbar3+2*pi,2*pi),Matbar3s,'+k');
set(gca,'Xtick',1:length(L)); set(gca,'XtickLabel',nameEp(L))
set(gca,'Ytick',[0 pi 2*pi]); set(gca,'YtickLabel',{'0' 'pi' '2pi'})
xlabel('sleep phase');ylabel('mu for neuron p<0.05')
legend([DoEP,'Neuron','type'])

subplot(2,3,3), bar(Matbar4)
set(gca,'Xtick',1:length(L)); set(gca,'XtickLabel',nameEp(L))
xlabel('sleep phase');ylabel('% modulated neuron (p<0.05)')


subplot(2,3,4), bar(Matbar2')
hold on, errorbar(xbin,Matbar2',Matbar2s','+k');
set(gca,'Xtick',1:length(L)); set(gca,'XtickLabel',nameEp(L))
xlabel('Neuron types (prefered sleep phase = max FR)'); 
ylabel('Kappa for neuron p<0.05')

subplot(2,3,5), bar(mod(Matbar3'+2*pi,2*pi)); ylim([0 2*pi])
hold on, errorbar(xbin,mod(Matbar3'+2*pi,2*pi),Matbar3s','+k');
set(gca,'Xtick',1:length(L)); set(gca,'XtickLabel',nameEp(L))
set(gca,'Ytick',[0 pi 2*pi]); set(gca,'YtickLabel',{'0' 'pi' '2pi'})
xlabel('Neuron types (prefered sleep phase = max FR)'); 
ylabel('mu for neuron p<0.05')
legend([DoEP,'sleep','phase'])

subplot(2,3,6), bar(Matbar4')
set(gca,'Xtick',1:length(L)); set(gca,'XtickLabel',nameEp(L))
xlabel('Neuron types (prefered sleep phase = max FR)'); 
ylabel('% modulated neuron (p<0.05)')
colormap pink

%% Down States
%'MatKappa','MatPval','MatFR','MatFRz','MatMu'
figure('Color',[1 1 1]),
matK=nan(length(Dir.path),length(L));
matm=nan(length(Dir.path),length(L));
for n=1:length(L)
    subplot(1,length(L),n)
    tempD=[];
    for man=1:length(Dir.path)
        tempC=squeeze(MatC(man,n,:,:));
        N=max(find(~isnan(nanmean(tempC,2))));
        tempD=[tempD;tempC(N,:)];
        matK(man,n)=squeeze(MatKappa(man,n,N));
        matm(man,n)=squeeze(MatMu(man,n,N));
    end
    imagesc([B,2*pi+B],1:length(Dir.path),[tempD,tempD]);
    %imagesc([B,2*pi+B],1:length(Dir.path),zscore([tempD,tempD],0,2));
    xlabel('Phase of OB'); ylabel('#expe, (n=3)'); title(nameEp{n})
end

%%
for man=1:length(Dir.path)
    figure('Color',[1 1 1]),
    for n=1:length(L)
        subplot(1,length(L),n)
        tempC=squeeze(MatC(man,n,:,:));
        N=max(find(~isnan(nanmean(tempC,2))));
        tempC=tempC(1:N-1,:);
        imagesc([B,2*pi+B],1:size(tempC,1),zscore([tempC,tempC],0,2));
        xlabel('Phase of OB'); ylabel('#expe, (n=3)'); title(nameEp{n})
        if n==3, title({Dir.name{man},' ',nameEp{n}});end
    end
end

