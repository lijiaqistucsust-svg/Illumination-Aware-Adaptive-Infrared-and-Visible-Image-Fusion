function IR_good = try_good_infrared(IR)
sigma_bg = 15; % 根据图像分辨率调整，通常 10-20
IR_bg = imgaussfilt(IR, sigma_bg);
Saliency_Map = max((IR - IR_bg),0);
Saliency_Map = imadjust(Saliency_Map);
sigma_blur = 2; 
Saliency_Soft = imgaussfilt(Saliency_Map, sigma_blur);%柔化显著图
Mask_Norm = mat2gray(Saliency_Soft);%正则化显著图
Target_Mask = imadjust(Mask_Norm, [0.05, 0.8], [0, 1]);%显著图提取的重要区域
% IR_Blur_Background = imgaussfilt(IR, sigma_blur);%背景区域

radius = 1;
epsilon = 0.015;

base = SSFF(IR,radius,epsilon);
IR_good = IR .* Target_Mask + base .* (1 - Target_Mask);
end