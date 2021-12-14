function [img1] = myEdgeFilter(img0, sigma)
%sigma=2
hsize = 2 * ceil(3 * sigma) + 1
h=fspecial('gaussian',hsize,sigma);
%img0=imread('img0.jpg');
%% Smoothing
ys=myImageFilter(img0,h);
%% applying SobelX and SobelY
sx = [-1 0 1;-2 0 2;-1 0 1];
sy = [1 2 1;0 0 0;-1 -2 -1];
imgx=myImageFilter(ys,sx);
%figure(2);imshow(imgx);title('sobel x filter')
imgy=myImageFilter(ys,sy);
%figure(3);imshow(imgy);title('sobel y filter');
imgM=(sqrt((imgx.^2)+imgy.^2));
%figure(4);imshow(imgM);title('sobel magnitude');

%% Non-max supression
[m,n]=size(imgM);
img1=zeros(m,n);
img1=imgM;
for r=1+ceil(hsize/2):m-ceil(hsize/2) ;
    for c=1+ceil(hsize/2):n-ceil(hsize/2);
         if (imgx(r,c) == 0) angle = 5;       
        else angle = (imgy(r,c)/imgx(r,c));   
         end
        if (-0.4142<angle && angle<=0.4142);
            if(imgM(r,c)<imgM(r,c+1) || imgM(r,c)<imgM(r,c-1));
                img1(r,c)=0;
            end
        end
        if (0.4142<angle && angle<=2.4142);
            if(imgM(r,c)<imgM(r-1,c+1) || imgM(r,c)<imgM(r+1,c-1));
                img1(r,c)=0;
            end
        end
        if ( abs(angle) >2.4142);
            if(imgM(r,c)<imgM(r-1,c) || imgM(r,c)<imgM(r+1,c));
                img1(r,c)=0;
            end
        end
        if (-2.4142<angle && angle<= -0.4142);
            if(imgM(r,c)<imgM(r-1,c-1) || imgM(r,c)<imgM(r+1,c+1));
                img1(r,c)=0;

            end

        end

    end

end


%figure(5); imshow(img1);title('Non max supressed img')   

%imwrite(img1,'img.jpg');

end
    
                
        
        
