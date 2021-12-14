function [rhos, thetas] = myHoughLines(H, nLines)
%nLines=50;
%% sfoerster Non max supression https://github.com/sfoerster/matlab/blob/master/hough/hough_peaks.m/help from TA
[a,b]=size(H);
NonHmax=imregionalmax(H).*H;
%% hough line help from  TA
H2=reshape(NonHmax,1,[]);
[H2,x]=sort(H2,'descend');
indexs=x(1:nLines)';
rhos=mod(indexs,a);
thetas=floor(indexs/a)+1;


end


        