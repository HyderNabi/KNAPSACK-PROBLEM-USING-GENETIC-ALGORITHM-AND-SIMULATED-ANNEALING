function SimulatedAnnealing()
%KNAPSACK PROBLEM USING SIMULATED ANNEALING

%WEIGHTS OF 15 OBJECTS
Weights = [70,73,77,80,82,87,90,94,98,106,110,113,115,118,120];

%VALUES/COST/PROFIT OF THE RESPECTIVE OBJECTS
Values = [135,139,149,150,156,163,173,184,192,201,210,214,221,229,240];

%NO OF OBJECTS(LENGTH OF WEIGHTS/VALUES)
len = size(Weights,2);

%TOTAL CAPACITY OF THE KNAPSACK
Capacity = 750;

%INITIAL TEMPERATURE = 100
Temperature = 1000;

%TEMPERATURE REDUCTION FACTOR/SCHEDULE
alpha = 0.1;

%INITIAL CURRENT NODE/STATE
CurrentNode = zeros(1,len);

    %REPEAT UNTIL TEMPEATURE IS NEARLY 0
    while floor(Temperature) ~= 0       
        
        
        %RANDOMLY GENERATE THE SUCCESSOR OF THE CURRENT NODE.
        %BY CALLING GenerateSuccessor() FUNCTION
        NextNode = GenerateSuccessor(CurrentNode,Weights,Capacity);
        
        %CALCULATE THE OBJECTIVE COST OF THE CURRET NODE
        %THE OBJECTIVE COST HERE IS THE VALUE/PROFIT OF INDIVIDUAL OBJECTS
        %THE OBJECTIVE VALUE IS SUPPOSED TO MAXIMISE
        Value_Current = CalculateValue(CurrentNode,Values,len);
        
        %CALCULATE THE OBJECTIVE COST OF THE NEXT/SUCCESSOR NODE
        Value_Next = CalculateValue(NextNode,Values,len);
        
        %DELTA E
        %THE ENERGY: THE CHANGE IN THE VALUES OF CURRENT AND NEXT NODE/STATE
        %
        Change_in_Energy = Value_Next - Value_Current;
        
        %IF CHANGE IS POSITIVE
        %POSITIVE INDICATES THE GOODNESS OF THE NEXT NODE
        if Change_in_Energy > 0
            
            %MAKE NEXT NODE AS CURRENT  NODE 
            CurrentNode = NextNode;
            
        else
            %CALCULATE A RANDOM PROBABILITY
            randomProbability = rand(0,1);
            
            %CALCULATE THE THRESHOLD (PROBABILITY).
            %IT WILL INDICATE WHEATHER THE BAD NODE(NEXT NODE) WILL BE
            %SELECT AS CURRENT OR NOT
            %THE DOWN HILL STEP(IN OTHER TERMINOLIGY)
            Thrshold = exp(Change_in_Energy/Temperature);
            
            %IF RANDOM CALCULATED PROBABILITY IS LESS THAN THE THROSHOLD
            %THEN MAKE NEXT NODE AS CURRENT
            if randomProbability <= Thrshold
                CurrentNode = NextNode;
            end
        end
        
        %ADJUST THE TEMPERATURE 
        %REDUCE BY ALPHA
        Temperature = Temperature - alpha;
        
        
    end
    
    %PRINT THE FINAL VALUE
    Value_Current = CalculateValue(CurrentNode,Values,len)

end


%THIS FUNCTION IS USED TO GENERATE THE SUCCESSOR OF THE CURRENT NODE 
%WITH RANDOM PROBABILITY
function NextNode = GenerateSuccessor(CurrentNode,Weights,Capacity)
%SET VALUES IN THE CURRENT NODE TO VALUES IN THE NEXT NODE;
NextNode = CurrentNode;
   
    while true
        %GENERATE A RANDOM INDEX B/W 1 TO LAST INDEX OF STATE(NODE)
        randomIndex = floor(Random(1,size(CurrentNode,2)));
        
        %IF THE VALUE OF STATE AT THIS INDEX IS 0
        %BREAK AND CHANGE IT TO 1 OUTSIDE THE LOOP
        if NextNode(randomIndex) == 0
            break;
        end
    end
    
    
    %ADD THE ITEM IN THE KNAPSACK WITH RANDOM PROBABILITY    
    %BY SETTING THE RANDOMLY CHOOSEN POSITION TO 1 
    %(WE CAN SAY WE ARE ADDING AN ITEM TO THE KNAPSACK).
    NextNode(randomIndex) = 1;
    
    %IF THE WEIGHT OF THE KNAPSACK EXCEEDS THE LIMIT/CAPACITY
    %THEN DROP AN RANDOMLY CHOOSEN ITEM FROM THE KNAPSACK 
    %BY SETTING THAT POSITIN TO 0
    while sum(NextNode .* Weights)>Capacity
        
        while true
            %CHOOSE A RANDOM INDEX TO DROP AN ITEM
            randomIndex = floor(Random(1,size(CurrentNode,2)));
            
            %IF THE VALUE OF THE STATE AT THIS LOCATION IS 1
            %BRAEK AND SET IT TO 0 OUTSIDE THE LOOP
            if NextNode(randomIndex) == 1
                break;
            end
        end
        
        %DROP THE ITEM IF CONSTRAINTS ARE NOT SATISFIED
        %MEANS IF KNAPSACK CAPACIITY IS EXCEEDED
         NextNode(randomIndex) = 0;
        %LOOP AGAIN TO CHECK THE CONSTRAINTS
    end 

end





%THIS SIMPLE FUNCTION IS USED TO CALCULATE THE OBJECTIVE VALUE OF THE STATE
function stateValue = CalculateValue(state,Values,len)
    stateValue = 0;
    for i = 1:len
        %THE VALUE OF THE STATE IS THE ADDITION OF VALUES OF ALL THOSE
        %OBJECTS WHICH ARE PRESENT IN THE KNAPSACK
        stateValue = stateValue + state(i)*Values(i);
    end

end

%FUNCTION USED TO CALCULATE THE RANDOM NUMBER BETWEEN A SPEIFIED RANGE
function r = Random(a,b)
    r = (b-a).*rand()+a;
end
    
