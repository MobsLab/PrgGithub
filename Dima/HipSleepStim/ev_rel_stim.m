% ev_rel_stim.m

% To calculate and plot LFP phase-locked to stimulations averaged across
% days within one mouse


%% INPUTS
cd ('/media/mobsrick/DataMOBs71/Mouse-538/Results/ph_locked2');
res=pwd;

% Do you want to save? 0 = no, 1 = yes
sav_dat=1;
sav_fig=1;

% List of folders with the data
% Dir.path={
%     '/media/mobsrick/DataMOBs71/Mouse-534/09062017_SleepStim/FEAR-Mouse-534-09062017';
%     '/media/mobsrick/DataMOBs71/Mouse-534/12062017-SleepStim/FEAR-Mouse-534-12062017';
%     '/media/mobsrick/DataMOBs71/Mouse-534/14062017-SleepStim/FEAR-Mouse-534-14062017';
%     '/media/mobsrick/DataMOBs71/Mouse-534/15062017-SleepStim/FEAR-Mouse-534-15062017';
%     '/media/mobsrick/DataMOBs71/Mouse-534/16062017-SleepStim/FEAR-Mouse-534-16062017'
%     };

Dir.path={
    '/media/mobsrick/DataMOBs71/Mouse-538/06072017_SleepStim/FEAR-Mouse-538-06072017'
    };

for k=1:length(Dir.path)
    ind_mouse=strfind(Dir.path{k},'Mouse');
    Dir.name{k}=Dir.path{k}(ind_mouse:ind_mouse+8);
end

% Frequency list
fq_list = [1 2 4 7 10 13 15 20];
nb_fq = length(fq_list);

% for phase-locked averaging
mbin = 10; % Size of the bin
avtime = 30; % time to average in s
ncyc = 7; % number of cycles to show

% List of structures to plot and compute
structlist={'dHPC_rip', 'PFCx_deep', 'PFCx_deep_left', 'dHPC_deep', 'dHPC_rip_left', 'vHPC_rip'};

%% INITIALIZE
structlistname=structlist;
for i=1:length(structlistname)
    ind_und=strfind(structlistname{i},'_');
    structlistname{i}(ind_und)=' ';
end
man=1;

%% LOAD OR COMPUTE DATA

try
    load ('er_lfp.mat');
catch

er_lfp = cell(length(Dir.path),length(structlist),length(fq_list));
er_lfp_av = cell(length(structlist),length(fq_list));

    for man=1:length(Dir.path) 
        cd (Dir.path{man})
        MouseNb=str2num(Dir.name{man}(end-3:end));
        Mousename=['M' Dir.name{man}(end-3:end)]; 
        disp(Mousename)
        
        load StimInfo
        StimInfoAllMan{man}=StimInfo;
        
        for i=1:length(structlist)

            % Spectra calculation and saving
            if exist([Dir.path{man},'/ChannelsToAnalyse/',structlist{i},'.mat']) 
                temp=load([Dir.path{man},'/ChannelsToAnalyse/',structlist{i},'.mat']);
                    load([Dir.path{man},'/LFPData/LFP' num2str(temp.channel),'.mat']);
                    disp(['/LFPData/LFP' num2str(temp.channel),'... loaded']);

            else
                disp(['no LFP data for channel ' structlist{i} ' in this mouse ']);
            end
            
            % Calculation of power at the frequencies present in StimInfo

            for fq=1:nb_fq
                LaserInt =intervalSet(StimInfo.StartTime(StimInfo.Freq==fq_list(fq))*1E4,...
                    StimInfo.StopTime(StimInfo.Freq==fq_list(fq))*1E4);
                
                
                [m,s,tps] = mETAverage(Start(LaserInt), Range(LFP), Data(LFP),mbin,2*1000/mbin*avtime);
                ER = tsd(tps,m);
                er_lfp{man,i,fq} = ER;

            end

        end
    end
    
    % Averaging across days for one mouse
    tps = Range(er_lfp{man,i,fq});
    for i=1:length(structlist)Dir.path{man}(end-7:end)
        for fq=1:nb_fq
            for j=1:size(er_lfp,1)
                toav(j,1:2*1000/mbin*avtime+1) = Data(er_lfp{j,i,fq});
            end
            
            av = mean(toav,1);
            ERAV = tsd(tps,av');
            er_lfp_av{i,fq} = ERAV;
        end
        
    end
    
    cd(res);
    
    if sav_dat
        save er_lfp er_lfp structlistname fq_list Dir LaserInt StimInfoAllMan er_lfp_av Mousename
    end
    
end
    
    
%% Plot event-related data



% 30 sec before and 30 sec after
        for i=1:length(structlist)
            
            manSpfig=figure('Position', [200          48         1500         926]);


            for fq=1:nb_fq
                sub{fq}=subplot(nb_fq,1,fq); hold on

                if strfind(structlist{i}, 'Bulb')
                    plot(Range(er_lfp_av{i,fq}),Data(er_lfp_av{i,fq}),'linewidth',2,'color','b');
                elseif strfind(structlist{i}, 'dHPC')
                    plot(Range(er_lfp_av{i,fq}),Data(er_lfp_av{i,fq}),'linewidth',2,'color','c');
                elseif strfind(structlist{i}, 'PFC')
                    plot(Range(er_lfp_av{i,fq}),Data(er_lfp_av{i,fq}),'linewidth',2,'color','r');
                elseif strfind(structlist{i}, 'vHPC')
                    plot(Range(er_lfp_av{i,fq}),Data(er_lfp_av{i,fq}),'linewidth',2,'color',[1 0.6 0.2]);
                end
                

                if fq==1,text(0,1.3,[Mousename '-' structlist{i}],'units','normalized');end
                ylabel([num2str(fq_list(fq)) ' Hz']);
            end

        if sav_fig
            saveas(manSpfig,[ Mousename '_' structlist{i} '_ERP.fig'])
            saveFigure(manSpfig,[ Mousename '_' structlist{i} '_ERP'],res)
        end
        
        end

        
% 7 cycles before and after
        for i=1:length(structlist)
            
            manSpfig=figure('Position', [200          48         1500         926]);


            for fq=1:nb_fq
                sub{fq}=subplot(nb_fq,1,fq); hold on

                if fq_list(fq) <=10
                range = Range(er_lfp_av{i,fq});
                range = range(length(range)/2-ncyc*1000/fq_list(fq)/mbin:length(range)/2+ncyc*1000/fq_list(fq)/mbin);
                data = Data(er_lfp_av{i,fq});
                data = data(length(data)/2-ncyc*1000/fq_list(fq)/mbin:length(data)/2+ncyc*1000/fq_list(fq)/mbin);
                elseif fq_list(fq) > 10
                range = Range(er_lfp_av{i,fq});
                range = range(length(range)/2-101:length(range)/2+101);
                data = Data(er_lfp_av{i,fq});
                data = data(length(data)/2-101:length(data)/2+101);
                end
                
                if strfind(structlist{i}, 'Bulb')
                    plot(range,data,'linewidth',2,'color','b');
                elseif strfind(structlist{i}, 'dHPC')
                    plot(range,data,'linewidth',2,'color','c');
                elseif strfind(structlist{i}, 'PFC')
                    plot(range,data,'linewidth',2,'color','r');
                elseif strfind(structlist{i}, 'vHPC')
                    plot(range,data,'linewidth',2,'color',[1 0.6 0.2]);
                end
                

                if fq==1,text(0,1.3,[Mousename '-' structlist{i}],'units','normalized');end
%                 ylim([-3000 3000]);
                ylabel([num2str(fq_list(fq)) ' Hz']);
            end


        if sav_fig
            saveas(manSpfig,[ Mousename '_' structlist{i} '_ERP_7cyc' '.fig'])
            saveFigure(manSpfig,[ Mousename '_' structlist{i} '_ERP_7cyc'],res)
        end
        
        end