clc;clear all;close all;

[Original img1 Alpha] = imread('C:\Users\viplab\Desktop\新增資料夾 (5)\train\1.png');
%figure,imshow(Alpha)
[Origina2 img2 Alpha2] = imread('C:\Users\viplab\Desktop\新增資料夾 (5)\train\2.png');

A=zeros(10,3);
B=zeros(10,3);
%group=zeros(89677,3);
count=1;
count1=1;

for i =1:size(Original,1)
    for j =1:size(Original,2)       
         if(Alpha(i,j,:)~=0)
           A(count,:) = Original(i,j,:);
           count = count+1;
           
         end
    end
end
for i =1:size(Origina2,1)
    for j =1:size(Origina2,2)       
         if(Alpha2(i,j,:)~=0)
           B(count1,:) = Origina2(i,j,:);
           count1 = count1+1;
         end
    end
end

all_value=[A;B];
YCbCr_img = rgb2ycbcr(all_value); 
k_max = max(YCbCr_img(:,1)); %219.0627
k_min = min(YCbCr_img(:,1)); %0.0627
ky = (k_max-k_min)/3; %73

for i=1:1:4
   range(i) = k_min + (i-1)*ky; 
end

% count2 = [1 1 1];
i=1;
Y1 = YCbCr_img(find(YCbCr_img(:,1) >= range(i) & YCbCr_img(:,1) < range(i+1)),:);
i=2;
Y2 = YCbCr_img(find(YCbCr_img(:,1) >= range(i) & YCbCr_img(:,1) < range(i+1)),:);
i=3;
Y3 = YCbCr_img(find(YCbCr_img(:,1) >= range(i) & YCbCr_img(:,1) <= range(i+1)),:);
                                                                
% tic
% scatter3
figure,plot3(Y1(:,3),Y1(:,2),Y1(:,1),'y.'),title('Step 1');hold on
plot3(Y2(:,3),Y2(:,2),Y2(:,1),'g.');hold on
plot3(Y3(:,3),Y3(:,2),Y3(:,1),'r.');hold off
xlabel('Cr'), ylabel('Cb'), zlabel('Y')
% toc

% figure,plot3(Y1(:,1),Y2(:,2),Y3(:,3),'.');
% xlabel('Y'), ylabel('Cb'), zlabel('Cr')
% axis([16 235 16 240 16 240])


% step 2
for count=1:5

%算中心點
i=1;
u(i,1) = sum(Y1(:,1))/size(Y1,1); %55.8012 
u(i,2) = sum(Y1(:,2))/size(Y1,1); %-10.7048
u(i,3) = sum(Y1(:,3))/size(Y1,1); %14.7317

%每一個點跟質心算距離
c1_sum = zeros(3,3);
for i=1:size(Y1,1)
    c1_sum = c1_sum+((Y1(i,:)-u(1,:))'*(Y1(i,:)-u(1,:))); %1.3790e+06
end
C(:,:,1) = c1_sum/(size(Y1,1)-1); %379.0627

i=2;
u(i,1) = sum(Y2(:,1))/size(Y2,1); %124.6029
u(i,2) = sum(Y2(:,2))/size(Y2,1); %-22.5124
u(i,3) = sum(Y2(:,3))/size(Y2,1); %25.6704
c2_sum = zeros(3,3);
for i=1:size(Y2,1)
    c2_sum = c2_sum+((Y2(i,:)-u(2,:))'*(Y2(i,:)-u(2,:)));
end
C(:,:,2) = c2_sum/(size(Y2,1)-1);

i=3;
u(i,1) = sum(Y3(:,1))/size(Y3,1); %155.3709
u(i,2) = sum(Y3(:,2))/size(Y3,1); %-23.1759
u(i,3) = sum(Y3(:,3))/size(Y3,1); %26.0216

c3_sum = zeros(3,3);
for i=1:size(Y3,1)
   c3_sum = c3_sum+((Y3(i,:)-u(3,:))'*(Y3(i,:)-u(3,:))); 
end
C(:,:,3) = c3_sum/(size(Y3,1)-1);

M1_count=0; M2_count=0;M3_count=0;

new_M1=zeros(3,3); new_M2=zeros(3,3);new_M3=zeros(3,3);
New_M=zeros(1,3);
% step 3
% M1_inv_1=inv(c_one);M1_inv_2=inv(c_two);M1_inv_3=inv(c_three);
for i=1:size(Y1,1)
M1 = ((Y1(i,:)-u(1,:))*inv(C(:,:,1)))*(Y1(i,:)-u(1,:))';
M2 = ((Y1(i,:)-u(2,:))*inv(C(:,:,2)))*(Y1(i,:)-u(2,:))';
M3 = ((Y1(i,:)-u(3,:))*inv(C(:,:,3)))*(Y1(i,:)-u(3,:))';
%M1 = min(min(M1)); M2 = min(min(M2)); M3 = min(min(M3));

    if M1<M2 && M1<M3
        M1_count = M1_count+1;
        new_M1(M1_count,:)=Y1(i,:);
        New_M(M1_count,1)=M1;
%     end
    
    elseif M2<M1 && M2<M3
        M2_count = M2_count+1;
        new_M2(M2_count,:)=Y1(i,:);
        New_M(M2_count,2)=M2;
%     end
    
    elseif M3<M1 && M3<M2
        M3_count = M3_count+1;
        new_M3(M3_count,:)=Y1(i,:);
        New_M(M3_count,3)=M3;
    else
        disp('error');
    end
    
    
end

% M2_inv_1=inv(c_one);M2_inv_2=inv(c_two);M2_inv_3=inv(c_three);
for i=1:size(Y2,1)
M1 = ((Y2(i,:)-u(1,:))*inv(C(:,:,1)))*(Y2(i,:)-u(1,:))';
M2 = ((Y2(i,:)-u(2,:))*inv(C(:,:,2)))*(Y2(i,:)-u(2,:))';
M3 = ((Y2(i,:)-u(3,:))*inv(C(:,:,3)))*(Y2(i,:)-u(3,:))';

    if M1<M2 && M1<M3
        M1_count = M1_count+1;
        new_M1(M1_count,:)=Y2(i,:);
        New_M(M1_count,1)=M1;
%     end
    
    elseif M2<M1 && M2<M3
        M2_count = M2_count+1;
        new_M2(M2_count,:)=Y2(i,:);
        New_M(M2_count,2)=M2;
%     end
    
    elseif M3<M1 && M3<M2
        M3_count = M3_count+1;
        new_M3(M3_count,:)=Y2(i,:);
        New_M(M3_count,3)=M3;
    else
        disp('error');
    end
end
% M3_inv_1=inv(c_one);M3_inv_2=inv(c_two);M3_inv_3=inv(c_three);
for i=1:size(Y3,1)
M1 = ((Y3(i,:)-u(1,:))*inv(C(:,:,1)))*(Y3(i,:)-u(1,:))';
M2 = ((Y3(i,:)-u(2,:))*inv(C(:,:,2)))*(Y3(i,:)-u(2,:))';
M3 = ((Y3(i,:)-u(3,:))*inv(C(:,:,3)))*(Y3(i,:)-u(3,:))';

    if M1<M2 && M1<M3
        M1_count = M1_count+1;
        new_M1(M1_count,:)=Y3(i,:);
        New_M(M1_count,1)=M1;
%     end
    
    elseif M2<M1 && M2<M3
        M2_count = M2_count+1;
        new_M2(M2_count,:)=Y3(i,:);
        New_M(M2_count,2)=M2;
%     end
    
    elseif M3<M1 && M3<M2
        M3_count = M3_count+1;
        new_M3(M3_count,:)=Y3(i,:);
        New_M(M3_count,3)=M3;
    else
        disp('error');
    end
end


disp([num2str(count) '：']);
disp(['new M1: ' num2str(size(new_M1,1))]);
disp(['new M2: ' num2str(size(new_M2,1))]);
disp(['new M3: ' num2str(size(new_M3,1))]);

Y1 = new_M1;
Y2 = new_M2;
Y3 = new_M3;
end

% 
figure,axis([ 50 235 -50 50 -50 100]), xlabel('Y'), ylabel('Cb'), zlabel('Cr'), hold on;
for i=1:size(u,1)
    c = reshape(C(:,:,i), 3, 3);
    plot_gaussian_ellipsoid(u(i,:), c);
end;
% 

i=1;
new_u(i,1) = sum(new_M1(:,1))/size(new_M1,1);
new_u(i,2) = sum(new_M1(:,2))/size(new_M1,1);
new_u(i,3) = sum(new_M1(:,3))/size(new_M1,1);

new_c1_sum = 0;
for i=1:size(new_M1,1)
    new_c1_sum = new_c1_sum+((new_M1(i,:)-new_u(1,:))'*(new_M1(i,:)-new_u(1,:)));
end
new_c(:,:,1) = new_c1_sum/(size(new_M1,1)-1);
i=2;
new_u(i,1) = sum(new_M2(:,1))/size(new_M2,1);
new_u(i,2) = sum(new_M2(:,2))/size(new_M2,1);
new_u(i,3) = sum(new_M2(:,3))/size(new_M2,1);
new_c2_sum = 0; 
for i=1:size(new_M2,1)
    new_c2_sum = new_c2_sum+((new_M2(i,:)-new_u(2,:))'*(new_M2(i,:)-new_u(2,:)));
end
new_c(:,:,2) = new_c2_sum/(size(new_M2,1)-1);
i=3;
new_u(i,1) = sum(new_M3(:,1))/size(new_M3,1);
new_u(i,2) = sum(new_M3(:,2))/size(new_M3,1);
new_u(i,3) = sum(new_M3(:,3))/size(new_M3,1);
new_c3_sum = 0; 
for i=1:size(new_M3,1)
    new_c3_sum = new_c3_sum+((new_M3(i,:)-new_u(3,:))'*(new_M3(i,:)-new_u(3,:)));
end
new_c(:,:,3) = new_c3_sum/(size(new_M3,1)-1);