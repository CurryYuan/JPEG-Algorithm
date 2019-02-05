clearvars
src=imread('animal.jpg');

% 颜色转换
R=double(src(:,:,1));
G=double(src(:,:,2));
B=double(src(:,:,3));
Y=0.299*R+0.5870*G+0.114*B;
Cb=-0.1687*R-0.3313*G+0.5*B+128;
Cr=0.5*R-0.4187*G-0.0813*B+128;

% DCT变换
N=8;
T=zeros(N);
for i=0:N-1
    if i==0
        c=sqrt(1/N);
    else
        c=sqrt(2/N);
    end 
    for j=0:N-1          
        T(i+1,j+1)=c*cos(pi*(j+0.5)*i/N);
    end
end
fun=@(block_struct) T*block_struct.data*T';
Y1=blockproc(Y,[8 8],fun,'PadPartialBlocks',true);
Cb1=blockproc(Cb,[8 8],fun,'PadPartialBlocks',true);
Cr1=blockproc(Cr,[8 8],fun,'PadPartialBlocks',true);
    
% 标准亮度量化表
a=[16 11 10 16 24 40 51 61;
12 12 14 19 26 58 60 55;
14 13 16 24 40 57 69 55;
14 17 22 29 51 87 80 62;
18 22 37 56 68 109 103 77; 
24 35 55 64 81 104 113 92;                      
49  64 78 87 103 121 120 101;                   
72 92 95 98 112 100 103 99]; 

% 标准色差量化表
b=[17 18 24 47 99 99 99 99; 
18 21 26 66 99 99 99 99; 
24 26 56 99 99 99 99 99; 
47 66 99 99 99 99 99 99; 
99 99 99 99 99 99 99 99; 
99 99 99 99 99 99 99 99; 
99 99 99 99 99 99 99 99; 
99 99 99 99 99 99 99 99];

% 量化,根据标准量化表
fun1=@(block_struct) round(block_struct.data./a);
fun2=@(block_struct) round(block_struct.data./b);
Y2=blockproc(Y1,[8 8],fun1,'PadPartialBlocks',true);
Cb2=blockproc(Cb1,[8 8],fun2,'PadPartialBlocks',true);
Cr2=blockproc(Cr1,[8 8],fun2,'PadPartialBlocks',true);

[mf,nf]=size(Y2);

% hoffman for dc and ac coefficents
[dccof1, accof1]=hoffman(Y2,mf,nf);
[dccof2, accof2]=hoffman(Cb2,mf,nf);
[dccof3, accof3]=hoffman(Cr2,mf,nf);

dccofLength=length(dccof1)+length(dccof2)+length(dccof3);
accofLength=length(accof1)+length(accof2)+length(accof3);

disp(['DC coefficient after Huffman coding has ' int2str(dccofLength) ' bits']);
disp(['AC coefficient after Huffman coding has ' int2str(accofLength) ' bits']);
OB=mf*nf*3*8;
CB=dccofLength+accofLength;
disp(['Original Bit:  ' num2str(OB) ' bits']);
disp(['Compressed Bit:  ' num2str(CB) ' bits']);
disp(['Compression Ratio   ' num2str(OB/CB) ' : 1']);
disp(['Pixel Depth:   ' num2str(CB/mf/nf) '   bits / pixel ']);

