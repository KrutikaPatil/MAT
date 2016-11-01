% Plots medial axis transform of a polygon
% 31 October 2016


% function dist = distTransform(vertices)
vertices = [[5,0];[5,3];[2.5,1.5];[0,3];[0,0]]; % vertices of polygon in anti-clockwise order
x=vertices(:,1);y=vertices(:,2);
xmin=min(x); ymin=min(y);
xmax=max(x); ymax=max(y);
ar=(ymax-ymin)/(xmax-xmin);
res=1000; % resolution : decrease this to speed up the process accompanied by loss of accuracy
i=zeros(round(res*ar), res);
myPoly=roipoly(i,round(res/20)+0.9*res*(x-xmin)/(xmax-xmin),round(round(res/20)*ar)+0.9*round(res*ar)*(y-ymin)/(ymax-ymin));

dist=2*max(size(myPoly))*ones(size(myPoly));
dist=dist.*myPoly;

sqrt2 = sqrt(2);

%% Compute distance Transform
[yin, xin] = find(myPoly);
[yout, xout] = find(~myPoly);

for i = 1:numel(xin)
    dist(yin(i),xin(i)) = min((xout-xin(i)).^2 + (yout-yin(i)).^2);
    if rem(i,10)==0
        display(sprintf('%f', i/numel(xin)));
    end
end
%%  Compute Gradient of Distance Transform
imagesc(dist), axis image, colormap gray
dxp=  -dist+circshift(dist,1,2);
dxm=  dist-circshift(dist,-1,2);
dyp=  -dist+circshift(dist,1,1);
dym=  dist-circshift(dist,-1,1);
gradDiff=(dxp-dxm).^2+ar*ar*(dyp-dym).^2;

imagesc(double(gradDiff>150) + 0.5*myPoly); % plot medial axis
axis image;


%%
clf
figure(3);
subplot(2,2,1);
%contour(dist,100);
%C = del2(dist);
h=surf(dist);
set(h,'LineStyle','none')
title('Distance Transform');
%figure(4);
subplot(2,2,2);
h=surf(gradDiff);
set(h,'LineStyle','none')
title('Gradient of distance transform');
%figure(5);
subplot(2,2,3);
histogram(gradDiff,50);
%set(h,'LineStyle','none')
title('Histogram of gradient');
%figure(6);
subplot(2,2,4);
imagesc(double(gradDiff>150) + 0.5*myPoly); % plot medial axis
axis image;
title('Medial axis');

            
            
            
            
