function dif=difference(t)
if t>0
    if t<1
       a=norminv(t+0.0000000001,0,1)-norminv(t,0,1);
       dif=a/0.0000000001;
    end
end
end