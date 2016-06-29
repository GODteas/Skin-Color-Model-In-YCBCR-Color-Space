clc;clear all;close all;
text_set = imread('C:\Users\viplab\Desktop\新增資料夾 (5)\test_set\Barrett_Jackman_0002.jpg');
text =strrep ('C:\Users\viplab\Desktop\新增資料夾 (5)\test_set\Barrett_Jackman_0002.jpg','.jpg','.ppm');
cross_img = imread(text);
text_img = rgb2ycbcr(text_set);
   
figure;
g1 = (text_img(:,:,2)<135 & text_img(:,:,2)>75)&(text_img(:,:,3)<180&text_img(:,:,3)>130);
imshow(g1,[]),title('第一階段');

run_img = double(text_set);

test_img1(:,:,1)=(double(g1).*run_img(:,:,1));
test_img1(:,:,2)=(double(g1).*run_img(:,:,2));
test_img1(:,:,3)=(double(g1).*run_img(:,:,3));

r_img = double(reshape(test_img1,size(test_img1,1)*size(test_img1,2),3));
% new_c1_sum = new_c1_sum+((new_Y1(i,:)-u1)*(new_Y1(i,:)-u1)');


for i =1:size(r_img,1)
   for k=1:3
    m_in(k)=(r_img(i,:)-new_u(k))*inv(new_c(:,:,k))*(r_img(i,:)-new_u(k))';
   end
    minput(i)=min(m_in);
end
minput=reshape(minput,size(run_img,1),size(run_img,2));
out_i= (minput(:,:)<max(max(New_M)));
%out_i=double(g1)-out_i;
figure,imshow(out_i),title('第二階段篩選 binary pic');
total_and=bitand(out_i,(cross_img(:,:,2)~=0));
recall=size(find(total_and))/size(find(cross_img(:,:,2)~=0));
precision = size(find(total_and))/size(find(out_i));
   
figure,imshow(uint8(test_img1),[]),title('第一階段篩選');


test_img1(:,:,1)=(double(out_i).*run_img(:,:,1));%經過第二次篩選與原圖做and
test_img1(:,:,2)=(double(out_i).*run_img(:,:,2));
test_img1(:,:,3)=(double(out_i).*run_img(:,:,3));
figure,imshow(uint8(test_img1),[]),title('第二階段篩選');