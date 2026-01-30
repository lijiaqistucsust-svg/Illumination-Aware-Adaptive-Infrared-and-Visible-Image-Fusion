
function [D1, i_meant,aa,N1,S_map1] = scale_fine(imgSeqColor,r1,lambda)
[h,w,n]=size(imgSeqColor);
N = boxfilter(ones(h, w), r1);
tem=ones(h, w);
tem(:,2:2:w)=0;
tem(2:2:h,:)=0;
N1= boxfilter(tem, r1);
p=6;
[WD, Cmax,i_mean,S_map,i_mean2]= weight_spd_fine(imgSeqColor,p,r1,lambda);%S_map表示红外图像显著图，用像素值区分。可见光图像显著图用梯度值区分
WD=WD.*repmat(Cmax,[1 1 n]);
F_temp2_detail=zeros(h,w,n);
i_meant=zeros(ceil(h/2),ceil(w/2),2);
S_map1=zeros(ceil(h/2),ceil(w/2),2);
tic
for i = 1:n
     aa=S_map(:,:,i).*tem;
    S_map1(:,:,i)=aa(1:2:h,1:2:w);
     aa=i_mean(:,:,i).*tem;
    i_meant(:,:,i)=aa(1:2:h,1:2:w);
    W_D1=boxfilter(i_mean2(:,:,i).*WD(:,:,i), r1)./ N;
    W_D2=boxfilter(WD(:,:,i), r1)./ N;
    F_temp2_detail(:,:,i)=W_D2.*imgSeqColor(:,:,i)-W_D1;
end
 D1 = ERNG(F_temp2_detail,S_map);
end



