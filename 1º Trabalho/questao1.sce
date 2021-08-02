//questão 1 do 1º trabalho de Inteligência Computacional, lógica fuzzy
//autor: Lais de Fátima Sousa Gomes, Matrícula 504405

clear;
clc;

//______________FUNÇÕES PARA A PRESSÃO DO PEDAL_____________
function lowPP = pressaoPedalLow(x)
    if x < 50 then
        lowPP = (50 - x) / 50;
    else lowPP = 0;
    end
endfunction

function mediumPP = pressaoPedalMedium(x)
    if (30>= x) | (x>=70) then
        mediumPP = 0;
    elseif (30<x) & (x<=50) then
        mediumPP = (x - 30)/20;
    elseif (50<=x) & (x<70) then
        mediumPP = (70-x)/20;
    end
endfunction

function highPP = pressaoPedalHigh(x)
    if x > 50 then
        highPP = (x - 50)/50
    else highPP = 0;
    end
endfunction

//______________FUNÇÕES PARA A VELOCIDADE DA RODA______________
function lowVR = velocidadeRodaLow(x)
    if x >= 60 then
        lowVR = 0;
    elseif x < 60 then
        lowVR = (60-x)/60;
    end
endfunction

function mediumVR = velocidadeRodaMedium(x)
    if (20 >= x) | (x >= 80) then
        mediumVR = 0;
    elseif (20 < x) & (x <= 50) then
        mediumVR = (x - 20)/30;
    elseif (50 < x) & (x < 80) then
        mediumVR = (80 - x)/30;
    end
endfunction

function fastVR = velocidadeRodaFast(x)
    if x <= 40 then
        fastVR = 0;
    elseif x > 40 then
        fastVR = abs((x - 40)/60);
    end
endfunction

//______________FUNÇÕES PARA A VELOCIDADE DO CARRO______________
function lowVC = velocidadeCarroLow(x)
    if x >= 60 then
        lowVC = 0;
    elseif x < 60 then
        lowVC = (60 - x)/60;
    end
endfunction

function mediumVC = velocidadeCarroMedium(x)
    if (20 >= x) | (x >= 80) then
        mediumVC = 0;
    elseif (20 < x) & (x < 50) then
        mediumVC = (x - 20)/30;
    elseif (50 <= x) & (x < 80) then 
        mediumVC = (80 - x)/30;
    end
endfunction

function fastVC = velocidadeCarroFast(x)
    if x <= 40 then
        fastVC = 0;
    elseif x > 40 then
        fastVC = abs((x - 40)/60);
    end
endfunction


//______________REGRAS ______________
function rule1 = regra1(pp)
    rule1 = pressaoPedalMedium(pp);
endfunction

function rule2 = regra2(pp, vc, vr)
    a = pressaoPedalHigh(pp);
    b = velocidadeCarroFast(vc);
    c = velocidadeRodaFast(vr);
    rule2 = min(a, b, c);
endfunction

function rule3 = regra3(pp, vc, vr)
    a = pressaoPedalHigh(pp);
    b = velocidadeCarroFast(vc);
    c = velocidadeRodaLow(vr);
    rule3 = min(a, b, c);   
endfunction

function rule4 = regra4(pp)
    rule4 = pressaoPedalLow(pp);
endfunction

//_______________DESNEBULIZAÇÃO_______________

function libera = liberar(p)
    libera = (100 - p)/100;
endfunction

function aperta = apertar(p)
    aperta = p/100;
endfunction

function resp = defuzzification(apertaFreio, liberaFreio)
    sum1 = 0;
    sum2 = 0;
    
    for x = 0:1:100
        a = apertar(x);
        l = liberar(x);
        
        if (liberaFreio <= l) & (liberaFreio >= a) then
            sum1 = sum1 + (liberaFreio*x);
            sum2 = sum2 + liberaFreio;
        elseif (liberaFreio >= l) & (l>=a) then
            sum1 = sum1 + (l*x);
            sum2 = sum2 + l;
        elseif (liberaFreio <= l) & (liberaFreio >= apertaFreio) then
            sum1 = sum1 + (liberaFreio*x);
            sum2 = sum2 + liberaFreio;
        elseif (liberaFreio>=l) & (l >= apertaFreio) then
            sum1 = sum1 + (l*x);
            sum2 = sum2 + l;
        elseif (liberaFreio >= l) & (apertaFreio <= l) then
            sum1 = sum1 + (l*x);
            sum2 = sum2 + l;
        elseif a >= apertaFreio then
            sum1 = sum1 + (apertaFreio*x);
            sum2 = sum2 + apertaFreio;
        elseif (a <= apertaFreio) & (a >= liberaFreio) then
            sum1 = sum1 + (a*x);
            sum2 = sum2 + a;
        end
    end
    resp = sum1/sum2;
endfunction

//_______________________MAIN____________________________
pressaoPedal = input("Valor da pressão do pedal: ");
velocidadeRoda = input("Valor da pressão da velocidade da roda: ");
velocidadeCarro = input("Valor da pressão da velocidade do carro: ");

r1 = regra1(pressaoPedal);
r2 = regra2(pressaoPedal, velocidadeCarro, velocidadeRoda);
r3 = regra3(pressaoPedal, velocidadeCarro, velocidadeRoda);
r4 = regra4(pressaoPedal);

aplicarFreio = r1 + r2;
liberarFreio = r3 + r4;

pressaoFreio = defuzzification(aplicarFreio, liberarFreio);


printf("\nPressão do Pedal\n");
printf("Plow(%f)= %f\n", pressaoPedal, pressaoPedalLow(pressaoPedal));
printf("Pmedium(%f)= %f\n", pressaoPedal, pressaoPedalMedium(pressaoPedal));
printf("Phigh(%f)= %f\n", pressaoPedal, pressaoPedalHigh(pressaoPedal));

printf("\nVelocidade da Roda\n");
printf("VRlow(%f)= %f\n", velocidadeRoda, velocidadeRodaLow(velocidadeRoda));
printf("VRmedium(%f)= %f\n", velocidadeRoda, velocidadeRodaMedium(velocidadeRoda));
printf("VRfast(%f)= %f\n", velocidadeRoda, velocidadeRodaFast(velocidadeRoda));

printf("\nVelocidade do Carro\n");
printf("VClow(%f)= %f\n", velocidadeCarro, velocidadeCarroLow(velocidadeCarro));
printf("VCmedium(%f)= %f\n", velocidadeCarro, velocidadeCarroMedium(velocidadeCarro));
printf("VCfast(%f)= %f\n", velocidadeCarro, velocidadeCarroFast(velocidadeCarro));

printf("\nRegra 1: %f\nRegra 2: %f\nRegra 3: %f\nRegra 4: %f\n", r1, r2, r3, r4);

printf("\nAperte o Freio: %f\nLibere o Freio: %f\n", aplicarFreio, liberarFreio);

printf("\nPressão do Freio: %f", pressaoFreio);












