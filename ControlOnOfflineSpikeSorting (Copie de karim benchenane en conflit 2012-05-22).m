
%ControlOnOfflineSpikeSorting


thresh=-500;

thstim=1500;

sleep=1;
tetrode=1;
channel=1;

spknum=1:10;

nclu=4;
ppc=1;

 load behavResources
% load SpikeData

try 
    load SpikeStim
    data1{1};
    
    catch
    



SetCurrentSession
global DATA

for i=1:length(DATA.spikeGroups.groups)
LFP4tetrodes{i}=DATA.spikeGroups.groups{i};
end


st=Range(stim,'s');
for i=1:length(st)
    data1{i} = GetWideBandData(LFP4tetrodes{1},'intervals',[st(i)-0.015 st(i)+0.005]);
    data2{i} = GetWideBandData(LFP4tetrodes{2},'intervals',[st(i)-0.015 st(i)+0.005]);
end


save SpikeStim LFP4tetrodes data1 data2 

end

st=Range(stim,'s');
bu = burstinfo(st,0.5);
burst=tsd(bu.t_start*1E4,bu.i_start);
idburst=bu.i_start;


save StimMFB stim burst idburst

Stimu=tsd(st*1E4,[1:length(st)]');

deb=1;
fin=size(data1{1},1);

if sleep
idd=Data(Restrict(burst,SleepEpoch));
else
idd=Data(Restrict(Stimu,ExploEpoch));
end


if 1
    
    debtemp=1;
    fintemp=380;

   
    figure('color',[1 1 1]), hold on
    for j=1:length(idd)%spknum2%length(idd)
    for a=2:size(data1{1},2)
    subplot(size(data1{1},2)-1,1,a-1), hold on
    for j=1:10
    plot(data1{idd(j)}(debtemp:fintemp,a),'k','linewidth',1), ylim([-3000 3000])
    end
    end
     end
subplot(size(data1{1},2)-1,1,1),title('raw data from tetrode 1 centered to ICRS during sleep')

    figure('color',[1 1 1]), hold on
    for j=1:length(idd)%spknum2%length(idd)
    for a=2:size(data2{2},2)
    subplot(size(data2{2},2)-1,1,a-1), hold on
    for j=1:10
    plot(data2{idd(j)}(debtemp:fintemp,a),'k','linewidth',1), ylim([-3000 3000])
    end
    end
    end
subplot(size(data2{1},2)-1,1,1),title('raw data from tetrode 2 centered to ICRS during sleep')

end


if sleep


figure('color',[1 1 1]), hold on
for a=2:size(data1{1},2)
    subplot(size(data1{1},2)-1,1,a-1), hold on
    for j=1:length(idd)
        try
        
            id=find(data1{idd(j)}(1:end,5)>thstim|data1{idd(j)}(1:end,5)<-thstim);
          if id(1)>81
              temp=data1{idd(j)}(id(1)-80:id(1),5);
            if temp(78)<thresh
                
            plot(data1{idd(j)}(id(1)-80:id(1),a),'k','linewidth',1), ylim([-5000 5000]), xlim([0 80])
                
            end
          end
     end
    end
end
subplot(size(data1{1},2)-1,1,1),title('raw data from tetrode 1 (including place cell) centered to ICRS during sleep')





figure('color',[1 1 1]), hold on
for a=2:size(data2{1},2)
    subplot(size(data2{1},2)-1,1,a-1), hold on
    for j=1:length(idd)
         try
       
            id=find(data1{idd(j)}(deb:fin,5)>thstim|data1{idd(j)}(deb:fin,5)<-thstim);
         if id(1)>81
        temp=data1{idd(j)}(id(1)-80:id(1),5);
            if temp(78)<thresh
        plot(data2{idd(j)}(id(1)-80:id(1),a),'k','linewidth',1), ylim([-3000 3000]), xlim([0 80])
           end
         end
         end
    end
    
end
subplot(size(data2{1},2)-1,1,1),title('raw data from tetrode 2 centered to ICRS during sleep')



else
    



spk1=zeros(spknum(end),(size(data1{1},2)-1)*32);
spk2=zeros(spknum(end),(size(data2{1},2)-1)*32);
%len=[275:325];
len=[100:180];

%d=len(end)-len(1)+1;

d=32;

l=1;

figure('color',[1 1 1]), hold on
    for j=spknum %length(idd)


            
        for a=2:size(data1{1},2)
        subplot(size(data1{1},2)-1,1,a-1), hold on

                            
            
            temp1=data1{idd(j)}(:,:);
            
            if tetrode==1
            temp=data1{idd(j)}(len,channel+1)';
            else
            temp=data2{idd(j)}(len,channel+1)';                
            end
            
            [m,id]=min(temp);
            %id+275
            
            spk1(j,(a-2)*d+1:(a-2)*d+d)=temp1(len(1)+id-13:len(1)+id+18,a)';
           
%             plot(data1{idd(j)}(:,a),'k','linewidth',1), ylim([-5000 5000]), xlim([len(1) len(end)])
             
            plot(temp1(len(1)+id-13:len(1)+id+18,a)','k','linewidth',1), ylim([-5000 5000]), xlim([1 32])
            
            clear temp
            
%             end
%         end
        end

        
    end

subplot(size(data1{1},2)-1,1,1),title('Raw data from tetrode 1 (including place cell) centered to ICRS during sleep')



l=1;


figure('color',[1 1 1]), hold on

    for j=spknum
for a=2:size(data2{1},2)
    subplot(size(data2{1},2)-1,1,a-1), hold on
    

            
    
            temp2=data2{idd(j)}(:,:);
            
    
            if tetrode==1
            temp=data1{idd(j)}(len,channel+1)';
            else
            temp=data2{idd(j)}(len,channel+1)';                
            end
            
            [m,id]=min(temp);
            %id+275
            
            spk2(j,(a-2)*d+1:(a-2)*d+d)=temp2(len(1)+id-13:len(1)+id+18,a)';
            
%             plot(data2{idd(j)}(:,a),'k','linewidth',1), ylim([-3000 3000]), xlim([len(1) len(end)])
            
            plot(temp2(len(1)+id-13:len(1)+id+18,a)','k','linewidth',1), ylim([-3000 3000]), xlim([1 32])
            
%             title(num2str(id+275))
%             keyboard
            clear temp
            
        %            end
%         end
end

    
end
subplot(size(data2{1},2)-1,1,1),title('Raw data from tetrode 2 centered to ICRS during sleep')





figure('color',[1 1 1]),
subplot(3,2,1), hold on
plot(mean(spk1),'k','linewidth',2), xlim([1 size(spk1,2)]), ylim([-3000 3000])
for a=2:size(data1{1},2)
line([(a-2)*d (a-2)*d],[-3000 3000],'color','k')
end
subplot(3,2,2), hold on
plot(mean(spk2),'k','linewidth',2), xlim([1 size(spk2,2)]), ylim([-3000 3000])
for a=2:size(data2{1},2)
line([(a-2)*d (a-2)*d],[-3000 3000],'color','k')
end
subplot(3,2,[3,5]), 
imagesc(spk1), caxis([-3000 3000])
hold on
for a=2:size(data1{1},2)
line([(a-2)*d (a-2)*d],[0.5 size(spk1,1)+0.5],'color','k')
end
subplot(3,2,[4,6]), 
imagesc(spk2), caxis([-3000 3000])
hold on,
for a=2:size(data2{1},2)
line([(a-2)*d (a-2)*d],[0.5 size(spk2,1)+0.5],'color','k')
end



l=1;
for a=2:size(data1{1},2)
    
    [M,S,E]=MeanDifNan(spk1(:,(a-2)*d+1:(a-2)*d+d));
    
    SpkM1(a,:)=M;
    SpkE1(l,:)=S;
    l=l+1;
end


l=1;
for a=2:size(data2{1},2)

    [M,S,E]=MeanDifNan(spk2(:,(a-2)*d+1:(a-2)*d+d));
    
    SpkM2(l,:)=M;
    SpkE2(l,:)=S;
    
    l=l+1;
end




figure('color',[1 1 1]),hold on

for a=2:size(data1{1},2)
    subplot(size(data1{1},2)-1,1,a-1), hold on
plot(SpkM1(a-1,:),'k','linewidth',2)
plot(SpkM1(a-1,:)+SpkE1(a-1,:),'k','linewidth',1)
plot(SpkM1(a-1,:)-SpkE1(a-1,:),'k','linewidth',1), xlim([1 32])%, ylim([-3000 3000]),
end
subplot(size(data1{1},2)-1,1,1),title('Mean of raw data from tetrode 1 centered to ICRS during sleep')

figure('color',[1 1 1]),hold on

for a=2:size(data2{1},2)
    subplot(size(data2{1},2)-1,1,a-1), hold on
plot(SpkM2(a-1,:),'k','linewidth',2)
plot(SpkM2(a-1,:)+SpkE2(a-1,:),'k','linewidth',1)
plot(SpkM2(a-1,:)-SpkE2(a-1,:),'k','linewidth',1), xlim([1 32])%, ylim([-3000 3000])
end
subplot(size(data2{1},2)-1,1,1),title('Mean of raw data from tetrode 2 centered to ICRS during sleep')




%---------------------------------------------------------------------------
%---------------------------------------------------------------------------
%---------------------------------------------------------------------------


[r1,p1]=corrcoef(zscore(spk1'));

[V1,L1] = pcacov(r1);
pc11=V1(:,1);
pc12=V1(:,2);
pc13=V1(:,3);
pc14=V1(:,4);


[BE,idx1]=sort(pc11);

figure('color',[1 1 1]), 
subplot(2,1,1), imagesc(r1)
subplot(2,1,2), imagesc(r1(idx1,idx1))

if length(ppc)==1
    [c1,s1] = kmeans(V1(:,ppc),nclu);
else
    [s1,Centers1] = kmeansIni(V1(:,ppc),nclu,'distance','sqEuclidean');
end

figure('color',[1 1 1]), plot(pc11(idx1),'-ko')
hold on, plot(s1(idx1)/50,'-or')


figure('color',[1 1 1]),hold on, 
plot(pc11,pc12,'k.')
for i=1:nclu
plot(pc11(s1==i),pc12(s1==i),'.','color',[0 i/nclu (nclu-i)/nclu])
end

for i=1:nclu
[M1(i,:),S1(i,:),E1(i,:)]=MeanDifNan(spk1(s1==i,:));
end





figure('color',[1 1 1]),hold on, 
for i=1:nclu
subplot(nclu,1,i), hold on, 
plot(M1(i,:),'k','linewidth',2)
plot(M1(i,:)+S1(i,:),'k','linewidth',1)
plot(M1(i,:)-S1(i,:),'k','linewidth',1), ylim([-3000 3000])
title(['tetrode 1, cluster no',num2str(i),', n=',num2str(length(find(s1==i)))])
for a=2:size(data1{1},2)
line([(a-2)*d (a-2)*d],[-3000 3000],'color','r')
end
end





%---------------------------------------------------------------------------
%---------------------------------------------------------------------------
%---------------------------------------------------------------------------


[r,p]=corrcoef(zscore(spk2'));

[V,L] = pcacov(r);
pc1=V(:,1);
pc2=V(:,2);
pc3=V(:,3);
pc4=V(:,4);


[BE,idx]=sort(pc1);

figure('color',[1 1 1]), 
subplot(2,1,1), imagesc(r)
subplot(2,1,2), imagesc(r(idx,idx))

if length(ppc)==1
    [c,s] = kmeans(V(:,ppc),nclu);
else
    [s,Centers] = kmeansIni(V(:,ppc),nclu,'distance','sqEuclidean');
end

figure('color',[1 1 1]), plot(pc1(idx),'-ko')
hold on, plot(s(idx)/50,'-or')


figure('color',[1 1 1]),hold on, 
plot(pc1,pc2,'k.')
for i=1:nclu
plot(pc1(s==i),pc2(s==i),'.','color',[0 i/nclu (nclu-i)/nclu])
end

for i=1:nclu
[M2(i,:),S2(i,:),E2(i,:)]=MeanDifNan(spk2(s==i,:));
end





figure('color',[1 1 1]),hold on, 
for i=1:nclu
subplot(nclu,1,i), hold on, 
plot(M2(i,:),'k','linewidth',2)
plot(M2(i,:)+S2(i,:),'k','linewidth',1)
plot(M2(i,:)-S2(i,:),'k','linewidth',1), ylim([-3000 3000])
title(['tetrode 2, cluster no',num2str(i),', n=',num2str(length(find(s==i)))])
for a=2:size(data2{1},2)
line([(a-2)*d (a-2)*d],[-3000 3000],'color','r')
end
end


end



%         %writeDir= '/home/karimoudugenou/';
%         writeDir= '/media/Drobo1/MMNP3b/Mouse021/20110913/MMN-Mouse-21-13092011/';
%         base = 'DonneesToutesPourries';
%         
%         ii = 1; %faire une boucle sur ii si t'as plusieurs �l�ctrodes
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
% %function classification = runKlustaKwik(cvector, fname, wc)
% % create file for KlustaKwik from wavelet coefficients from wave_clus
% % cvector is the input features
% % fname is the filename to use for temporary files
% % wc contains the times and cluster numbers from wave-clus: we just use the
% % times
% 
% fhandle = fopen([fname '.fet.1'], 'w') ; % open file for writing
% [npoints plength] = size(cvector) ; 
% fprintf(fhandle, '%-3.0d\n', plength) ;
% for i=1:npoints
%     for j=1:plength
%         fprintf(fhandle, '%-12.6f\t', cvector(i,j)) ;
%     end
%     fprintf(fhandle, '\n') ;
% end
% fclose(fhandle) ;
% % now run KK on this file
% unix(sprintf(['/Users/lss/matlab_stuff/Wave_clus/KK/KlustaKwik ',fname, ' 1 -MinClusters 2 -MaxPossibleClusters 6 -UseFeatures 1111111111 -Screen 0 -PenaltyMix 1']));
% 
% unix(sprintf(['/Users/lss/matlab_stuff/Wave_clus/KK/KlustaKwik ',fname, ' 1 -MinClusters 2 -MaxPossibleClusters 6 -UseFeatures 1111100000 -Screen 0 -PenaltyMix 1']));
% % now read the output file back to generate something akin to the
% % cluster_class datastructure, with the time followed by the cluster number
% classification = zeros([npoints 2]) ;
% classification(:,2) = wc(:,2) ; % times
% fhandle2 = fopen([fname '.clu.1'], 'r') ; % open cluster file
% temp1 = fscanf(fhandle2, '%2d', [1 inf]) ;
% disp(['number of clusters = ' num2str(temp1(1))]) ;
% classification(:,1) = temp1(2:end)' ;
% 
% 
% 
% 
% 
% 
