function L_real=L_real(y_it)
global K; global I; global Q;
real_value=importdata('./real.xlsx');  real=real_value.data;
be=real(2:K+1,2:Q+1); 
si=real(K+3:K+Q+2,2:I+1);
mu=real(K+Q+4:K+2*Q+3,2:I+1); 
model.beta=reshape(be',K*Q,1);
model.sigma=reshape(si',Q*I,1);
model.mu=reshape(mu',Q*I,1);
L_real=result_y(model,y_it);
end