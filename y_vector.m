function y_it=y_vector(y)
global I; global K;
y_it=cell(1,I);
for i=1:I
    y_it{i}=[];
    for k=1:K
        y_it{i}=[y_it{i};y{k,i}]; 
    end
end
end
