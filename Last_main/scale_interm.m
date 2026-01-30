
function [fI3, i_meant,aa,N1,S_map2] = scale_interm(i_mean1,r2,lambda,S_map1)
[h,w,n]=size(i_mean1);
N = boxfilter(ones(h, w), r2);
tem=ones(h, w);
tem(:,2:2:w)=0;
tem(2:2:h,:)=0;
N1= boxfilter(tem, r2);
p=6;
[WD, Cmax,i_mean,i_mean2]= weight_spd_interm(i_mean1,p,r2,lambda);
WD=WD.*repmat(Cmax,[1 1 n]);
F_temp2_detail=zeros(h,w,n);
i_meant=zeros(ceil(h/2),ceil(w/2),2);
S_map2=zeros(ceil(h/2),ceil(w/2),2);
tic
for i = 1:n
     aa=S_map1(:,:,i).*tem;
    S_map2(:,:,i)=aa(1:2:h,1:2:w);
     aa=i_mean(:,:,i).*tem;
    i_meant(:,:,i)=aa(1:2:h,1:2:w);
    W_D1=boxfilter(i_mean2(:,:,i).*WD(:,:,i), r2)./ N;
    W_D2=boxfilter(WD(:,:,i), r2)./ N;
     F_temp2_detail(:,:,i)=W_D2.*(i_mean1(:,:,i))-W_D1;
end
w1 = 0.5+(S_map1(:,:,1)-S_map1(:,:,2))/2;
fI3= w1.*F_temp2_detail(:,:,1) + (1-w1).*F_temp2_detail(:,:,2);
end



