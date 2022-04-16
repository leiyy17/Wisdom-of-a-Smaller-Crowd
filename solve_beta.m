function be=solve_beta(si,mu,y_it,be0)
global K; global Q;
x0=be0; 
B=zeros(1,Q);  
P=cell(K);  
for i=1:K
    for j=1:K
        if i==j
            P(i,j)={ones(1,Q)}; 
        else  
            P(i,j)={B}; 
        end
    end
end
Aeq=cell2mat(P);  
beq=ones(K,1);
options=optimset('Algorithm','sqp','Display', 'off');
[x]=fmincon(@(x)fmincon_fun_beta(x,y_it,si,mu),x0,[],[],Aeq,beq,0.00001*ones(K*Q,1),ones(K*Q,1),[],options);
be=x;
end