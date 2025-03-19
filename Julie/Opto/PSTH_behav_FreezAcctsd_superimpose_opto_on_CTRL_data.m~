% PSTH_behav_FreezAcctsd_superimpose_opto_on_CTRL_data
% 10.01.2017

cd /media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/367-363-458-459/FreezAcctsdPSTH_ChR2_EXT_avg_2by2
load PSTH_behav_LaserChR2-fear-Jul-Oct_30s.mat

cd /media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/FreezAcctsdPSTH_ChR2_EXT_AllCS_avg2by2
load PSTH_behav_LaserChR2-fear.mat

% PreSound=[65:80]; % 15sec before sound
% Sound=[81:95]; % 15sec  
% %Sound=[81:110]; % 30sec  
% PostSound=[111:125];


QuantifFig=figure('Color',  [1 1 1], 'Position',[ 8  91  1819 887]);
n=4; p=3; a=1;
Mx={'C','P','E'};
if strcmp(CSoption,'4firstCS not averaged')
    ylabels={'first CS- pair';'second CS- pair';'first CS+ pair';'second CS+ pair'};
elseif strcmp(CSoption,'AllCS avg2by2')
    ylabels={'CS- pairs';' CS+ pairs 1:4';'CS+ pairs 5:8';'CS+ pairs 8:12'};
end

for m=1:length(StepName)
    for k=0:2:6
        %sub{a}=subplot(n,p,3*(k/2)+m);
        subplot(n,p,3*(k/2)+m);
        %subplot(sub{a})
        hold on
        eval(['A=[' Mx{m} num2str(k) ' ' Mx{m} num2str(k+1) '];' ]);
        
        N=size(A,2 );
        if ~iscell(A)
            tempA=A; A={};
            for i=1:size(tempA,2)
                A{i}=tempA(:,i);
            end
        end
        
        for i=1:N
            temp=A{i}(~isnan(A{i}));
            plot(i*ones(length(temp),1)+0.1,temp,'ko','markerfacecolor','g')
        end

        for i=1:N-1
            temp=A{i};
            tempi=A{i+1};
            try line(0.1+[i*ones(length(temp),1) (i+1)*ones(length(tempi),1)]',[temp tempi]','color','b'); end
        end

            
            
            
%             
%         eval(['PlotErrorbarN([' Mx{m} num2str(k) ' ' Mx{m} num2str(k+1) '],0,2);']);
%         
%         eval(['p_off=signrank(' Mx{m} num2str(k) '(:,1),' Mx{m} num2str(k) '(:,2));']);
%         eval(['p_on=signrank(' Mx{m} num2str(k+1) '(:,1),' Mx{m} num2str(k+1) '(:,2));']);
%         
%         eval(['p_snd=signrank(' Mx{m} num2str(k) '(:,2),' Mx{m} num2str(k+1) '(:,2));']);
%         eval(['p_post=signrank(' Mx{m} num2str(k) '(:,3),' Mx{m} num2str(k+1) '(:,3));']);
% 
%         ylim([0 1]);
%         YL=ylim;
%         text(1.5,0.7*YL(2),sprintf('%.2f',(p_off)),'Color','r'), line([1 2],[0.6*YL(2) 0.6*YL(2)],'Color','r');
%         text(4.5,0.7*YL(2),sprintf('%.2f',(p_on)),'Color','r'), line([4 5],[0.6*YL(2) 0.6*YL(2)],'Color','r');
%         text(3.5,1*YL(2),sprintf('%.2f',(p_snd)),'Color','b'), line([2 5],[0.92*YL(2) 0.92*YL(2)],'Color','b');
%         text(4.5,0.87*YL(2),sprintf('%.2f',(p_post)),'Color','b'), line([3 6],[0.8*YL(2) 0.8*YL(2)],'Color','b');
% 
%         set(gca,'XTick',[1:6],'XTickLabel',{'Pre','Snd','Post','Pre','Snd','Post'});
        
        a=a+1;
%         if k==0
%             title(StepName{m})
%         end
%         if k==6
%             xlabel(['n = ' num2str(size((MouseNbList{:,m}),1)) ' exp'])
%         end
%         ylabel(ylabels{k/2+1});
    end
end
subplot(sub{1})
text(-0.3,1.3,'FreezAcc','units','normalized')
text(-0.3,1.4,CSoption,'units','normalized')
text(-0.3,1.1,['snd ' num2str(SndDur) ' sec'],'units','normalized')

set(gcf,'PaperPosition',[ 0  0 27 18])
res=pwd;
saveas(gcf,['FreezAccPrePost_Sound' num2str(SndDur) 'sec_' StepName{1}(1:3) '_' CSoption(1:5) '.fig'])
saveas(gcf,['FreezAccPrePost_Sound' num2str(SndDur) 'sec_' StepName{1}(1:3) '_' CSoption(1:5)  '.png'])
saveFigure(QuantifFig,['FreezAccPrePost_Sound' num2str(SndDur)  's_' StepName{1}(1:3) '_' CSoption(1:5) ],res)   

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%