%tempFigureSpikeSorting

cd /Users/Bench/Documents/Data/Mouse026/20120111/ICSS-Mouse-26-11012012
load behavResources

plo=0;

SetCurrentSession

Epoch1=intervalSet(tpsdeb{1}*1E4,tpsfin{1}*1E4);
stim1=Restrict(stim,Epoch1);
st=Range(stim1,'s');

Data=[];
    for i=1:length(st)
        [data,indices] = GetWideBandData(0:23,'intervals',[st(i)-0.003 st(i)+0.005]);
        Data=[Data;data(:,12)'];
    end
    
    
for n=0:23
    
    Data2=[];
    for i=1:length(st)
        [data,indices] = GetWideBandData(n,'intervals',[st(i)-0.003 st(i)+0.005]);
        Data2=[Data2;data(:,2)'];
    end
    Mref=Data;
    M=Data2;
    le=size(Mref,1);
    si=size(Mref,2);
    M2{n+1}=[zeros(le,40)];
    for i=1:le
        try
            [ME,id]=min(Mref(i,:));
            M2{n+1}(i,1:40)=M(i,id-15:id+24);
        end
    end

    if plo
    figure(1),clf
    subplot(2,1,1), imagesc(M2{n+1})
    subplot(2,1,2), plot(mean(M2{n+1}),'k','linewidth',2), title(num2str(n)), ylim([-1200 600])

    pause(2)
    end
    
end





clear spikes
spikes(:,1,:)=M2{11}(:,5:36);
spikes(:,2,:)=M2{12}(:,5:36);
spikes(:,3,:)=M2{13}(:,5:36);
spikes(:,4,:)=M2{14}(:,5:36);
tps=Range(stim1,'s');



save test tps spikes



tim=tps;
spk=spikes;

% 
%         %writeDir= '/home/karimoudugenou/';
%         %writeDir= '/media/Drobo1/MMNP3b/Mouse021/20110913/MMN-Mouse-21-13092011/';
%         writeDir=pwd;
%         base = 'DonneesToutesPourries';
%         
%         ii = 1; %faire une boucle sur ii si t'as plusieurs ?l?ctrodes
%         nbDim = 4; %nb de dimensions pour la PCA
%         precision='int16'; %fais pas genre tu comprends
%         
%         spkE = spk';
%         
%         timE = uint32(tim);
%         cluE = int16([2;ones(length(tim),1)]);
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
% 
%         fclose(f);
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
% 
% 
% 
