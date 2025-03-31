% ComputeFreezeAccEpoch
%10.01.2017

Dir=PathForExperimentFEAR('Fear-electrophy');
Dir = RestrictPathForExperiment(Dir,'nMice',[299]);

% Dir = RestrictPathForExperiment(Dir,'Group','CTRL');%

% Dir = RestrictPathForExperiment(Dir,'nMice',[394 395 402 403 450 451]);%
% 
% Dir=PathForExperimentFEAR('Fear-electrophy-opto');
% Dir = RestrictPathForExperiment(Dir,'nMice',[363 367 458 459]);
% %Dir = RestrictPathForExperiment(Dir,'nMice',[465 466 467 468]);

Mousename='MXXX';
for man=1:length(Dir.path) 
    
    Dir.path{man}
    cd(Dir.path{man})
    res=pwd;
    doaccelero=1;
    
    %% 1 - load or compute MovAcctsd
    if ~isempty(strfind(Dir.path{man},'Mouse363/20160714-HAB-envC-laser4')) ||~isempty(strfind(Dir.path{man},'Mouse-363/20160714-HAB-envC-laser4'))
        % use Movtsd because pb intan -> accelero data not available for a long period

        disp('it s not possible to compute FreezeAccEpoch because of a large noise on MovAcctsd')
    else
        try % load MovAcctsd
            temp=load([res '/behavResources.mat'], 'MovAcctsd');
            MovAcctsd=temp.MovAcctsd;
            disp('MovAcctsd already present in behavResources')
            
        catch % compute  MovAcctsd
            
            
            disp('compute FreezeAccEpoch from Accelerometer')
            load LFPData/InfoLFP.mat
            disp('Get Accelerometer info from INTAN data')
            
            cha=InfoLFP.channel(strcmp(InfoLFP.structure,'Accelero'));
            if isempty(cha),cha=InfoLFP.channel(strcmp(InfoLFP.structure,'accelero'));end
            if isempty(cha)
                disp('No Accelero found in InfoLFP.mat')
                disp('Get accelero LFP.mat')

                [listfile,pathffile]=uigetfile('*.*','Get accelero LFP.mat','MultiSelect','on');
                if listfile==0
                     disp('No Accelero - skip')
                     doaccelero=0;
                else
                    clear X Y Z
                    disp('... Loading LFP.mat (wait!)')
                    X=load([pathffile,listfile{1}],'LFP');
                    Y=load([pathffile,listfile{2}],'LFP');
                    Z=load([pathffile,listfile{3}],'LFP');
                end

            else
                clear X Y Z
                disp('... Loading LFP.mat (wait!)')
                X=load(['LFPData/LFP',num2str(cha(1)),'.mat'],'LFP');
                Y=load(['LFPData/LFP',num2str(cha(2)),'.mat'],'LFP');
                Z=load(['LFPData/LFP',num2str(cha(3)),'.mat'],'LFP');
            end
            
            if doaccelero
                disp('... Creating movement Vector')
                MX=Data(X.LFP);
                MY=Data(Y.LFP);
                MZ=Data(Z.LFP);
                Rg=Range(X.LFP);
                Acc=MX.*MX+MY.*MY+MZ.*MZ;
                %Acc=sqrt(MX.*MX+MY.*MY+MZ.*MZ);
                disp('... DownSampling at 50Hz');
                MovAcctsd=tsd(Rg(1:25:end),double(abs([0;diff(Acc(1:25:end))])));

                hacc=figure('Color',[1 1 1],'Position',[635  625 1285 349]); plot(Range(MovAcctsd,'s'),abs(Data(MovAcctsd)))
                title(Dir.path{man}); 
                xlim([0 max(Range(MovAcctsd,'s'))]);

                xlabel('Time (s)'); ylabel('abs(diff(X^2+Y^2+Z^2))');
                saveas(hacc,'MovAcctsd.fig')
                MovAcctsdDoneWithComputeFreezeAccEpoch=1;
                save('behavResources','MovAcctsd','MovAcctsdDoneWithComputeFreezeAccEpoch','-append')
                disp('Done')
            end

        end
       
    
        %% 2 - Compute FreezAccEpoch
        if doaccelero
            try 
                temp=load([res '/behavResources.mat'], 'FreezeAccEpoch');
                FreezeAccEpoch=temp.FreezeAccEpoch;
                disp('FreezeAccEpoch already present in behavResources')
            catch
                disp ('compute FreezeAccEpoch from MovAcctsd')
                th_immob_Acc=3E7;% see EstablishAThresholdForFreezingFromAcceleration.m
                th_2merge_FreezAcc=0.5;
                thtps_immob_Acc=2;
                SmoothFactorAcc=3;
                MovAccSmotsd=tsd(Range(MovAcctsd),SmoothDec(Data(MovAcctsd),SmoothFactorAcc));
                FreezeAccEpoch=thresholdIntervals(MovAccSmotsd,th_immob_Acc,'Direction','Below');
                FreezeAccEpoch=mergeCloseIntervals(FreezeAccEpoch,th_2merge_FreezAcc*1E4);
                FreezeAccEpoch=dropShortIntervals(FreezeAccEpoch,thtps_immob_Acc*1E4);
                disp('Saving FreezeAccEpoch')

                save behavResources FreezeAccEpoch MovAccSmotsd th_immob_Acc thtps_immob_Acc th_2merge_FreezAcc SmoothFactorAcc -Append
            end
        end
    end 
    clear FreezeAccEpoch MovAcctsd MovAccSmotsd
end