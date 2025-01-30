% Script_20170110_to_fullfill_dataset_with_CS_info.m

% 10.01.2017

%% Fill 394 and 395 with TTL from 450
if 0
    cd /media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse450/FEAR-Mouse-450-EXT-24-envB_161026_174952
    load behavResources csm csp 

    Dir=PathForExperimentFEAR('Fear-electrophy');
    Dir = RestrictPathForExperiment(Dir,'nMice',[394 395]);%

    for man=1:length(Dir.path) 

            cd ([Dir.path{man}])
            try 
                temp=load('behavResources','csm','csp');
                temp.csm;
                temp.csp;
            catch
                save behavResources csm csp -Append
            end
    end
end
%% fill 299 with CS info from DIG (from digitalin.dat)
cd /media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse299/20151217-EXT-24h-envC
load behavResources  DIG2 DIG8
digT2=Range(DIG2)*1E-4; % csm
digT8=Range(DIG8)*1E-4; % csp

DiffTimes=diff(digT2);
ind=DiffTimes>2;
ind(end)=[];
csm=digT2([1; find(ind)+1]);

DiffTimes=diff(digT8);
ind=DiffTimes>4;
ind(end)=[];
csp=digT8([1; find(ind)+1]);

TTL_csm=digT2;
TTL_csp_bizarre=digT8;
save behavResources TTL_csm TTL_csp_bizarre csp csm -Append

%% fill 253 and 254 with CS info from DIG (from digitalin.dat)
if 0
    Dir=PathForExperimentFEAR('Fear-electrophy');
    Dir = RestrictPathForExperiment(Dir,'nMice',[253 254 ]);
    for man=1:length(Dir.path) 

        cd ([Dir.path{man}])
        load behavResources DIG1 DIG4
        
        digT4=Range(DIG4)*1E-4; % csm
        digT1=Range(DIG1)*1E-4; % csp
        % pr 253 CS+ = bip
        TTL=[[digT4;digT1] [3*ones(size(digT4)); 4*ones(size(digT1))]];
        CSpluCode=4; %bip
        CSminCode=3; %White Noise
        
        % pr 254 CS+ = white noise
        TTL=[[digT4;digT1] [4*ones(size(digT4)); 3*ones(size(digT1))]];
        CSpluCode=3;
        CSminCode=4;

        DiffTimes=diff(TTL(:,1));
        ind=DiffTimes>2;
        times=TTL(:,1);
        event=TTL(:,2);
        CStimes=times([1; find(ind)+1]);  %temps du premier TTL de chaque s�rie de son
        CSevent=event([1; find(ind)+1]);  %valeur du premier TTL de chaque s�rie de son (CS+ ou CS-)


        csp=CStimes(CSevent==CSpluCode);
        csm=CStimes(CSevent==CSminCode);
        save behavResources TTL csp csm CStimes CSevent CSminCode CSpluCode -Append
    end
end

%% fill 243 and 244 with CS info from DIG (from digitalin.dat)
% cd /media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse243/20150506-EXT-24h-envC
if 0
    Dir=PathForExperimentFEAR('Fear-electrophy');
    Dir = RestrictPathForExperiment(Dir,'nMice',[243 244 ]);
    for man=1:length(Dir.path) 

        cd ([Dir.path{man}])
        try 
            temp=load('behavResources','csm','csp');
            temp.csm;
            temp.csp;
        catch  
            temp=load('behavResources');
            save behavResources_sauv temp
            load behavResources DIG1 DIG4
            csp=Range(DIG1)*1E-4;
            csm=Range(DIG4)*1E-4;
            save behavResources csp csm -Append
        end
    end
end
%% fill 248 with CS info from CSPLUS et CSMOINS (likely from STIMINFO somewhere)

if 0
    Dir=PathForExperimentFEAR('Fear-electrophy');
    Dir = RestrictPathForExperiment(Dir,'nMice',[248]);
    for man=1:length(Dir.path) 

        cd ([Dir.path{man}])
        try 
            temp=load('behavResources','csm','csp');
            temp.csm;
            temp.csp;
        catch  
            temp=load('behavResources');
            save behavResources_sauv temp
            load behavResources CSPLUS CSMOINS
            csp=CSPLUS;
            csm=CSMOINS;
            save behavResources csp csm -Append
        end
    end
end