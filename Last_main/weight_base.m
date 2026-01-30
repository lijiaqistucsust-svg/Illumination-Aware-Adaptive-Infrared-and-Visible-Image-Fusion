function W= weight_base(i_mean)
r = size(i_mean,1);
c = size(i_mean,2);
N = size(i_mean,3);
W = ones(r,c,N);
for i = 1:N
     img=i_mean(:,:,i);
 M=ones(size(i_mean,1),size(i_mean,2))*mean(img(:));
 gamma=5;
y1=img.^gamma*(0.5.^(1-gamma)).*(img<=0.5);
  y2=(0.5-(0.5-(1-img)).^gamma*(0.25.^(1-gamma))).*(img>=0.5&img<0.75);
  y3=(1-img).^gamma*(0.25.^(1-gamma)).*(img>=0.75&img<=1);
  y4=M.^gamma*(0.5.^(1-gamma)).*(M<=0.5);
  y5=(0.5-(0.5-(1-M)).^gamma*(0.25.^(1-gamma))).*(M>=0.5&M<0.75);
  y6=(1-M).^gamma*(0.25.^(1-gamma)).*(M>=0.75&M<=1);
y=y1+y2+y3+y4+y5+y6;
W(:,:,i)=2*y;
end
W = W + 1e-12;
W = W./repmat(sum(W,3),[1 1 N]);





