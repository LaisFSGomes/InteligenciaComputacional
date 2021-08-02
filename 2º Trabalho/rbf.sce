//RBF para fazer classificação iris_log
clear;
clc;

base = fscanfMat("iris_log.dat");
X=base(:,1:4)';
D=base(:,5:7)';

//normalizando - normalização z-score
for i=1:4
    X(i,:)=(X(i,:)-mean(X(i,:)))/stdev(X(i,:));
end

//separando os dados de treino e teste:
X_teste = X(:,1);
D_teste = D(:,1);
X(:,1) = [];
D(:,1) = [];

[p N] = size(X);


Q = input("quantos neurônios: ");

C = rand(p,Q, 'normal');

Z = zeros(Q,N);
for i=1:N
    for j=1:Q
       v = norm(X(:,i) - C(:,j));
       Z(j,i) = exp((-1/(2*(p^2)))*v^2);
    end     
end


Zb = [(-1)*ones(1, N); Z];

M = D*Zb'/(Zb*Zb');

//teste
z = zeros(Q,1);
for j=1:Q
    q= norm(X_teste - C(:,j));
    z(j,1) = exp((-1/(2*(p^2)))*q^2);
end

z = [-1; z];
D_prev = M*z(:,1);

disp(D_prev);
disp(D_teste);






