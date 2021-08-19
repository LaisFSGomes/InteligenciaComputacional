//3º trabalho de Inteligência Computacional, rede neural
//autor: Lais de Fátima Sousa Gomes, Matrícula 504405

clear; 
clc;

//_____Algumas funções auxiliares________________

//função de rosenbrock
function [z] = rosenbrock(x, y)
    z = (1 - x)^2 + 100*(y - x^2)^2;
endfunction
//converte para o valor real
function [val_real] = conv_real(val)
    val_real = lim_inf + (lim_sup - lim_inf)/((2^15)-1) * val;
endfunction

//converte de binário para decimal
function [val_dec] = bindec(val_bin)
    val_str = string(val_bin); //convertendo para string
    auxiliar = strcat(val_str); //concatenando
    val_dec = bin2dec(auxiliar); //fazendo a conversão
endfunction



//_____Main___________________

//informações iniciais
num_individuos = 100;
qtd_participantes = 4;
epocas = 100;
lim_inf = -5;
lim_sup = 5;
printf("1 - cruzamento do tipo um ponto de corte\n2 - cruzamento uniforme")
cruzamento_tipo = input("Tipo de cruzamento: "); //1 - um ponto de corte/ 2 - uniforme
taxa_mutacao = input("Taxa de mutação: ");


//criando a matriz de indivíduos aleatórios.
nuns0 = [zeros(num_individuos, 15)]; //matriz de 0s
nuns1 = [ones(num_individuos, 15)]; //matriz de 1s

aux = [nuns0 nuns1];
individuos = grand(1, 'prm', aux);

for epoca=1:epocas
    for i=1:num_individuos
        //separando x e y
        populacao_x = individuos(i, 1:15); 
        populacao_y = individuos(i, 16:30); 
        //convertendo de binário para decimal
        x(i) = bindec(populacao_x);
        y(i) = bindec(populacao_y);
        //convertendo para o valor real no intervalo pedido
        valor_real_x(i) = conv_real(x(i));
        valor_real_y(i) = conv_real(y(i));
        
        //calculando as notas dos indivíduos
        notas(i) = rosenbrock(valor_real_x(i), valor_real_y(i));
    end
    
    
    //_____selecionando os pais utilizando o método do torneio________
    
    participantes = individuos(1:qtd_participantes, 1:30); 
    nota_particicipates = notas(1:qtd_participantes, :);
    
    for i=1:num_individuos
        for j=1:qtd_participantes
            posicao = ceil(rand()*num_individuos) //gerando uma posição aleatória
            participantes(j, :) = individuos(posicao, 1:30);    //selecionando um individuo para participar do torneio
        end
        
        for j=1:qtd_participantes
            //separando x e y
            x_pcpt = participantes(j, 1:15);
            y_pcpt = participantes(j, 16:30);
            //convertendo binário -> decimal
            x_pcpt_decimal(j) = bindec(x_pcpt);
            y_pcpt_decimal(j) = bindec(y_pcpt);
            //convertendo para o valor real no intervalo pedido
            valor_real_x_pcpt(j) = conv_real(x_pcpt_decimal(j));
            valor_real_y_pcpt(j) = conv_real(y_pcpt_decimal(j));
            
            //calculando as notas dos participantes do torneio
            notas_pcpts(j, :) = rosenbrock(valor_real_x_pcpt(j), valor_real_y_pcpt(j));
        end
        [valor indice] = min(notas_pcpts);
        pais(i, :) = participantes(indice, :);
    end
    
    
    //_______________Fazendo o crossover de acordo com o método escolhido_____________________
        
    if cruzamento_tipo == 1
        //crossover com um ponto de corte
        ponto_de_corte = int(rand()*linspace(1,29, 1));
        
        for i=1:2:num_individuos
            ptcorte_mais1 = ponto_de_corte + 1; //o próximo após o ponto de corte
            
            esq_filho1 = pais(i, 1:ponto_de_corte);
            dir_filho1 = pais(i+1, ptcorte_mais1:30);
            
            esq_filho2 = pais(i+1, 1:ponto_de_corte);
            dir_filho2 = pais(i, ptcorte_mais1:30);
            
            filhos(i, :) = [esq_filho1 dir_filho1];
            filhos(i+1, :) = [esq_filho2 dir_filho2];
        end
    elseif cruzamento_tipo == 2 
        //crossover uniforme
        aux_cros_nuns0 = [zeros(1, 15)];
        aux_cros_nuns1 = [ones(1, 15)]; 
        aux_cros = [aux_cros_nuns0 aux_cros_nuns1];
        mascara_bits = grand(1, 'prm', aux_cros);
        
        pai1 = [ones(1,30)];
        pai2 = [ones(1,30)];
        for i=1:2:num_individuos
            filho1 = [ones(1,30)];
            filho2 = [ones(1,30)];
            pai1 = pais(i,:);
            pai2 = pais(i+1,:);
            for j=1:30
                if mascara_bits(j) == 0
                   filho1(j) = pai1(j);
                   filho2(j)= pai2(j);
                elseif mascara_bits(j) == 1
                    filho1(j) = pai2(j);
                    filho2(j)= pai1(j);
                end
            end
            filhos(i, :) = [filho1];
            filhos(i+1, :) = [filho2];
        end
    end
    
    
    //_______________mutação____________
    
    filhos_mutacao = [ones(num_individuos, 30)];   //inicializando
    filhos_mutacao = filhos;
    
    for i=1:num_individuos
        num_sort = rand(1, 'uniform'); //sorteio entre 0 e 1
        coluna_sort = ceil(rand()*30); //sorteio de uma coluna
        
        if num_sort < taxa_mutacao then
            filhos_mutacao(i, coluna_sort) = ~(filhos_mutacao(i, coluna_sort));
        end
    end
    individuos = filhos_mutacao;
end

for i=1:num_individuos
    //separando x e y
    populacao_x = individuos(i, 1:15); 
    populacao_y = individuos(i, 16:30); 
    //convertendo de binário para decimal
    x(i) = bindec(populacao_x);
    y(i) = bindec(populacao_y);
    //convertendo para o valor real no intervalo pedido
    valor_real_x(i) = conv_real(x(i));
    valor_real_y(i) = conv_real(y(i));
    
    //calculando as notas dos indivíduos
    notas(i) = rosenbrock(valor_real_x(i), valor_real_y(i));
end

[min_valor min_indice] = min(notas);

printf("Valor mínimo da função de rosenbrock: %f\n", min_valor);
printf("x = %f\n", valor_real_x(min_indice));
printf("y = %f\n", valor_real_y(min_indice));

//plotando o gráfico e a última geração
clf();
f=gcf(); 
f.color_map = rainbowcolormap(25);

xlabel('X'); 
ylabel('Y');

title('Geração:'+ string(epocas));
f.figure_name='Algorítmos Genéticos - Mínimo da Função de Rosenbrock';


intervalo_x = linspace(-6,6,30);
intervalo_y = linspace(-6,6,30);

for i=1:30
    for j=1:30
        z(i,j) = rosenbrock(intervalo_x(i), intervalo_y(j)); 
    end    
end

plot3d(intervalo_x, intervalo_y, z);
scatter3d(valor_real_x, valor_real_y, notas, 'fill');
