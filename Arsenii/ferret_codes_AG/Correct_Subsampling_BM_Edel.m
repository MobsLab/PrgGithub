
function Correct_Subsampling_BM_Edel(comp_name)
% directory = '/media/nas7/React_Passive_AG/OBG/Edel/head-fixed';
sessions = PathForExperimentsOB('Edel');
sess_list = sessions.path';
switch comp_name
    case 'rick'
        clear sess
        q = 1;
        for i = 5:8
            sess{q} = sess_list{i};
            q = q+1;
        end
        sess = sess';
    case 'ratatouille' % done
        clear sess
        q = 1;
        for i = 15:16
            sess{q} = sess_list{i};
            q = q+1;
        end
        sess = sess';
    case 'gruffalo_1' % done
        clear sess
        q = 1;
        for i = 19:20
            sess{q} = sess_list{i};
            q = q+1;
        end
        sess = sess';
    case 'gruffalo_2' % done
        clear sess
        q = 1;
        for i = 24
            sess{q} = sess_list{i};
            q = q+1;
        end
        sess = sess';
    case 'greta_1' % done
        clear sess
        q = 1;
        for i = 25:29
            sess{q} = sess_list{i};
            q = q+1;
        end
        sess = sess';
    case 'greta_2' % done
        clear sess
        q = 1;
        for i = 32:33
            sess{q} = sess_list{i};
            q = q+1;
        end
        sess = sess';
    case 'pinky' % done 
        clear sess
        q = 1;
        for i = 35:41
            sess{q} = sess_list{i};
            q = q+1;
        end
        sess = sess';
    case 'mickey' % done
        clear sess
        q = 1;
        for i = 42:48
            sess{q} = sess_list{i};
            q = q+1;
        end
        sess = sess';
end

% 1, 2, 3, 4, 14, 17, 18, 22, 30, 31, 34

%%
for p=1:length(sess)
    disp(['Calculating ' sess{p} ' ' num2str(length(sess)-p) '/' num2str(length(sess)) ' is left...'])
    cd(sess{p})
    
    % basal informations regarding session
    clearvars -except path p sess comp_name directory
    load('ExpeInfo.mat')
    BaseFileName = ['M' num2str(ExpeInfo.nmouse) '_' ExpeInfo.date '_' ExpeInfo.SessionType];
    FinalFolder = cd;
    is_OpenEphys = false;
    
    % delete part
    try
        delete B_Low_Spectrum.mat
    end
    try
        delete B_Middle_Spectrum.mat
    end
    try
        delete B_High_Spectrum.mat
    end
    try
        delete B_UltraLow_Spectrum.mat
    end
    try
        delete([BaseFileName '.lfp'])
    end
    for i=0:42
        delete(['LFPData/LFP' num2str(i) '.mat'])
    end
    
    % correct the .xml
    XmlStructure = xml2struct_SB([BaseFileName '.xml']);
    try
        XmlStructure.parameters.programs.program{1, 5}.parameters.parameter.value.Text='1250';
    catch
        XmlStructure.parameters.programs.program{1, 4}.parameters.parameter.value.Text='1250';
    end
    XmlStructure.parameters.fieldPotentials.lfpSamplingRate.Text='1250';
    
    switch comp_name
        case 'rick'
            XmlStructure.parameters.acquisitionSystem.samplingRate.Text='30000';
        case 'ratatouille'
            XmlStructure.parameters.acquisitionSystem.samplingRate.Text='30000';
        case 'gruffalo_1'
            XmlStructure.parameters.acquisitionSystem.samplingRate.Text='30000';
        case 'gruffalo_2'
            XmlStructure.parameters.acquisitionSystem.samplingRate.Text='20000';
        case 'greta_1'
            XmlStructure.parameters.acquisitionSystem.samplingRate.Text='20000';
        case 'greta_2'
            XmlStructure.parameters.acquisitionSystem.samplingRate.Text='20000';
        case 'pinky'
            XmlStructure.parameters.acquisitionSystem.samplingRate.Text='20000';
        case 'mickey'
            XmlStructure.parameters.acquisitionSystem.samplingRate.Text='20000';
    end
    struct2xml_SB(XmlStructure,[BaseFileName '.xml']);
    
    % recalculate everything
    system(['ndm_lfp ' BaseFileName])
    SetCurrentSession([BaseFileName '.xml'])
    InfoLFP = ExpeInfo.InfoLFP;
    
    load(fullfile(pwd,'LFPData','InfoLFP.mat'), 'InfoLFP');
    try
        for i=[[1, 24, 25, 26]+1]
            if ~exist(['LFPData/LFP' num2str(InfoLFP.channel(i)) '.mat'],'file') %only LFP signals
                
                disp(['loading and saving LFP' num2str(InfoLFP.channel(i)) ' in LFPData...']);
                % FMA toolbox function to load LFP
                LFP_temp = GetLFP(InfoLFP.channel(i));
                %data to tsd
                LFP = tsd(LFP_temp(:,1)*1E4, LFP_temp(:,2));
                SessLength = max(LFP_temp(:,1));
                %save
                save([pwd '/LFPData/LFP' num2str(InfoLFP.channel(i))], 'LFP');
                clear LFP LFP_temp
            end
        end
        disp('Done')
    catch
        disp('problem for lfp')
    end
    disp('Calculating Bulb Spectros')
    load('ChannelsToAnalyse/Bulb_deep.mat')
    LowSpectrumSB([cd filesep],channel,'B')
    MiddleSpectrum_BM([cd filesep],channel,'B')
    HighSpectrum([cd filesep],channel,'B');
    UltraLowSpectrumBM([cd filesep],channel,'B');
end

end