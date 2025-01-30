%  ParcoursCompLFPLastLR
% -------------------------------------------------------------------------

try
    cd H:\Data_Astros_Field
    catch
    cd /Users/karimbenchenane/Documents/Data/Lisa/Data_Astros_Field
end

try 
    
            load ResultsCompLFP

catch


            binCrossT=[];
            binCrossT2=[];
            binCohrT=[];
            binCohrT2=[];
            cellnamesCross={};
            cellnamesCohr={};
            NomSuccess={};
            successCross={};
            successCohr={};
            RlagZero=[];


            a=1;
            k=1;
            j=1;

            try 
                freq;
                catch
                freq=10000;
            end




            listdir=dir;

            for i=1:length(listdir)

                    try
                        cd H:\Data_Astros_Field
                        catch
                        cd /Users/karimbenchenane/Documents/Data/Lisa/Data_Astros_Field
                    end


                    if listdir(i).isdir==1&listdir(i).name(1)~='.'

                            %  	disp('ok step 1')

                                eval (['cd ',listdir(i).name])
                %                 pwd
                            %     cd (listdir(i).name)

                                        nom=listdir(i).name;
                                        le=length(listdir(i).name);
            % -------------------------------------------------------------------------

                                        NomSuccess{a}=nom;
                                        disp(nom)  

            %  ------------------------------------------------------------------------
            % Coherence
            % ------------------------------------------------------------------------
                                    try

                                            [C,CP,f,p,phi]=CoherencyAstroFieldforLoopLR;
                                                close all
                                                disp('Coherency ok')

                                            [binCohr,lCohr]=PoolData(C,f,[0:0.005:0.1]);
                                            binCohrT=[binCohrT;binCohr];
                                                disp('PoolData Coherency ok')

                                            [binCohr2,lCohr2]=PoolData(CP,f,[0:0.005:0.1]);
                                            binCohrT2=[binCohrT2;binCohr2];
                                                disp('PoolData Coherency2 ok')

                                                successCohr{a}='yes';
                                                cellnamesCohr{j}=nom;
                                                j=j+1;

                                    catch

            %                            binCohr=[];          % je voudrais pouvoir ajouter une ligne vide...
            %                            binCohr2=[];
            %                            binCohrT=[binCohrT;binCohr];
            %                            binCohrT2=[binCohrT2;binCohr2];

                                         successCohr{a}='no';

                                    end

            % 
            % -------------------------------------------------------------------------
            % CrossCorrelogramme
            % ------------------------------------------------------------------------


                                    try
                                        % Analyse du croscorrelogramme:

                                        [Cr,Cp,P,lags,CRm,CRM,r,p]=CorrAstroFieldforLoopLR;
                                            close all
                                            disp('Corr ok')
                                        [binCross,lCross]=PoolData(Cr,lags,[-200:10:200]);
                                            disp('PoolData Corr ok')
                                        [binCross2,lCross2]=PoolData(Cp,lags,[-200:10:200]);
                                            disp('PoolData Corr ok')

                                        binCrossT=[binCrossT;binCross];
                                        binCrossT2=[binCrossT2;binCross2];
                                        RlagZero=[RlagZero;[r p]];
                                            disp('Data added ok')

                                        successCross{a}='yes';
                                        cellnamesCross{k}=nom;
                                        k=k+1;


                                    catch
                            %             
            %                             binCross=[];        %comment ajouter un vecteur vide?
            %                             binCross2=[];
            %                             binCrossT=[binCrossT;binCross];
            %                             binCrossT2=[binCrossT2;binCross2];
                                        RlagZero=[RlagZero;[0 0]];

                                        successCross{a}='no';


                                    end   

            % ------------------------------------------------------------------------


                          a=a+1;


                    end
            end

            % ------------------------------------------------------------------------
            % Sauvegarde:ResultsCompLFP
            % ------------------------------------------------------------------------

            try
                cd H:\Data_Astros_Field
            catch
                cd /Users/karimbenchenane/Documents/Data/Lisa/Data_Astros_Field
            end

            save ResultsCompLFP cellnamesCross cellnamesCohr NomSuccess binCrossT binCrossT2 binCohrT binCohrT2 lCross lCross2 lCohr lCohr2 successCross successCohr RlagZero

            % ------------------------------------------------------------------------
            % -------------------------------------------------------------------------

end




% ------------------------------------------------------------------------
% -------------------------------------------------------------------------
% NomSuccess
fid = fopen('NomSuccess','w');

for i=1:length(NomSuccess)
    
    fprintf(fid,'%s\r\n',num2str(NomSuccess{i}));

end

fclose(fid);
% -------------------------------------------------------------------------
% successCross
fid = fopen('successCross','w');

for i=1:length(successCross)
    
    fprintf(fid,'%s\r\n',num2str(successCross{i}));

end

fclose(fid);
% -------------------------------------------------------------------------
% successCohr
fid = fopen('successCohr','w');

for i=1:length(successCohr)
    
    fprintf(fid,'%s\r\n',num2str(successCohr{i}));

end

fclose(fid);
% -------------------------------------------------------------------------
% cellnamesCohr
fid = fopen('cellnamesCohr','w');

for i=1:length(cellnamesCohr)
    
    fprintf(fid,'%s\r\n',num2str(cellnamesCohr{i}));

end

fclose(fid);
% -------------------------------------------------------------------------
% cellnamesCross
fid = fopen('cellnamesCross','w');

for i=1:length(cellnamesCross)
    
    fprintf(fid,'%s\r\n',num2str(cellnamesCross{i}));

end

fclose(fid);
% -----------------------------------------------------------------------

% RlagZero:

fid = fopen('RlagZero','w');

for i=1:length(RlagZero)
    
    fprintf(fid,'%s\r\n',num2str(RlagZero(i,1)));

end

fclose(fid);
% -----------------------------------------------------------------------
% PlagZero

fid = fopen('PlagZero','w');

for i=1:length(RlagZero)
    
    fprintf(fid,'%s\r\n',num2str(RlagZero(i,2)));

end

fclose(fid);

% -------------------------------------------------------------------------
% -------------------------------------------------------------------------

% ------------------------------------------------------------------------
% FIGURES FINALES
% ------------------------------------------------------------------------
try
	cd H:\Data_Astros_Field
catch
    cd /Users/karimbenchenane/Documents/Data/Lisa/Data_Astros_Field
end

% ------------------------------------------------------------------------

% Figures Crosscorr pour toutes les valeurs de correlation 


% Figure 1:

            figure, imagesc(lCross,[1:size(binCrossT,1)],binCrossT)
            hold on, line([0 0],[0.5 size(binCrossT,1)+05],'Color','k','linewidth',2)

% Figure 2:

            figure,plot(lCross,mean(binCrossT))
            % savefigure(1,'CrossCorrTotColor','H:\Data_Astros_Field')
            % savefigure(2,'CrossCorrTotMean','H:\Data_Astros_Field')

                set(1,'paperPositionMode','auto')

                eval(['print -f',num2str(1),' -dpng ','CrossCorrTotColor','.png'])

                eval(['print -f',num2str(1),' -painters',' -depsc2 ','CrossCorrTotColor','.eps'])


                set(2,'paperPositionMode','auto')

                eval(['print -f',num2str(2),' -dpng ','CrossCorrTotMean','.png'])

                eval(['print -f',num2str(2),' -painters',' -depsc2 ','CrossCorrTotMean','.eps'])



% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
% Modification Karim-----------------------------------------------------
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------


                                        smo=[0.001 1.5];
                                        binCrossTz=binCrossT;
                                        binCrossTz(isnan(binCrossTz))=0;
                                        binCrossTz=zscore(binCrossTz')';


                                        [MTz,MidTz]=max(binCrossTz');
                                        [mTz,midTz]=min(binCrossTz');
                                        [BE,id]=sort(lCross(MidTz));
                                        lCrossMz=lCross(MidTz);
                                        lCrossmz=lCross(midTz);

                                        % figure('color',[1 1 1])
                                        % imagesc(lCross,[1:size(binCrossTz,1)],binCrossTz(id,:))
                                        % hold on, line([0 0],[0.5 size(binCrossTz,1)+05],'Color','k','linewidth',2)
                                        % hold on, plot(lCrossMz(id), [1:size(binCrossT,1)],'ko','MarkerFaceColor','k')
                                        % hold on, plot(lCrossmz(id), [1:size(binCrossT,1)],'wo','MarkerFaceColor','w')


                                        % ------------------------------------------------------------------------

                                        binCrossTzs=SmoothDec(binCrossTz,smo);

                                        [MTzs,MidTzs]=max(binCrossTzs');
                                        [mTzs,midTzs]=min(binCrossTzs');
                                        [BE,ids]=sort(lCross(MidTzs));
                                        lCrossMzs=lCross(MidTzs);
                                        lCrossmzs=lCross(midTzs);


                                        % [MTzsP,MidTzsP]=max(binCrossTzs(:,lCross>0)');
                                        % [mTzsP,midTzsP]=min(binCrossTzs(:,lCross>0)');
                                        % [MTzsN,MidTzsN]=max(binCrossTzs(:,lCross<0)');
                                        % [mTzsN,midTzsN]=min(binCrossTzs(:,lCross<0)');
                                        % lCrossP=lCross(lCross>0);
                                        % lCrossN=lCross(lCross<0);
                                        % lCrossMzsP=lCrossP(MidTzsP);
                                        % lCrossmzsP=lCrossP(midTzsP);
                                        % lCrossMzsN=lCrossN(MidTzsN);
                                        % lCrossmzsN=lCrossN(midTzsN);


                                        % figure('color',[1 1 1])
                                        % imagesc(lCross,[1:size(binCrossTz,1)],binCrossTzs(ids,:))
                                        % hold on, line([0 0],[0.5 size(binCrossTz,1)+05],'Color','k','linewidth',2)
                                        % hold on, plot(lCrossMzs(ids), [1:size(binCrossT,1)],'ko','MarkerFaceColor','k')
                                        % hold on, plot(lCrossmzs(ids), [1:size(binCrossT,1)],'wo','MarkerFaceColor','w')

                                        % hold on, plot(lCrossMzsP(ids), [1:size(binCrossT,1)],'-ko','MarkerFaceColor','k','linewidth',2)
                                        % hold on, plot(lCrossmzsP(ids), [1:size(binCrossT,1)],'-wo','MarkerFaceColor','w','linewidth',2)
                                        % hold on, plot(lCrossMzsN(ids), [1:size(binCrossT,1)],'-ko','MarkerFaceColor','k','linewidth',2)
                                        % hold on, plot(lCrossmzsN(ids), [1:size(binCrossT,1)],'-wo','MarkerFaceColor','w','linewidth',2)
                                        % ------------------------------------------------------------------------





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

                                        thpeaksP=thpeaksP(find(binCrossTzs(ids(i),idxpeaksP)>0));
                                        thpeaksN=thpeaksN(find(binCrossTzs(ids(i),idxpeaksN)>0));
                                        % 
                                        %     thpeaks=[thpeaksN,thpeaksP];

                                        if length(thpeaksP)==0
                                            thpeaksP=thpeaks(find(thpeaks>0));
                                        end

                                        if length(thpeaksN)==0
                                            thpeaksN=thpeaks(find(thpeaks<0));
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

%                               Figure 3:

                                        [BE,indx]=sort(Ppr0);
                                        figure('color',[1 1 1])
                                        imagesc(lCross,[1:size(binCrossTz,1)],binCrossTzs(ids(indx),:))
                                        hold on, line([0 0],[0.5 size(binCrossTz,1)+05],'Color','k','linewidth',2)
                                        % hold on, plot(PMax, [1:size(binCrossTz,1)],'-ko','MarkerFaceColor','k','linewidth',2)
                                        hold on, plot(Ppr0(indx), [1:size(binCrossTz,1)],'-ko','MarkerFaceColor','k','linewidth',2)
                                        hold on, plot(Tpr0(indx), [1:size(binCrossTz,1)],'-wo','MarkerFaceColor','w','linewidth',2)
                                        
                                        num=gcf;
                                                
                                                set(num,'paperPositionMode','auto')

                                                eval(['print -f',num2str(num),' -dpng ','CrossTzKB','.png'])

                                                eval(['print -f',num2str(num),' -painters',' -depsc2 ','CrossTzKB','.eps'])

                                        % ------------------------------------------------------------------------


%                               Figure 4:

                                        figure('color',[1 1 1])
                                        plot(lCross,smooth(mean(binCrossTz),3))
                                        hold on, plot(lCross,mean(binCrossTzs),'r')
                                        yl=ylim;
                                        hold on, line([0 0],[yl(1) yl(2)],'Color','k','linewidth',2)
                                        
                                        num=gcf;
                                                
                                                set(num,'paperPositionMode','auto')

                                                eval(['print -f',num2str(num),' -dpng ','CrossTzMeanKB','.png'])

                                                eval(['print -f',num2str(num),' -painters',' -depsc2 ','CrossTzMeanKB','.eps'])

% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
% ------------------------------------------------------------------------
% ------------------------------------------------------------------------
    
% close all

% Figures Crosscorr pour les valeurs de correlation significatives uniquement

% Figure 5:

            figure, imagesc(lCross2,[1:size(binCrossT2,1)],binCrossT2)
            hold on, line([0 0],[0.5 size(binCrossT2,1)+0.5],'Color','k','linewidth',2)

            num=gcf;

% Figure 6:
    
            figure,plot(lCross2,mean(binCrossT2))
            % savefigure (1,'CrossCorrTotColor2','H:\Data_Astros_Field')
            % savefigure (2,'CrossCorrTotMean2','H:\Data_Astros_Field')

                    set(num,'paperPositionMode','auto')

                    eval(['print -f',num2str(num),' -dpng ','CrossCorrTotColor2','.png'])

                    eval(['print -f',num2str(num),' -painters',' -depsc2 ','CrossCorrTotColor2','.eps'])


                    set(num+1,'paperPositionMode','auto')

                    eval(['print -f',num2str(num+1),' -dpng ','CrossCorrTotMean2','.png'])

                    eval(['print -f',num2str(num+1),' -painters',' -depsc2 ','CrossCorrTotMean2','.eps'])


        % close all
        
% -------------------------------------------------------------------------
        % Coherence (toutes les valeurs)



        % Without ligne 4
        binCohrT=binCohrT([[1:3],[5:end]],:);
        binCohrT2=binCohrT2([[1:3],[5:end]],:);
        
% Figure 7:
        
        figure, imagesc(lCohr,[1:size(binCohrT,1)],binCohrT)
        
        num=gcf;
        
% Figure 8:
 
        figure,plot(lCohr,mean(binCohrT))
        % savefigure (1,'CoherencyTotColor','H:\Data_Astros_Field')
        % savefigure (2,'CoherencyTotMean','H:\Data_Astros_Field')

            set(num,'paperPositionMode','auto')

            eval(['print -f',num2str(num),' -dpng ','CoherencyTotColor','.png'])

            eval(['print -f',num2str(num),' -painters',' -depsc2 ','CoherencyTotColor','.eps'])


            set(num+1,'paperPositionMode','auto')

            eval(['print -f',num2str(num+1),' -dpng ','CoherencyTotMean','.png'])

            eval(['print -f',num2str(num+1),' -painters',' -depsc2 ','CoherencyTotMean','.eps'])

% close all

% -------------------------------------------------------------------------
        % Coherence (valeurs significatives)


% Figure 9:
            figure, imagesc(lCohr2,[1:size(binCohrT2,1)],binCohrT2)
            
            num=gcf;
            
% Figure 10:            
            figure,plot(lCohr2,mean(binCohrT2))
            % savefigure (1,'CoherencyTotColor2','H:\Data_Astros_Field')
            % savefigure (2,'CoherencyTotMean2','H:\Data_Astros_Field')

                    set(num,'paperPositionMode','auto')

                    eval(['print -f',num2str(num),' -dpng ','CoherencyTotColor2','.png'])

                    eval(['print -f',num2str(num),' -painters',' -depsc2 ','CoherencyTotColor2','.eps'])


                    set(num+1,'paperPositionMode','auto')

                    eval(['print -f',num2str(num+1),' -dpng ','CoherencyTotMean2','.png'])

                    eval(['print -f',num2str(num+1),' -painters',' -depsc2 ','CoherencyTotMean2','.eps'])

                % close all





