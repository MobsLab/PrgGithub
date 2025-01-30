%Preprocessing_harddrive_DB
% 08.03.2018 DB

function Preprocessing_PAGTest(dirin, indir, indir_beh, postorpre)

try
   dirin;
catch
   dirin='/media/mobsrick/DataMOBS85/PAG tests/M784/18092018/CalibContextB/';
end

try
   postorpre;
catch
   postorpre = 0;
end

% Vector of used intensities
V = [0.0 0.5 1.0 1.5 2.0 2.5 3.0 3.5 4.0 4.5];

% List folders inside Calibration
L=dir(dirin);
j=1; % counter for intensities in the loop

for i=1:length(L)
    if L(i).isdir
        if strcmp (L(i).name,['Calib' num2str(V(j)) 'V'])
            
            Dir = [dirin '/Calib' num2str(V(j)) 'V/'];
            cd(Dir);
    
            %% Get info about the dataset
            % GenMakeDataInputs
            spk=false;
            doaccelero = true;
            dodigitalin = true;
            doanalogin = false;
            Questions={'SpikeData (yes/no)', 'INTAN accelero', 'INTAN Digital input', 'INTAN Analog input'};           
            answerdigin{1,1} = '7';
            answerdigin{2,1} = '4';
            
            save makedataBulbeInputs Questions spk doaccelero dodigitalin doanalogin answerdigin
            clear Questions spk doaccelero dodigitalin doanalogin answerdigin
            
            % GenInfoLFPFromSpread
            structure_list = {'nan', 'ref', 'bulb', 'hpc', 'dhpc', 'pfcx', 'pacx', 'picx', 'mocx', 'aucx', 's1cx', 'th', 'nrt', 'auth', 'mgn', 'il', 'tt', ...
                            'amyg', 'vlpo','ekg','emg', 'digin', 'accelero'};
            hemisphere_list = {'r','l','nan'};
            depth_list = [-1 0 1 2 3];
            NDM_PAGTest
            try
                load LFPData/InfoLFP InfoLFP
                m = input('Info LFP already exists - Do you want to rewrite it ? Y/N [Y]:','s');
    
            catch
                disp('creating InfoLFP...');
                m = 'y';
            end
            
            try
                [num,str] = xlsread('/media/mobs/DataMOBS85/PAG tests/M784/ChanLFP.xlsx');
            catch
                error('xls file cannot be read');
            end
            
            InfoLFP.channel = num(:,1);
            InfoLFP.depth = num(:,3);
            for k=1:length(InfoLFP.channel)
                InfoLFP.structure{k} = str{k,1};
                InfoLFP.hemisphere{k} = str{k,3};
            end
            clear num str

            if ~all(ismember(InfoLFP.depth, depth_list) | isnan(InfoLFP.depth))
                disp(InfoLFP.depth)
                error('one depth value is not correct')
            end
            if ~all(ismember(lower(InfoLFP.structure), structure_list))
                disp(InfoLFP.structure)
                error('one structure input is not correct')
            end
            if ~all(ismember(lower(InfoLFP.hemisphere), hemisphere_list))
                disp(InfoLFP.hemisphere)
                error('one structure input is not correct')
            end

            mkdir('LFPData')
            save('LFPData/InfoLFP.mat','InfoLFP');
            
            %GenChannelsToAnalyse
            res=pwd;
            if ~exist([res '/ChannelsToAnalyse'],'dir') % 01.04.2018 Dima
                mkdir('ChannelsToAnalyse');
            end
            
            channel = 1;
            save(['ChannelsToAnalyse/','EKG.mat'],'channel');
    
    
            %% Get folders
            try
                indir;
            catch
                indir ={'PAG-Mouse-784-18092018-ContextA-Calib-0V_180918_113853/';
                    'PAG-Mouse-784-18092018-ContextA-Calib-0,5V_180918_114400/';
                    'PAG-Mouse-784-18092018-ContextA-Calib-1V_180918_114838/';
                    'PAG-Mouse-784-18092018-ContextA-Calib-1,5V_180918_115244/';
                    'PAG-Mouse-784-18092018-ContextA-Calib-2V_180918_115643/';
                    'PAG-Mouse-784-18092018-ContextA-Calib-2,5V_180918_120052/';
                    'PAG-Mouse-784-18092018-ContextA-Calib-3V_180918_120537';
                    'PAG-Mouse-784-18092018-ContextA-Calib-3,5V_180918_121036';
                    'PAG-Mouse-784-18092018-ContextA-Calib-4V_180918_121711';
                    'PAG-Mouse-784-18092018-ContextA-Calib-4,5V_180918_122220'
                };
            end

            try
                indir_beh;
            catch
                indir_beh={'ERC-Mouse-784-18092018-Calibration_02/';
                    'ERC-Mouse-784-18092018-Calibration_03/';
                    'ERC-Mouse-788-09092018-Calibration_04/';
                    'ERC-Mouse-788-09092018-Calibration_05/';
                    'ERC-Mouse-788-09092018-Calibration_06/';
                    'ERC-Mouse-788-09092018-Calibration_07/';
                    'ERC-Mouse-788-09092018-Calibration_08/';
                    'ERC-Mouse-788-09092018-Calibration_09/';
                    'ERC-Mouse-788-09092018-Calibration_011/';
                    'ERC-Mouse-788-09092018-Calibration_07/';
                };
            end
    
            %% NDM shit
            if postorpre == 0
                NDM_PAGTest(Dir, indir{j}, indir_beh{j}, V, j)
            else
                NDM_DB_pre_post(Dir, indir, indir_beh, postorpre)
            end
            j=j+1;
        end
    end
end
end