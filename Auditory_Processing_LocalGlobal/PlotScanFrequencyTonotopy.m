
    %----------------------------------------------------------------------    
    %----------------------------------------------------------------------    
    
    
    
    clear M
    
    lim1=50;
    lim2=120;
    for w=1:14
        
        z=1;

        for k=5:5:40

            eval(['temp',num2str(k),'kHz1=Data(Fq',num2str(k),'kHz1(w))'';'])
            eval(['Ms',num2str(k),'kHz1=[temp',num2str(k),'kHz1(:,1:size(temp',num2str(k),'kHz1,2)-1)];'])
            eval(['Ms',num2str(k),'kHz1(Ms',num2str(k),'kHz1>lim)=nan;'])
            eval(['Ms',num2str(k),'kHz1(Ms',num2str(k),'kHz1<-lim)=nan;'])

            eval(['temp',num2str(k),'kHz2=Data(Fq',num2str(k),'kHz2(w))'';'])
            eval(['Ms',num2str(k),'kHz2=[temp',num2str(k),'kHz2(:,1:size(temp',num2str(k),'kHz2,2)-1)];'])
            eval(['Ms',num2str(k),'kHz2(Ms',num2str(k),'kHz2>lim)=nan;'])
            eval(['Ms',num2str(k),'kHz2(Ms',num2str(k),'kHz2<-lim)=nan;'])

            eval(['temp',num2str(k),'kHz3=Data(Fq',num2str(k),'kHz3(w))'';'])
            eval(['Ms',num2str(k),'kHz3=[temp',num2str(k),'kHz3(:,1:size(temp',num2str(k),'kHz3,2)-1)];'])
            eval(['Ms',num2str(k),'kHz3(Ms',num2str(k),'kHz3>lim)=nan;'])
            eval(['Ms',num2str(k),'kHz3(Ms',num2str(k),'kHz3<-lim)=nan;'])

            eval(['temp',num2str(k),'kHz4=Data(Fq',num2str(k),'kHz4(w))'';'])
            eval(['Ms',num2str(k),'kHz4=[temp',num2str(k),'kHz4(:,1:size(temp',num2str(k),'kHz4,2)-1)];'])
            eval(['Ms',num2str(k),'kHz4(Ms',num2str(k),'kHz4>lim)=nan;'])
            eval(['Ms',num2str(k),'kHz4(Ms',num2str(k),'kHz4<-lim)=nan;'])

            eval(['[M',num2str(k),'kHz1,S1,E',num2str(k),'kHz1]=MeanDifNan(RemoveNan(Ms',num2str(k),'kHz1));'])
            eval(['[M',num2str(k),'kHz2,S1,E',num2str(k),'kHz2]=MeanDifNan(RemoveNan(Ms',num2str(k),'kHz2));'])
            eval(['[M',num2str(k),'kHz3,S1,E',num2str(k),'kHz3]=MeanDifNan(RemoveNan(Ms',num2str(k),'kHz3));'])
            eval(['[M',num2str(k),'kHz4,S1,E',num2str(k),'kHz4]=MeanDifNan(RemoveNan(Ms',num2str(k),'kHz4));'])

            eval(['M{w}(1,z)=nanstd(M',num2str(k),'kHz1(lim1:lim2));'])
            eval(['M{w}(2,z)=nanstd(M',num2str(k),'kHz2(lim1:lim2));'])
            eval(['M{w}(3,z)=nanstd(M',num2str(k),'kHz3(lim1:lim2));'])
            eval(['M{w}(4,z)=nanstd(M',num2str(k),'kHz4(lim1:lim2));'])

            z=z+1;

        end

    
    end
    
    
    
    figure('color',[1 1 1])
    l=1;
    for i=1:14
        
        subplot(4,4,l), imagesc(M{i}), axis xy, caxis([0 300])
        l=l+1;
        
    end
 


