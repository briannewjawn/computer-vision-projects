function [H, rhoScale, thetaScale] = myHoughTransform(Im, threshold, rhoRes, thetaRes)
%Im=imread('img.jpg');
[a,b]=size(Im);
%rhoRes=2;
%threshold=0.03;
%thetaRes  = pi/90;
rhoMax=sqrt((a)^2 + (b)^2);
thetaMax=2*pi;
thetaScale=(0:thetaRes:thetaMax);
rhoScale=-rhoMax:rhoRes:rhoMax;
voteMatrix=zeros(size(rhoScale,2),size(thetaScale,2));
for j =1:a;
    for i=1:b;
        if Im(j,i)>=threshold;
            for theta=thetaScale;
                rho=i*cos(theta)+j*sin(theta);
                if rho>rhoMax;
                    rho=rhoMax;
                end
                rho_index = round((rho +rhoMax)/rhoRes) + 1;
                theta_index = round(theta/thetaRes) + 1;
                voteMatrix(rho_index,theta_index)=voteMatrix(rho_index,theta_index)+1;
     
            end
        end
    end
end
H=voteMatrix
%[H, rhoScale, thetaScale] = hough(Im, 'RhoResolution',2,'Theta',-90:2:89)
%imshow(imadjust(rescale(H)),'XData',thetaScale,'YData',rhoScale,...
   %'InitialMagnification','fit');
%title('Limited Theta Range Hough Transform ');
%xlabel('\theta');
%ylabel('\rho');
%axis on, axis normal;
%colormap(gca,hot)




end
        
        