function b=b(t1,t2)
diff1=difference(t1);  diff2=difference(t2);
b=diff1*diff2;
if t1<t2
    b=(t1/t2)*diff1*diff2;
else
    b=(t2/t1)*diff1*diff2;
end
end