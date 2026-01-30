function [fI3, i_meant,aa,N1] = scale_coarse(i_mean2,r3,lambda,S_map2)
[h,w,n]=size(i_mean2);
N = boxfilter(ones(h, w), r3);
tem=ones(h, w);
tem(:,2:2:w)=0;
tem(2:2:h,:)=0;
N1= boxfilter(tem, r3);
p=6;
[WD, Cmax,i_mean,i_mean02]= weight_spd_coarse(i_mean2,p,r3,lambda);
WD=WD.*repmat(Cmax,[1 1 n]);
WB= weight_base(i_mean);
F_temp2_detail=zeros(h,w,n);
F_temp2_base=zeros(h,w,n);
i_meant=zeros(ceil(h/2),ceil(w/2),2);
tic
for i = 1:n
        aa=i_mean(:,:,i).*tem;
    i_meant(:,:,i)=aa(1:2:h,1:2:w);
    W_D1=boxfilter(i_mean02(:,:,i).*WD(:,:,i), r3)./ N;
    W_D2=boxfilter(WD(:,:,i), r3)./ N;
    W_B2=boxfilter(i_mean(:,:,i).*WB(:,:,i), r3)./ N;
    F_temp2_detail(:,:,i)=W_D2.*(i_mean2(:,:,i))-W_D1;
    F_temp2_base(:,:,i)= W_B2;  
end
F_temp2_base = sum(F_temp2_base,3);
w1 = 0.5+(S_map2(:,:,1)-S_map2(:,:,2))/2;
F_temp2_detail= w1.*F_temp2_detail(:,:,1) + (1-w1).*F_temp2_detail(:,:,2);
fI3=F_temp2_detail+F_temp2_base;
end



