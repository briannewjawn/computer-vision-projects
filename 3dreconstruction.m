
filenamevue2mp4 = 'Subject4-Session3-24form-Full-Take4-Vue2.mp4';
filenamevue4mp4 = 'Subject4-Session3-24form-Full-Take4-Vue4.mp4';
vue2video = VideoReader(filenamevue2mp4);
vue4video = VideoReader(filenamevue4mp4);

load('Subject4-Session3-Take4_mocapJoints.mat');

mocapFnum = 1000; %mocap frame number 1000
x = mocapJoints(mocapFnum,:,1); %array of 12 X coordinates
y = mocapJoints(mocapFnum,:,2); % Y coordinates
z = mocapJoints(mocapFnum,:,3); % Z coordinates
conf = mocapJoints(mocapFnum,:,4); %confidence value
%% load camera 4 and compute for pixel points
load("vue2CalibInfo");

[M2, pixelcord2] = Calculate_M_Matrix(vue2,mocapFnum,x,y,z);
vue2video.CurrentTime = (mocapFnum-1)*(50/100)/vue2video.FrameRate;
vid2Frame = readFrame(vue2video);
%% showing 3d points match to pixel point
figure(1)
imshow(vid2Frame);
hold on;
plot(pixelcord2(1,1:12),pixelcord2(2,1:12), 'r*', 'LineWidth', 2, 'MarkerSize', 2);
hold off;
%% load camera 4
load("vue4CalibInfo");
[M4, pixelcord4] = Calculate_M_Matrix(vue4,mocapFnum,x,y,z);
vue4video.CurrentTime = (mocapFnum-1)*(50/100)/vue4video.FrameRate;
vid4Frame = readFrame(vue4video);

figure(4)
imshow(vid4Frame);
hold on;
plot(pixelcord4(1,1:12),pixelcord4(2,1:12), 'r*', 'LineWidth', 2, 'MarkerSize', 2);
hold off;
%% triangulation
p2=M2;
p4=M4;
for i=1:12
A=[pixelcord2(2,i)*p2(3,:)-p2(2,:); p2(1,:)-pixelcord2(1,i)*p2(3,:);
    pixelcord4(2,i)*p4(3,:)-p4(2,:); p4(1,:)-pixelcord4(1,i)*p4(3,:)];
[u,d] = eigs(A' * A);
uu=u(:,4);
coords3d(:,i)=uu(1:3)/uu(4);
end
figure(6)
subplot(2,1,1);
plot3(coords3d(1,1:3), coords3d(2,1:3),coords3d(3,1:3)); axis image; hold on; title('projected 3d skeleton');
plot3(coords3d(1,4:6), coords3d(2,4:6),coords3d(3,4:6)); hold on;
plot3(coords3d(1,7:9), coords3d(2,7:9),coords3d(3,7:9)); hold on;
plot3(coords3d(1,10:12), coords3d(2,10:12),coords3d(3,10:12)); hold on;
subplot(2,1,2); plot3(x(1:3),y(1:3),z(1:3)); axis image; hold on; title('original 3d skeleton');
plot3(x(4:6),y(4:6),z(4:6));
hold on;
plot3(x(7:9),y(7:9),z(7:9));
hold on;
plot3(x(10:12),y(10:12),z(10:12));
hold off;

%% L2 (Euclidean) distance
xprime=coords3d(1,1:12);
yprime=coords3d(2,1:12);
zprime=coords3d(3,1:12);
Lsquared= (sqrt((x-xprime).^2 + (y-yprime).^2 +(z-zprime).^2))';
Lavg =sum(Lsquared/12);

%% epipolar lines
[~,n,~] = size(vid2Frame);
left_x = pixelcord2(1,:); left_y = pixelcord2(2,:);
right_x = pixelcord4(1,:); right_y = pixelcord4(2,:);

figure(2)
subplot(2,1,1); imshow(vid2Frame); axis image; hold on;
subplot(2,1,2); imshow(vid4Frame); axis image; hold on;
%% find epipoles

cam1location=vue2.position;
cam1location(4)=1;
lepipole=M4.*cam1location;
cam2location=vue4.position;
cam2location(4)=1;
repipole=M2.*cam2location;
%% Draw epipolar lines 
for i=1:round(size(left_x,2)/10):size(left_x,2);

    left_epipolar_x = 1:n;
    left_epipolar_y = left_y(i) + (left_epipolar_x-left_x(i))*...
        (lepipole(2)-left_y(i))/(lepipole(1)-left_x(i));
    subplot(2,1,1);
    plot(left_epipolar_x, left_epipolar_y);
    plot(left_x(i), left_y(i));
    right_epipolar_x = 1:n;
    right_epipolar_y = right_y(i) + (right_epipolar_x-right_x(i))*...
        (repipole(2)-right_y(i))/(repipole(1)-right_x(i));
    subplot(2,1,2);
    plot(right_epipolar_x, right_epipolar_y);
    plot(right_x(i), right_y(i));
end
p=profile('info');

