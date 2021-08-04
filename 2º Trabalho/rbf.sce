//questão 2 do 2º trabalho de Inteligência Computacional, rbf para classificação do database iris_log
//autor: Lais de Fátima Sousa Gomes, Matrícula 504405

clear;
clc;
//______Funcoes auxiliares________
function x = norm_zscore(data, tam)
    for i=1:tam
        x(i,:) = (data(i,:)- mean(data(i, :)))/stdev(data(i,:));
    end
endfunction

function z = func_gaussiana(n,q,x,z,c)
    for i=1:n
        for j=1:q
            v = norm(x(:,i) - c(:,j));
            z(j,i) = exp(-(1/2)*(v^2));
        end
    end
endfunction



//______Main________
dataset = fscanfMat('iris_log.dat');
lengthdata = size(dataset)(1);
cont = 0; //para contar o número de acertos da rbf
Q = input("Quantidade de neurônios ocultos: ");

for  iteracao=1 : lengthdata 
    X = dataset(:,1:4)'; //dados
    D = dataset(:,5:7)';//classe dos dados
    
    //normalizando os dados
    X = norm_zscore(X, 4);
    
    //retirando os dados de teste do treino
    amostra_teste = X(:, iteracao);
    X(:, iteracao) = [];
    D(:, iteracao) = [];
    
    [p N] = size(X); 
    C = rand(p, Q, 'normal'); //vetor de pesos aleatorios
  
    Z = zeros(Q, N);
    Z = func_gaussiana(N,Q,X,Z,C);
 
    Zb = [(-1)*ones(1, N); Z];//adicionando o bias em Z
    
    M = D*Zb'/(Zb*Zb');//pesos da camada de saída obtidos
    
    
    //____Teste_____
    z = zeros(Q, 1);
    z = func_gaussiana(1,Q,amostra_teste,z,C);

    zb = [(-1)*ones(1, 1); z]; //adicionando o bias
    
    D_prev = M*zb; //classe prevista
    
    [num indiceP] = max(D_prev);
    [num indiceD] = max(dataset(iteracao,5:7));
    
    //fazendo a iteração do cont para calcular a acurácia
    if indiceP==indiceD
        cont=cont + 1;
        printf("________________\niteração: %d\nAcertou!\n", iteracao);
    else
        printf("________________\niteração: %d\nErrou!\n", iteracao);
    end
end

acuracia = cont/150;
printf('____________\n\nACURACIA OBTIDA:%f\n____________', acuracia);

 messagebox("Acurácia: "+ string(acuracia),"Acurácia obtida!");
