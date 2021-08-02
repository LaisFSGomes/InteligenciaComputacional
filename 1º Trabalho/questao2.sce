//questão 2 do 1º trabalho de Inteligência Computacional, lógica fuzzy
//autor: Lais de Fátima Sousa Gomes, Matrícula 504405

clear;
clc;

//carregando os dados
dataset = fscanfMat("aerogerador.dat");



//Separando em dois vetores e normalizando
x = (dataset(:,1))/(max(dataset(:,1)));
y = (dataset(:,2))/(max(dataset(:,2)));

n = length(x);

//para a regularização de Tikhonov
lambda = 0.001;
sx = size(x')(1);

//apenas para que cada modelo de regressão gerado tenha uma cor diferente
cor = ['r', 'b', 'm', 'g', 'c', "k"];

//para cada potência (indo da potência 2 até a 7)
for pot=2:1:7
   
    //criar matriz X:
    X = ones(n, 1);
    for i=1:1:pot
        X = [X, x^i];
    end
    
    //matriz de coeficientes de regressao
    beta = (X'*X + lambda*eye(sx,sx))\X'*y;
    
    //modelo de previsao ajustado
    preditor = 0;
    for i=0:1:pot
        preditor = preditor + beta(i+1)*x^i;
    end
    
    //coeficiente de determinação
    r2 = 1- sum((y - preditor).^2)/sum((y - mean(y)).^2);
    ra = 1 - (((1 - r2)*(n - 1)))/((n - 1)-pot);
    
    //plotando os gráficos
    title("R2 = " + string(r2) + "      R2aj = "+ string(ra) + "      Grau de Potência: " + string(pot));
    
    if pot == 2 then
        plot(x,y,'y.');
        sleep(1000);
    end
    
    paracor = pot - 1;
    plot(x, preditor, cor(paracor));
    
    
    printf("\n\nGrau de Potencia: %d", pot);
    printf("\nR2 = %f", r2);
    printf("\nR2aj = %f", ra);
    //a cada dois segundos uma nova função de previsão será escrita na janela gráfica 
    sleep(2000);

end
