function [SpkE,cluE,feaE,timE]=ConvertSpikeKK(base,spikes,tps,nbDim)

wri=0;

%spikes size must be:  170  x   4  x  32

nchannels=size(spikes,2);


        writeDir=[pwd,'/'];
        try
            base;
        catch
            base = 'DonneesTstBis';
        end
        
        ii = 1; %faire une boucle sur ii si t'as plusieurs �l�ctrodes
        
        try
            nbDim;
        catch
            nbDim = 4; %nb de dimensions pour la PCA
        end
        
        precision='int16'; %fais pas genre tu comprends
        
        tim=tps;
       % spkE = spk;
        timE = uint32(tim*1000);
        cluE = int16([1;ones(length(tim),1)]);
        
        
        
        
        

        feaE=[];
        SpkE=[];
        for i=1:4
                spk=squeeze(spikes(:,i,:));
                spkE = spk';

                %Compute PCA
                C = corrcoef(double(spkE)');
                C(isnan(C))=0;
                V = pcacov(C);
                feaEtemp = int32(round(1000*zscore(double(spkE)')*V(:,1:nbDim)));

                feaE=[feaE,feaEtemp];
                
                SpkE=[SpkE,spkE(:)];
                
        end
if wri
        
        
        %Writing clu files
        fileN = [base '.clu.' num2str(ii)];
        f = fopen([writeDir fileN],'w');
        fprintf(f,'%i\n',cluE);
        fclose(f);
        
        
        %Writing spikes
        fileN = [base '.spk.' num2str(ii)];
        f = fopen([writeDir fileN],'w');
        fwrite(f,spkE,precision);
        fprintf(f,'\n');
        fclose(f);

        %Writing feature files
        warning off
        try
        m = [feaE timE'];
        catch
        m = [feaE timE];
        end
        
        warning on
        m = m';
        m = m(:);
        fileN = [base '.fet.' num2str(ii)];
        f = fopen([writeDir fileN],'w');
        fprintf(f,'%i\n',nbDim+1);
        tic,fprintf(f,'%d\t%d\t%d\t%ld\t\n',m),toc
        fclose(f);
        
        
        %Writing res
        fileN = [base '.res.' num2str(ii)];
        f = fopen([writeDir fileN],'w');
        fprintf(f,'%i\n',timE);
        fclose(f);       
        
        
end

%         
%         
%         
%         
%         %Compute PCA
%         C = corrcoef(double(spkE)');
%         V = pcacov(C);
%         feaE = int32(round(1000*zscore(double(spkE)')*V(:,1:nbDim)));
%         
%         %Writing spikes
%         fileN = [base '.spk.' num2str(ii)];
%         f = fopen([writeDir fileN],'w');
%         fwrite(f,spkE,precision);
%         fprintf(f,'\n');
%         fclose(f);
%  
%         %Writing res
%         fileN = [base '.res.' num2str(ii)];
%         f = fopen([writeDir fileN],'w');
%         fprintf(f,'%i\n',timE);
%         fclose(f);
%         
%         
%         %Writing clu files
%         fileN = [base '.clu.' num2str(ii)];
%         f = fopen([writeDir fileN],'w');
%         fprintf(f,'%i\n',cluE);
%         fclose(f);
%         
%         %Writing feature files
%         warning off
%         m = [feaE timE'];
%         warning on
%         m = m';
%         m = m(:);
%         fileN = [base '.fet.' num2str(ii)];
%         f = fopen([writeDir fileN],'w');
%         fprintf(f,'%i\n',nbDim+1);
%         tic,fprintf(f,'%d\t%d\t%d\t%ld\t\n',m),toc
%         fclose(f);
%         
%         
%         