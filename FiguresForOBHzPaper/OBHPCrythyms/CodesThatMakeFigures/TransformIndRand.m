
function IndexRand=TransformIndRand(IndexRand,MNRatio)
%little utility function that takes IndexRand in one format and make it
%amenable for use with GetPhaseCouplingSig when it is in the fomat used for
%MinMaxi phase finding

tempIndexRand=IndexRand;
clear IndexRand
for k=1:size(MNRatio,2)
    IndexRand.Shannon{k}=tempIndexRand.Shannon(k,:);
    IndexRand.VectLength{k}=tempIndexRand.VectLength(k,:);
end

end