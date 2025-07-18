
function [MeanBinCross,IndexGlobal,Ppr0,Tpr0]=AnalysisBinCross(binCrossT,lCross)

smo=[0.001 0.5];
binCrossTz=binCrossT;
binCrossTz(isnan(binCrossTz))=0;
binCrossTz=zscore(binCrossTz')';


[MTz,MidTz]=max(binCrossTz');
[mTz,midTz]=min(binCrossTz');
[BE,id]=sort(lCross(MidTz));
lCrossMz=lCross(MidTz);
lCrossmz=lCross(midTz);

% ------------------------------------------------------------------------

binCrossTzs=SmoothDec(binCrossTz,smo);

[MTzs,MidTzs]=max(binCrossTzs');
[mTzs,midTzs]=min(binCrossTzs');
[BE,ids]=sort(lCross(MidTzs));
lCrossMzs=lCross(MidTzs);
lCrossmzs=lCross(midTzs);

% ------------------------------------------------------------------------


MeanBinCross=mean(binCrossTz);


% try

            for i=1:size(binCrossTz,1)

            dth = diff(binCrossTzs(ids(i),:));
            dth1 = [0 dth];
            dth2 = [dth 0];
            clear dth;

            thpeaks = lCross(find(dth1 > 0 & dth2 < 0));
            
            
            thpeaksP=thpeaks(find(thpeaks>0));
            thpeaksN=thpeaks(find(thpeaks<0));

            for z=1:length(thpeaksP)
            idxpeaksP(z)=find(lCross==thpeaksP(z));
            end

            for z=1:length(thpeaksN)
            idxpeaksN(z)=find(lCross==thpeaksN(z));
            end
            
            try
            thpeaksP=thpeaksP(find(binCrossTzs(ids(i),idxpeaksP)>0));
            thpeaksN=thpeaksN(find(binCrossTzs(ids(i),idxpeaksN)>0));
            % catch
            %     keyboard
            end

            % 
            %     thpeaks=[thpeaksN,thpeaksP];

            if length(thpeaksP)==0
            thpeaksP=thpeaks(find(thpeaks>0));
            end

            if length(thpeaksP)==0
            thpeaksP=lCross(end);
            end
            
            
            if length(thpeaksN)==0
            thpeaksN=thpeaks(find(thpeaks<0));
            end
            
             if length(thpeaksN)==0
            thpeaksN=lCross(1);
            end

            clear idxpeaksP
            clear idxpeaksN

            thpeaksP=min(abs(thpeaksP));    
            thpeaksN=-min(abs(thpeaksN));
           
            M1=binCrossTzs(ids(i),find(lCross==thpeaksP));
            M2=binCrossTzs(ids(i),find(lCross==thpeaksN));

            % PMax(i)=lCross(find(binCrossTz(ids(i),:)==max(M1,M2)));
            [temp,idx]=min(abs([lCross(find(binCrossTzs(ids(i),:)==M1)),lCross(find(binCrossTzs(ids(i),:)==M2))]));
            Ppr0(i)=(-1)^(idx-1)*temp;



            thtrough = lCross(find(dth1 < 0 & dth2 > 0));

            thtroughP=thtrough(find(thtrough>0));
            thtroughN=thtrough(find(thtrough<0));

            for z=1:length(thtroughP)
            idxtroughP(z)=find(lCross==thtroughP(z));
            end

            for z=1:length(thtroughN)
            idxtroughN(z)=find(lCross==thtroughN(z));
            end

            thtroughP=thtroughP(find(binCrossTzs(ids(i),idxtroughP)<0));
            thtroughN=thtroughN(find(binCrossTzs(ids(i),idxtroughN)<0));

            if length(thtroughP)==0
            thtroughP=thtrough(find(thtrough>0));
            end

            if length(thtroughN)==0
            thtroughN=thtrough(find(thtrough<0));
            end

            %     thtrough=[thtroughN,thtroughP];

            clear idxtroughP
            clear idxtroughN    

            thtroughP=min(abs(thtroughP)); 
            thtroughN=-min(abs(thtroughN));

            M1=binCrossTzs(ids(i),find(lCross==thtroughP));
            M2=binCrossTzs(ids(i),find(lCross==thtroughN));

            % TMax(i)=lCross(find(binCrossTz(ids(i),:)==min(M1,M2)));

            [temp,idx]=min(abs([lCross(find(binCrossTzs(ids(i),:)==M1)),lCross(find(binCrossTzs(ids(i),:)==M2))]));
            Tpr0(i)=(-1)^(idx-1)*temp;


            %     hold on, plot(thpeaks, i*ones(length(thpeaks),1),'k.')
            %     hold on, plot(thtrough, i*ones(length(thtrough),1),'w.')

            % keyboard

            end

            [BE,indx]=sort(Ppr0);
            figure('color',[1 1 1])                             %FIGURE 1
            imagesc(lCross,[1:size(binCrossTz,1)],binCrossTzs(ids(indx),:))
            hold on, line([0 0],[0.5 size(binCrossTz,1)+05],'Color','k','linewidth',2)
            % hold on, plot(PMax, [1:size(binCrossTz,1)],'-ko','MarkerFaceColor','k','linewidth',2)
            hold on, plot(Ppr0(indx), [1:size(binCrossTz,1)],'-ko','MarkerFaceColor','k','linewidth',2)
            hold on, plot(Tpr0(indx), [1:size(binCrossTz,1)],'-wo','MarkerFaceColor','w','linewidth',2)


            IndexGlobal=ids(indx);

            % ------------------------------------------------------------------------
            % Observation des pic et creux de l'oscillation du cross-correlogramme
            % Important suivre le pic le plus proche de zero
            % (vrai decalage des oscillations) 
            % ATENTION
            % A regarder en fonction de la frequence de l'oscillation
            % ------------------------------------------------------------------------
            if 0
                    [idmat,Pmat,Tmat,matr]=ObsBinCohrT10(binCrossT,1);    %FIGURE 2 and 3
                    xlim([-100 100])
                    figure('Color',[1 1 1])                             %FIGURE 4
                    imagesc(lCross,[1:size(binCrossT2,1)],binCrossT2(idmat,:))
                    hold on, line([0 0],[0.5 size(binCrossTz,1)+05],'Color','k','linewidth',2)
                    hold on, plot(Pmat(idmat),[1:size(binCrossTz,1)],'-ko','MarkerFaceColor','k','linewidth',2)
                    hold on, plot(Tmat(idmat),[1:size(binCrossTz,1)],'-wo','MarkerFaceColor','w','linewidth',2)
                    xlim([-100 100])
                    title('Significativity (green (p>0.05) -- Ranking according to the positive Peak the closest to zero')
            end

            % ------------------------------------------------------------------------ 
            % Histogram des décalages des signaux
            % ------------------------------------------------------------------------ 

            Binnns=[-70:5:70];
            Binnns=lCross;

            hp=hist(Ppr0,Binnns);
            ht=hist(Tpr0,Binnns);

            %%                      si tu veux que la courbe soit plus belle.......
            ss=3;
            hp=smooth(hp,ss);
            ht=smooth(ht,ss);   


            figure('Color',[1 1 1])                                %FIGURE 5
            a1=area(Binnns,hp);
            hold on, a2=area(Binnns,ht);
            set(a1,'FaceColor',[1 0.4 0.4])
            set(a2,'FaceColor',[0.4 0.4 1])
            alpha(0.8)
            ylh=ylim;
            hold on, line([0 0],[0 ylh(2)+0.5],'Color','k','linewidth',2)
            xlim([lCross(1) lCross(end)])
            title(['Median Peak: ',num2str(median(Ppr0)),',    Median trough: ',num2str(median(Tpr0)),',    Frequencey Cross-Corr: ',num2str(round(1/(mean(abs(Ppr0-Tpr0)))/2*1000)/1000),'Hz'])


            FreqCrossCorr=(abs(Ppr0-Tpr0))*2;
            FreqCrossCorr=1./(FreqCrossCorr);
            %                         figure('Color',[1 1 1])
            %                         plot(FreqCrossCorr)


            % ------------------------------------------------------------------------


            figure('color',[1 1 1])                                 %FIGURE 6
            plot(lCross,smooth(mean(binCrossTz),3))
            hold on, plot(lCross,mean(binCrossTzs),'r')
            yl=ylim;
            hold on, line([0 0],[yl(1) yl(2)],'Color','k','linewidth',2)
            hold on, line([lCross(1) lCross(end)],[0 0],'Color','k')

% 
% catch
%     
%     IndexGlobal=ids;
%     
% end



