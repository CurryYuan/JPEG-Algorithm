function [dccof, accof] = hoffman(x,mf,nf)

mb=mf/8;
nb=nf/8;

fdc=reshape(x(1:8:mf,1:8:nf)',mb*nb,1);
fdpcm=dpcm(fdc,1);

dccof=[];
for i=1:mb*nb
    dccof=[dccof jdcenc(fdpcm(i))];
end

% Zig-Zag scanning of AC coefficients
z=[1   2   6   7  15  16  28  29
   3   5   8  14  17  27  30  43
   4   9  13  18  26  31  42  44
  10  12  19  25  32  41  45  54
  11  20  24  33  40  46  53  55
  21  23  34  39  47  52  56  61
  22  35  38  48  51  57  60  62
  36  37  49  50  58  59  63  64];

acseq=[];
for i=1:mb
  for j=1:nb
    tmp(z)=x(8*(i-1)+1:8*i,8*(j-1)+1:8*j); 
    % tmp is 1 by 64
    eobi=find(tmp~=0, 1, 'last' ); %end of block index
    % eob is labelled with 999    
    acseq=[acseq tmp(2:eobi) 999];
  end
end
accof=jacenc(acseq);

end