function out = Infrared_saliency_map(a)
img=uint8(255*a);
%% 方法1
% [count, ~] = imhist(img);
% Sal_Tab = zeros(256,1);
% for j=0:255
%     for i=0:255
% %     Sal_Tab(j+1) = Sal_Tab(j+1)+count(i+1)*abs(j-i);    
%     Sal_Tab(j+1) = Sal_Tab(j+1)+count(i+1)*max((j-i),0);   
%     end      
% end
% out=zeros(size(img));
% for i=0:255
%     out(img==i)=Sal_Tab(i+1);
% end 
% out=mat2gray(out);

%% 方法2
% 2. 快速背景估计 (取占比最高的3个灰度均值)
[counts, ~] = imhist(img);
[sorted_counts, sort_idx] = sort(counts, 'descend');

top_k = 3;
top_bins = sort_idx(1:top_k);       
top_counts = sorted_counts(1:top_k); 

% 计算背景灰度 (0-255)
bg_gray_level = sum((top_bins - 1) .* top_counts) / sum(top_counts);
% 转回 double (0-1)
bg_val = bg_gray_level / 255.0;

% 3. 计算显著性 (方向性差值：只取比背景亮的部分)
% 原始值域在这里是 [0, 1]
raw_saliency = max(a - bg_val, 0); 

% 5. 归一化：确保输出严格在 [0, 1]，与原函数一致
% 这一步非常重要，因为如果全图对比度很低，我们需要把它拉伸到 0-1
out = mat2gray(raw_saliency);
end