%AUTHOR : HYDER NABI
%ROLL NO. : 05
%IMPLEMANTAATON OF GENETIC ALGORITHM USING KNAPSACK PROBLEM
function GeneticAlgorithm()
%BINARY ENCODED CHROMOSES/STATES
%THE RANDOM INITIAL POPULAITON
population = load('population.txt');

%THE WEIGHTS OF EVERY OBJECT IN KNAPSACK PROBLEM
weights = [25,35,45,5,25,3,2,2];

%THE VALUES ASSOCIATED WITH EVERY OBJECT
values = [350,400,450,20,70,8,5,5];

%THE CAPACITY OF KNAPSACK
capacity = 104;

%INITIAL GENERATIONS
generation = 0;

%LOOP CONTROLLER
count = 1;

while count
    
    %#STEP 1
    %CALCULATE THE FITNESS OF EVERY STATE(CHROMOSOME) IN THE POPULATION
    %BY CALLING FITNESS FUNCTION
    population_fit = fitness(population,values,weights,capacity);
    
    %#STEP 2
    %SELECT THE CHROMOSOMES/STATES/PARENTS FOR REPRODUCTION/CROSSOVER
    %BY CALLING SELECTION FUNCTION
    parents = selection(population_fit,population);

    %#STEP 3
    %PERFORM THE CROSSOVER OF EVERY PAIR OF PARENTS USING PROBABILITY
    %BY CALLING CROSSOVER FUNCTION
    offsprings = crossover(parents);
    
    %#STEP 4
    %MUTATE THE CHROMOSOMES USING PROBABILITY
    %BY CALLING MUTATION FUNCTION
    newPopulation = mutation(offsprings);
    
    %THE NEW POPULATION(SET OF STATES) AT THE END OF FIRST GENERATION
    population = newPopulation;
    
    %THE NO OF GENERATONS(TERMINATION CRITERAI)
    if generation == 1000
        count = 0;
    end
    generation = generation + 1;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Final RESULT
%CALCULATE THE FITNESS OF EVERY CHROMESOME IN THE FINAL POPULAITON
fit = fitness(population,values,weights,capacity);

%CALCULATE THE INDEX OF CHROMOSOME/STATE WITH THE HIGHEST FITNESS
for i = 1:size(population,1)
    if fit(i) == max(fit);
        index = i;
    end
end
    
    %The Final Weight of objects in the Knapsack
   FinalWeight = finalResult(index,population,weights);
   %Their Value
   FinalValue = max(fit);
   %Their encoded(binary) representation
   FinalChromosome = population(index,:);
   
   %DISPLAY VALUES
   disp("WEIGHT");
   disp(FinalWeight);
   disp("VALUE");
   disp(FinalValue);
   disp("BINARY REPRESENTATION OF SOLUTION STATE");
   disp(FinalChromosome);
               

end


%THIS FUNCTION IS USED TO CALCLATE THE OBJECTIVE VALUE OR FITNESS VALUE
%OF EVERY CHROMOSOME IN THE POPULATION
function population_fit = fitness(population,values,weights,capacity)
 for i=1:size(population,1)
     %CALCULATE THE WEIGHTS OF EVERY CHROMOSOME
     % AND VALUE OF EVERY CHROMOSOME IN THE POPULATION
        temp_ft = 0;
        temp_wt = 0;
        for j = 1:size(population,2)
            temp_ft = temp_ft + (population(i,j)*values(j));
            temp_wt = temp_wt + (population(i,j)*weights(j));
        end;
        %IF WEIGHT OF CHROMOSOME EXCEEDS THE WEIGHT OF KNAPSACK 
        %THEN THE FITNESS IS ZERO
        %ELSE FITNESS IS THE SUM OF VALUES OF CORROSPONDING OBJECTS 
        if temp_wt > capacity
            population_fit(i) = 0;
        else
            population_fit(i) = temp_ft;
        end
    end
end


%THIS FUNCTION SELECTS THE CHROMOSOMES FOR CROSSOVER/REPRODUCTION.
%THE SELECTION CRITERIA IS BASED ON THE HIGHEST VALUE,
%WHICH IS PROPORTIONAL TO THE FITNESS OF EVERY CHROMOSOME
%THE MORE FIT IS THE CHROMOSOME , THE MORE CHANCES ARE TO GET SELECTED FOR
%REPRODUCTION/CROSSOVER
%THE PROCEDURE USED FOR SELECTION IS THE ROULETTE WHEEL
function parents = selection(population_fit,population)
%THE SUMO OF FITNESSES
S = sum(population_fit);

parents = [];

for i = 1:size(population,1)

%A RANDOM NUMBER BETWEEN 0 AND S
r = Random(0,S);

partial_sum = 0;

for j = 1:size(population,1)
    partial_sum = partial_sum + population_fit(j);
    %AT WHICH CHROMOSOME THE PARTIAL SUM EXCEEDS THE RANDOM NUMBER 
    %SELECT THAT CHROMOSOME AND ROTATE THE ROULETTE WHEEL AGAIN.
    %DUPLICATION MAY BE POSSIBLE 
    if partial_sum >= r
        parents(i,:) = population(j,:);
        break;
    end
end
end
end


%THIS FUNCTION PRODUCES THE OFFSPRINGS /CROSSOVER 
%IT IS BASED ON PROBABILITY (CROSSOVER RATE)
function offsprings = crossover(parents)
%Cross Over RATE (Probability) = CR
CR = 0.7;   
offsprings = [];

%TAKING PAIR OF CHROMOSOMES INDEX 1->(PAIR 1 AND 2), 3->(PAIR 3 AND 4)
for i = [1,3]
    %CHOOSE A RANDOM NUMBER BW 1 AND 0
    r = rand();
    
    %IF RANDOM NUMBER IS LESS THAN CR
    %THEN CROSSOVER HAPPENS
    %OTHERWISE SELECT CHROMOSOMES AS THEY ARE
    if r <= CR
        
        %THE CROSSOVER POINT IS RANDOMLY CHOOSEN
        %ONE POINT CROSSOVER METHOD IS USED
        
        crossover_point = ceil(Random(1,15));
        
        %CALL FUNCTION ONEPOINT() TO SWAP THE GENES/BITS IN A CHROMOSOME
        temp_offspring = onepoint(crossover_point,parents(i:i+1,:));
        
        offsprings(i:i+1,:)  = temp_offspring();
        
    else
        offsprings(i:i+1,:) = parents(i:i+1,:);
        
    end

end
    
    
    %function which swaps the bits/GENES after crossover point of a pair of parents 
    function temp_offspring = onepoint(crossover_point,parents_pair)
        temp_offspring = [];        
        temp = parents_pair(1,crossover_point+1:end);
        parents_pair(1,crossover_point+1:end) = parents_pair(2,crossover_point+1:end);
        parents_pair(2,crossover_point+1:end) = temp;
        temp_offspring = parents_pair;
        
    end
end


%THIS FUNCTION IS USED TO MUTATE THE CHROMOSOMES WITH PROBABILITY
function newPopulation = mutation(offsprings)
%Mutation Rate(PROBABILITY)
MR = 0.2;
newPopulation = [];

for i = 1:4
    for j = 1:8
        %CHOOSE A RANDOM NO FOR EVERY BIT/GENE IN EVERY CHROMOSOME.
        r = rand();
        
        %IF RANDOM NUMBER CHOOSEN IS LESS THAN THE MR
        %MUTATE THE BIT/FLIP THE BIT FROM 1 TO 0 OR 0 TO 1
        %ELSE MUTATION IS NOT PERFORMED FOR THAT BIT/GENE
        if r <= MR
            %flip the bits in a chromosome[mutation]
            %IF BIT IS 0 SET IT TO 1
            if(offsprings(i,j) == 0)
                newPopulation(i,j) = 1;
            else
                %ELSE SET TO TO 0
                newPopulation(i,j) = 0;
            end
        else
            newPopulation(i,j) = offsprings(i,j);
        end
    end
            
end
end

%FUNCTION WHICH CALCULATES THE FINAL RESULT/WEIGHT
function FinalWeight = finalResult(index,population,weights)
    FinalWeight = 0;
    for i = 1:size(population,2)
        FinalWeight = FinalWeight + (population(index,i)*weights(i));
    end
end

%FUNCTION WHICH GENERATES THE RANDOM NO WITHIN SPECIFIED INTERVAL 
function r = Random(a,b)
    r = (b-a).*rand()+a;
end
            
        



