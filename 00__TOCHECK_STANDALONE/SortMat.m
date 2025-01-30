function [MatNew,ind]=SortMat(Mat,Window)

mn=mean(Mat(:,Window)',1);
MatNew=[mn',Mat];
[MatNew,ind]=(sortrows(MatNew));
MatNew=MatNew(:,2:end);
end