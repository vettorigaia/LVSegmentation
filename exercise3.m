%% Homework 3 exercise 3
% variable slice6 represents the series of 25 images (uint16) in the most automated way perform the segmentation of the endocardium of  the left ventricle (LV) for each frame (the papillary muscles inside the cavity should be considered as part of the cavity).
% The coordinates of the LV contour for each frame have to be extracted in clockwise direction and saved. At the end of the segmentation, the code should visualize the plot of the LV volume over time for the analyzed slice, computed in ml (use variables xres, yres e zres containing resolution in ml), and visualize for each frame the endocardial contours overlapped in green on the original image.
clear all
close all
clc
load h3_loopMRI.mat
slices=struct('cdata',[]);
n_slices=size(slice6,4);
% load slices and pre-process
for i=1:n_slices
    A=slice6(:,:,:,i);
    A=mat2gray(A);
    A=imadjust(A,stretchlim(A));
    slices(i).cdata=(A);
end
% first slice
A=slices(1).cdata;
radius_range=[22,32];
[center,radii]=imfindcircles(imbinarize(A),radius_range);
center_x=round(center(1));
center_y=round(center(2));
% all slices
boundaries=struct('coord',[]);
for i=1:n_slices
    A=slices(i).cdata;
    [boundaries(i).coord,area]=get_boundaries_and_area(A,center_x,center_y,radii);
    area=area*xres*yres; %mm^2
    volume(i)=area*zres; %mm^3
    sprintf('area of slice %g is %g mm^2',i,area)
    sprintf('volume of slice %g is %g ml',i,volume(i)/1000) %ml
end
total_volume=sum(volume);
sprintf('total volume of LV is %g ml',total_volume/1000) %ml
% plotting volume in time
x=1:n_slices;
Xq=1:n_slices;
Vq=interp1(x,volume/1000,Xq,"linear");
figure;
plot(x,volume/1000,'o',Xq,Vq,':.','LineWidth',2);
xlim([1 n_slices]);
ylabel('Volume [ml]');
xlabel('Time');
% plotting contours
for k=1:n_slices
    if mod(k-1,5)==0 %so we have 5 slices in one figure maximum
        j=0;
        figure;
    end
    j=j+1;
    p=sprintf('slice %0.f',k);
    a=boundaries(k).coord{1,1};
    a=flipud(a);
    l=length(a);
    subplot(2,3,j);imshow(slices(k).cdata,[]);title(p);
    hold on
    for m=1:l
        plot(a(m,1),a(m,2),'.g');
        drawnow
    end
end

%% Funzione per tutte le slice
function [boundaries,area]=get_boundaries_and_area(A,x,y, radii)
figure Name Create_MASK;
imshow(A)
h=drawcircle("Center",[x y],"Color",'r','Radius',round(radii));
Mask=h.createMask(A);
B=A.*Mask;
BW=B>0.3;
[BW_B,L]=bwboundaries(BW,8,'noholes');
close Create_MASK
[area,BW_B]=get_area(L);
boundaries=flipud(BW_B);
end
%% Funzione per dimesioni
function [area,BW_B]=get_area(L)
k=0;
area=0;
while area<20
    k=k+1;
    Segm=(L==k);
    Segm=imfill(Segm,"holes");
    area=(sum(reshape(Segm,1,[])==1));
end
BW_B=bwboundaries(Segm);
end