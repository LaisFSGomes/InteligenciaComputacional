//questão 1 do 2º trabalho de Inteligência Computacional, Perceptron Simples
//autor: Lais de Fátima Sousa Gomes, Matrícula 504405

clear;
clc;

epoca = input("quantidade de epocas: ");
n = input("quantos valores: ");


dados = [];
for i=1:n
    dados(i, 1) = -1;
    dados(i, 2) = input("coordenada x: ");
    dados(i, 3) = input("coordenada y: ");
    dados(i, 4) = input("classe: ");
end

//normalizando:
dados(:,2) = dados(:,2)./max(dados(:,2));
dados(:,3) = dados(:,3)./max(dados(:,3));
//isso por que os valores devem estar entre 0 e 1
dados(:,4) = dados(:,4)-1;


txaprendizagem= 0.6;

//pesos aleatórios    
w = [];
for i=1:3
    w(i) = rand();
end

//pont vai percorrer todas as linhas da matriz dados
pont = 1;

for i=1:epoca
    x = dados(pont, 1:3);
    esperado = dados(pont, 4);
    
    //sum
    //ativação
    ut= x*w;
    
    if ut>=0 then
        ut = 1;
    else
        ut = 0;
    end
    
    //prendizagem
    erro = esperado - ut;
    
    for i=1:3
        w(i)=w(i)+txaprendizagem*erro*x(i);
    end
    
    pont = pont+1;
    if pont>4 then
        pont = 1;
    end
    disp('------------');
    disp('Entrada');
    disp(x);
    disp('Alvo');
    disp(esperado);
    disp('obtido');
    disp(ut);
end


//plotagem
x1 = linspace(-3,5);
x2 = -((w(2)/w(3))*x1) + ((w(1)/w(3))); //equação da reta

xt = dados(:,2);
yt = dados(:,3);
classet = dados(:,4);

xclasse1 = [];
yclasse1 = [];
xclasse0 = [];
yclasse0 = [];

for i=1:4
    if classet(i) == 1 then
        xclasse1 = [xclasse1 xt(i)];
        yclasse1 = [yclasse1 yt(i)];
    elseif classet(i) == 0 then
        xclasse0 = [xclasse0 xt(i)];
        yclasse0 = [yclasse0 yt(i)];
    end        
end

plot(xclasse1,yclasse1,'p*');
plot(xclasse0, yclasse0, 'x');
plot(x1,x2,'r-');
