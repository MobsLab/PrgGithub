%ParcoursREMAnalysis


Dir = PathForExperimentsFakeSlowWave;
FR=[];

cd('/Volumes/One Touch/Data_KB/DataUmazeSpikes_KB')
i=8;
listdir=dir;

for a=8:length(listdir)
        if listdir(a).isdir==1&listdir(a).name(1)~='.'
            cd('/Volumes/One Touch/Data_KB/DataUmazeSpikes_KB')
            eval(['cd(''',listdir(a).name,''')'])  
 try

            [s,Fr,x1,x2,h1,h2,h3,h1a,h2a,h3a,h1b,h2b,h3b]=REMAnalysis;
            S(:,:,i)=s;
            FR=[FR;Fr];
            H1(:,:,i)=h1;
            H2(:,:,i)=h2;
            H3(:,:,i)=h3;
            H1a(:,:,i)=h1a;
            H2a(:,:,i)=h2a;
            H3a(:,:,i)=h3a;
            H1b(:,:,i)=h1b;
            H2b(:,:,i)=h2b;
            H3b(:,:,i)=h3b;
            name{i}=pwd;
            load behavResources SessionNames
            SessionsNames{i}=SessionNames;
            clear SessionNames
            i=i+1;
%             cd('/Volumes/One Touch/Data_KB/DataUmazeSpikes_KB')
            cd('/Users/karimbenchenane/Documents/MATLAB')
            try
                save AAADataREManalysis -Append FR S i x1 x2 H1 H2 H3 H1a H2a H3a H1b H2b H3b SessionsNames name
            catch
                save AADataREManalysis FR S i x1 x2 H1 H2 H3 H1a H2a H3a H1b H2b H3b SessionsNames name
            end
            pause(0)
 end
        end
end

