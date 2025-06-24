%STEP4_get_reference_MNT


%% Ask user the configurations to save
disp(' ');
disp('Take the reference image')
try ref; catch get_reference;end
%% determine mask

ok='y';
disp('Determine the appropriate area on image.')
figure('Color',[1 1 1]), subplot(1,2,1), imagesc(ref);

while ok=='y'
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
    
    
    mask=1-abs(mask);
    R=ref;
    R(find(mask==0))=0;
    
    subplot(1,2,2), imagesc(R), title('Change the area? (y/n)')
     ok=input('Change the area? (y/n) : ','s');
    close
end

try
    save InfoTracking -append ref mask
catch
    save InfoTracking ref mask
end

close     