function [iFf] = reconstruct(accof, dccof, mf, nf, Q)

acarr=jacdec(accof);
dcarr=jdcdec(dccof);

mb=mf/8; nb=nf/8;  % Number of blocks

Eob=find(acarr==999);
kk=1;ind1=1;n=1;
for ii=1:mb
    for jj=1:nb
        ac=acarr(ind1:Eob(n)-1);
        ind1=Eob(n)+1;
        n=n+1;
        ri(8*(ii-1)+1:8*ii,8*(jj-1)+1:8*jj)=dezz([dcarr(kk) ac zeros(1,63-length(ac))]);
        kk=kk+1;
    end
end

iFq=round(blkproc(ri,[8 8],'x.*P1',Q));
iFf=blkproc(iFq,[8 8],'idct2');  

end