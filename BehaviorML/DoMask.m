function mask= DoMask(ref,shape)

% inputs
try
    shape;
catch
    shape=input('Enter shape of the mask (square/cross/circle): ','s');
end
while ~sum(strcmp(shape,{'square','cross','circle'}))
    shape=input('Enter shape of the mask (square/cross/circle): ','s');
end


% draw mask
ok='n';
disp('Determine the appropriate area on image.')
figure('Color',[1 1 1]), subplot(1,2,1), imagesc(ref);

while ok~='y'
    subplot(1,2,1),
    if strcmp(shape,'square')
        [XGrid,YGrid]=meshgrid(1:size(ref,1),1:size(ref,2));
        title('Click to determine a square area, then press ENTER');
        [x,y]=ginput;
        xmi=min(y);
        xma=max(y);
        yma=max(x);
        ymi=min(x);
        XGrid((XGrid>xmi&XGrid<xma))=0;
        YGrid((YGrid<yma&YGrid>ymi))=0;
        mask=XGrid'+YGrid';
        mask(find(mask>0))=1;
        mask(find(mask<0))=0;
        
    elseif strcmp(shape,'circle')
        
        [XGrid,YGrid]=meshgrid(1:size(ref,1),1:size(ref,2));
        title('Click on the center then on one point of the circle, then press ENTER') ;
        [y,x]=ginput;
        xc=x(1);yc=y(1);
        Rad=sqrt((y(2)-yc)^2+(x(2)-xc)^2);
        
        A=sqrt((YGrid-yc).*(YGrid-yc)+(XGrid-xc).*(XGrid-xc));
        %figure('Color',[1 1 1]), imagesc(A); axis xy
        mask=A';
        mask(find(mask<=Rad))=0;
        mask(find(mask>Rad))=1;
        
        
    elseif strcmp(shape,'cross')
        title('Click on the edges of the top arm') ;
        G1=ginput(2);
        hold on, plot(G1(:,1),G1(:,2),'+w')
        
        title('Click on the edges of the right arm') ;
        G2=ginput(2);
        hold on, plot(G2(:,1),G2(:,2),'+w')
        
        midY=mean(G2(:,2));
        midX=mean(G1(:,1));
        line([midX,midX],[max(G1(:,2)),midY+(abs(max(G1(:,2))-midY))],'Color','w')
        line([max(G2(:,1)),midX-abs(max(G2(:,1))-midX)],[midY,midY],'Color','w')
        
        mask=zeros(size(ref));
        maskJ=meshgrid(1:size(ref,2),1:size(ref,1));
        maskI=meshgrid(1:size(ref,1),1:size(ref,2))';
        
        
        mask(find( (abs(maskI-midY) <  abs(max(G1(:,2))-midY)) & maskJ<max(G1(:,1)) & maskJ>min(G1(:,1))))=1;
        mask(find( (abs(maskJ-midX) < abs(max(G2(:,1))-midX)) & maskI<max(G2(:,2)) & maskI>min(G2(:,2))))=1;
    end
    
    mask=1-abs(mask);
    R=ref;
    R(find(mask==0))=0;
    
    subplot(1,2,2), imagesc(R), title('Satisfied?')
    ok=input('Are you satisfied with ref area? (y/n) : ','s');
end
close