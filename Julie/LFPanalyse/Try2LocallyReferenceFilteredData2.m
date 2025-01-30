% Try2LocallyReferenceFilteredData

filename = [DATA.session.path '/' DATA.session.basename '.fil'];
nChannels = DATA.nChannels;

ref=input('quelle reference?: ');

precision = 'int16';
sizeInBytes = 2;

frequency = 20000;
start = 0;


nSamplesPerChannel = round(frequency*duration);

duration = nSamplesPerChannel/frequency;


start = floor(start*frequency)*nChannels*sizeInBytes;

maxSamplesPerChunk = 100000;
nSamples = nChannels*nSamplesPerChannel;


    

    
    
ok=1;

duration = 600;
data = [];

for i=1:length(DATA.spikeGroups.groups)
    
    for channels=DATA.spikeGroups.groups{i}
     
        for k = 1:length(DATA.spikeGroups.groups{i})

            tic
            a=1;
            while ok==1
                
            start = (a-1)*360+1/DATA.rates.wideband;
                try

                            dref = LoadBinary(filename,'duration',duration,'frequency',DATA.rates.wideband,'nchannels',nChannels,'start',start,'channels',ref+1); 
                            d = LoadBinary(filename,'duration',duration,'frequency',DATA.rates.wideband,'nchannels',nChannels,'start',start,'channels',channels+1);  
                            
                            n = size(d,1);
                            t = linspace(start,start+n/DATA.rates.wideband,n)';
    
                            data = [data ; t d-dref];
                            a=a+1;
                            
                catch
                    
                    ok=0;
                    %
%                             dref = LoadBinary(filename,'frequency',DATA.rates.wideband,'nchannels',nChannels,'start',start,'channels',ref+1); 
%                             d = LoadBinary(filename,'frequency',DATA.rates.wideband,'nchannels',nChannels,'start',start,'channels',channels+1);  
%                              ok=0;
%                              data = [data ; d-dref];

               end

            end
toc
        end
               
    end
end


