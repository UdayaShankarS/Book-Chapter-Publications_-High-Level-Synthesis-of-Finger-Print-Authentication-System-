function Yt=thinningTh(X,c_idx)
%img = imread ('fp1.bmp'); 
%Xr = rgb2gray(img);
%X = imbinarize(img);
%X = X(1:128,1:64);
[M,N]=size(X);
Yt = false(M,N);
Y=false(M,N,20);
Z=false(M,N,20);
Y(:,:,1)=X;
Z(:,:,1)=X;

%%%%%%%%%%%%%%%%%
smax = 9;
persistent window;
if isempty(window)
    window = zeros(smax, smax);
end

cp = ceil(smax/2); % center pixel;

w3 = -1:1;
w5 = -2:2;
w7 = -3:3;
w9 = -4:4;

r3 = cp + w3;      % 3x3 window
r5 = cp + w5;      % 5x5 window
r7 = cp + w7;      % 7x7 window
r9 = cp + w9;      % 9x9 window

d3x3 = window(r3, r3);
d5x5 = window(r5, r5);
d7x7 = window(r7, r7);
d9x9 = window(r9, r9);

center_pixel = window(cp, cp);
% use 1D filter for 3x3 region
outbuf = get_median_1d(d3x3(:)');
[min3, med3, max3] = getMinMaxMed_1d(outbuf);

% use 2D filter for 5x5 region
outbuf = get_median_2d(d5x5);
[min5, med5, max5] = getMinMaxMed_2d(outbuf);

% use 2D filter for 7x7 region
outbuf = get_median_2d(d7x7);
[min7, med7, max7] = getMinMaxMed_2d(outbuf);

% use 2D filter for 9x9 region
outbuf = get_median_2d(d9x9);
[min9, med9, max9] = getMinMaxMed_2d(outbuf);


pixel_val = get_new_pixel(min3, med3, max3, ...
    min5, med5, max5, ...
    min7, med7, max7, ...
    min9, med9, max9, ...
    center_pixel);

% we need to wait until 9 cycles for the buffer to fill up
% output is not valid every time we start from col1 for 9 cycles.
persistent datavalid
if isempty(datavalid)
    datavalid = false;
end
pixel_valid = datavalid;
datavalid = (c_idx >= smax);


% build the 9x9 buffer
window(:,2:smax) = window(:,1:smax-1);
window(:,1) = X;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for k=2:20
    Y(:,:,k)=Y(:,:,k-1);
    for i=2:M-1
        for j=2:N-1
            y11=Y(i-1,j-1,k);
            y12=Y(i-1,j,k);
            y13=Y(i-1,j+1,k);
            y21=Y(i,j-1,k);
            y22=Y(i,j,k);
            y23=Y(i,j+1,k);
            y31=Y(i+1,j-1,k);
            y32=Y(i+1,j,k);
            y33=Y(i+1,j+1,k);
            if y22==0
                if y11==1&&y12==1&&y13==1&&y31==0&&y32==0&&y33==0
                    Y(i,j,k)=1;
                elseif y11==1&&y13==0&&y21==1&&y23==0&&y31==1&&y33==0
                    Y(i,j,k)=1;
                elseif y11==0&&y12==0&&y13==0&&y31==1&&y32==1&&y33==1
                    Y(i,j,k)=1;
                elseif y11==0&&y13==1&&y21==0&&y23==1&&y31==0&&y33==1
                    Y(i,j,k)=1;
                elseif y12==1&&y13==1&&y21==0&&y23==1&&y32==0
                    Y(i,j,k)=1;
                elseif y11==1&&y12==1&&y21==1&&y23==0&&y32==0
                    Y(i,j,k)=1;
                elseif y12==0&&y21==1&&y23==0&&y31==1&&y21==1
                    Y(i,j,k)=1;
                elseif y12==0&&y21==0&&y23==1&&y32==1&&y33==1
                    Y(i,j,k)=1;
                    %extra
                elseif y11==0&&y12==0&&y23==1&&y31==1&&y32==1&&y33==1
                    Y(i,j,k)=1;
                end
            else
            end
        end
    end
%    Y(:,:,k)= Y(:,:,k-1);
     if Y(:,:,k)==Y(:,:,k-1)
%         break;
     end
end
Yt=Y(:,:,k);
figure;
imshow(Yt);