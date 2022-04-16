function sigma_qiNt=sigma_qiNt_vector(si)
global I; global Q; global Nt;
si=reshape(si,I,Q)';
for q=1:Q
    for i=1:I
        sigma_qiNt{q,i}=si(q,i).*Nt; 
    end
end
end