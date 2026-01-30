function dI = Resize(imgSeqColor, maxSize)
if ~exist('maxSize', 'var')
   maxSize = 512;
end
imgSeqColor = double(imgSeqColor);
m = size(imgSeqColor, 1);
n = size(imgSeqColor, 2);
if m >= n && m > maxSize
    sampleFactor = m / maxSize;
    dI = imresize(imgSeqColor, [maxSize, floor(n / sampleFactor)],'bicubic');
elseif m < n && n > maxSize
    sampleFactor = n / maxSize;
    dI = imresize(imgSeqColor, [floor(m / sampleFactor), maxSize],'bicubic');
else
    dI = imgSeqColor;
end


