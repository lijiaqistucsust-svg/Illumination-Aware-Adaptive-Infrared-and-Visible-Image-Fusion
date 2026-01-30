function [sMap,Cmax,i_mean,S_map,i_mean2] = weight_spd_fine(imgSeqColor,p,r1,lambda)
R=2*r1+1;
[h,w,~]=size(imgSeqColor);
N1 = boxfilter(ones(h, w), r1);
if size(imgSeqColor,4)==1
    N = size(imgSeqColor,3);
else
    N = size(imgSeqColor,4);
end
C = zeros(size(imgSeqColor,1),size(imgSeqColor,2),N);
i_mean2= zeros(size(imgSeqColor,1),size(imgSeqColor,2),N);
i_mean= zeros(size(imgSeqColor,1),size(imgSeqColor,2),N);
S_map= zeros(size(imgSeqColor,1),size(imgSeqColor,2),N);
S_map(:,:,1)= Infrared_saliency_map(imgSeqColor(:,:,1));
 S_map(:,:,2) = Visual_saliency_map(imgSeqColor(:,:,2));
for i = 1:N
        img = imgSeqColor(:,:,i);
        i_mean2(:,:,i)=boxfilter(img, r1)./ N1;
        i_var2= boxfilter(img.*img, r1)./ N1- i_mean2(:,:,i).* i_mean2(:,:,i);
   img_gray = img;
  i_mean(:,:,i) = SSFF(img_gray,r1,lambda);
        i_var2=sqrt(max(i_var2,0));
        C(:,:,i) = i_var2 * sqrt( R^2  );
end
Cmax=max(C,[],3);
sMap1 = C.^p; 
sMap2 = C.^(p-1);
normalizer = sum(sMap1,3);
sMap = sMap2 ./ repmat(normalizer,[1, 1, N]) ;