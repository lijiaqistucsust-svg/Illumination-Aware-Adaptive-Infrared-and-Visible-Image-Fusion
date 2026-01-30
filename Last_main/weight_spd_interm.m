function [sMap,Cmax,i_mean,i_mean2] = weight_spd_interm(i_mean1,p,r2,lambda)
R=2*r2+1;
[h,w,~,~]=size(i_mean1);
N1 = boxfilter(ones(h, w), r2);
if size(i_mean1,4)==1
    N = size(i_mean1,3);
else
    N = size(i_mean1,4);
end
C = zeros(size(i_mean1,1),size(i_mean1,2),N);
i_mean2= zeros(size(i_mean1,1),size(i_mean1,2),N);
i_mean= zeros(size(i_mean1,1),size(i_mean1,2),N);
for i = 1:N
        img = i_mean1(:,:,i);
        i_mean2(:,:,i)=boxfilter(img, r2)./ N1;
        i_var2= boxfilter(img.*img, r2) ./ N1- i_mean2(:,:,i).* i_mean2(:,:,i);
  i_mean(:,:,i) = SSFF(img,r2,lambda);
        i_var2=sqrt(max(i_var2,0));
        C(:,:,i) = i_var2 * sqrt( R^2  ); 
end
Cmax=max(C,[],3);
sMap1 = C.^p;
sMap2 = C.^(p-1);
normalizer = sum(sMap1,3);
sMap = sMap2 ./ repmat(normalizer,[1, 1, N]) ;