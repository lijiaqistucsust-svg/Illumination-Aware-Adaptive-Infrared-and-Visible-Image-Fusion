function [D1] = ATEE(D1,imgSeqColor)
[h,w,n]=size(imgSeqColor);
gradient = zeros(h,w,n);
k =1.5;
for i =1:n
          g = imgSeqColor(:,:,i)*255;
g= imgradient(g);
g = mat2gray(g);
gradient1 = reshape(g, 1, h*w);
 gradient1 = max(gradient1,1e-6);
[phat,~] = mle((gradient1),'Distribution','LogNormal'); 
% g( g <=  exp((phat(1)+phat(2))))  = 0; %图像梯度+正态分布
g( g <=  exp((phat(1)+phat(2)*k)))  = 0; %图像梯度+正态分布
%     g( g <=  exp((phat(1)+(phat(2).^2)/2)))  = 0; %图像梯度+正态分布
     gradient(:,:,i) = g;
end


radius = 2;
epsilon = 0.015;
fAmp = 2;

%  [a , b]= guidedfilter_ab(D1, D1, radius, epsilon);
%  base0 =a.*D1 + b;
  base0 = SSFF(D1,radius,epsilon);


    detailF = D1 - base0;%-0.0812~0.0859
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        gradient2 = gradient(:,:,1)>0;
    gradient2 =gradient2+gradient(:,:,2)>0;
    gradient2 = min(gradient2,1);
    detailF = detailF.*gradient2;
    base0 = D1-detailF;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
    D1 = base0 + fAmp * detailF ;    % 0.241    %0.035,所以把famp从2改为了15，计算得到0.2634


end