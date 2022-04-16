function sigma_iNt=sigma_iNt_vector(si)
global I; global Q; global Nt; global N;
Ntt=repmat(Nt',Q,1);
Ntt=reshape(Ntt,1,numel(Ntt));
si=reshape(si,I,Q)';
for i=1:I
    sigma_iNt{i}=repmat(si(:,i),N,1);
    sigma_iNt{i}=sigma_iNt{i}.*Ntt';  
end
end