function [ImDiff,NewIm]=ImDiffOnly(im,mask,OldIm,camtype,varargin)


immob_IM = double(im).*double(mask) - double(OldIm).*double(mask);
ImDiff=(sum(sum(((immob_IM).*(immob_IM)))));
NewIm=im;

end