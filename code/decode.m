% first run the encode.m to get the accof and dccof coding, 
% and the size mf nf
[m, n,~]=size(src);
Y3=reconstruct(accof1,dccof1,mf,nf,a);
Cb3=reconstruct(accof2,dccof2,mf,nf,b);
Cr3=reconstruct(accof3,dccof3,mf,nf,b);

R1=Y3+1.402*(Cr3-128);
G1=Y3-0.34414*(Cb3-128)-0.71414*(Cr3-128);
B1=Y3+1.772*(Cb3-128);

img(:,:,1)=mat2gray(R1(1:m,1:n),[0 255]);
img(:,:,2)=mat2gray(G1(1:m,1:n),[0 255]);
img(:,:,3)=mat2gray(B1(1:m,1:n),[0 255]);

subplot(1,2,1),imshow(src),title(' Original ');
subplot(1,2,2),imshow(img),title(' Reconstructed ');

% Calculate MSE , PSNR
MSE=mean(mean((im2uint8(img)-src).^2))   
PSNR=10*log10(255^2/MSE)      
