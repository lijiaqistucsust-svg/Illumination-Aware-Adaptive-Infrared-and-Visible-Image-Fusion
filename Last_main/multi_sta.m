function [C_out,D1,D21] = multi_sta(imgSeqColor)
    r1=4; 
    lambda=0.25;
    T=0.5;
    X = get_X(imgSeqColor(:,:,2));
    Y = get_Y(X);%Y大于0则为光照条件好的图片，小于0则为光照条件差。
    imgSeqColor = img_progress(imgSeqColor, Y);
    %% multi-scale scale
    [ D1,i_mean1,aa1,N1,S_map1] = scale_fine(imgSeqColor,r1,lambda);
    [w,h,~,~]=size(imgSeqColor);
    nlev = floor(log(min(w,h)) / log(2))-5;
    D2 = cell(nlev,1);
    aa2= cell(nlev,1);
    N2= cell(nlev,1);
    r2=4;
    lambda=lambda*T; 
    for ii=1:nlev
        [ D2{ii},i_mean2,aa2{ii},N2{ii},S_map2] = scale_interm(i_mean1,r2,lambda,S_map1);
        S_map1 = S_map2;
        i_mean1=i_mean2;
        lambda=lambda*T;
    end
    D22= D2{1};
    D21=zeros(size(aa1));
    D21(1:2:size(aa1,1),1:2:size(aa1,2))=D22;
    %% the coarsest  scale
    r3=3;
    [fI3,~,~,~] = scale_coarse(i_mean2,r3,lambda,S_map2);
    %% reconstruct
    %% Intermediate layers
    for ii=nlev:-1:1
        temp=aa2{ii};
        fI=zeros(size(temp));
        fI(1:2:size(temp,1),1:2:size(temp,2))=fI3;
        B2=boxfilter(fI, r2)./ N2{ii}+D2{ii};
        fI3=B2;
    end
    %% finest layers
    fI=zeros(size(aa1));
    fI(1:2:size(aa1,1),1:2:size(aa1,2))=B2;
    B1=boxfilter(fI, r1)./ N1;
    C_out=B1+D1;
end