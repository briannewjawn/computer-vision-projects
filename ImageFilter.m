function [img1] = myImageFilter(img0, h)
%h=[0 -1 0; -1 5 -1; 0 -1 0];
%img0=imread('img0.jpg');


[a,b,~]= size(img0);
[c,d]=size(h);
img=padarray(img0,[c d]);
img=im2double(img);
img1=zeros(a+c,b+d);


for j = 1: a+c-1;
    for k = 1: b+d-1;
        img1(j,k)=sum(sum(img(j:j+c-1,k:k+c-1).*h));
    end
end
%imshow(img1)
end

