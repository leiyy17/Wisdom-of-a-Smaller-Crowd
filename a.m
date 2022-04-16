function a=a(t1,t2)
Nt1=norminv(t1,0,1);  Nt2=norminv(t2,0,1);
a=2*pi*sqrt(t1*(1-t1)*t2*(1-t2))/(10*exp(-(Nt1.^2+Nt2.^2)/2));
if t1<t2
    a=(t1/t2)*a;
else
    a=(t2/t1)*a;
end
end