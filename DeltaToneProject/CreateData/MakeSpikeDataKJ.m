%MakeSpikeDataKJ
% 03.10.2016 KJ
%
% generate spike data
%
% Info
%   see makeDataBulbeSB, MakeWaveformDataKJ
%

clearvars -except Dir p
try
    SetCurrentSession
    SetCurrentSession('same')
    setCu=1;

    global DATA
    tetrodeChannels=DATA.spikeGroups.groups;


    s=GetSpikes('output','full');
    a=1;
    clear S
    for i=1:20
        for j=1:200
            try
                if length(find(s(:,2)==i&s(:,3)==j))>1
                    disp(j);
                    S{a}=tsd(s(s(:,2)==i&s(:,3)==j,1)*1E4, s(s(:,2)==i&s(:,3)==j,1)*1E4);
                    disp(a);
                    TT{a}=[i,j];
                    cellnames{a}=['TT',num2str(i),'c',num2str(j)];

                    W{a} = GetSpikeWaveforms([i j]);
                    disp(['Cluster : ',cellnames{a},' > done'])
                    a=a+1;
                end
            end
        end
        disp(['Tetrodes #',num2str(i),' > done'])
    end

    try
        S=tsdArray(S);
    end


    save SpikeData -v7.3 S s TT cellnames tetrodeChannels
    save Waveforms -v7.3 W cellnames
    disp('Done')


catch
    disp('problem for spikes')
end

