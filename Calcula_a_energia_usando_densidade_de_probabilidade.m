fileID = fopen('test.txt', 'r');
array = fscanf(fileID, '%f');

initialEnergy = array(1);
frequency = array(2);
soundVelocity = 343;

wallVariation = (6*(soundVelocity/frequency));
totalEnergy = 0;
x = 3;

energyArray = [];
distanceArray = [];
index = 1;

sourcePosition = [5 5 1.5];
receiverPosition = [12 2 1.5];

for y = 0:1:10
    for z = 3.1:0.5:(3.1 + wallVariation)
        wallPosition = [10 y z];
        
        receiverDistance = pdist([receiverPosition; wallPosition], 'euclidean');
        sourceDistance = pdist([sourcePosition; wallPosition], 'euclidean');
        totalDistance = pdist([sourcePosition; receiverPosition], 'euclidean');
        
        sigma = receiverDistance + sourceDistance - totalDistance;
        fresnelNumber = (2*frequency*sigma)/soundVelocity;
        soundAttenuation = 10*((5 + (20*log((sqrt(2*pi*fresnelNumber))/(tanh(sqrt(2*pi*fresnelNumber))))))/10);
        
        normal = [-1 0 0];
        incidentRay = wallPosition - sourcePosition;
        incidenceAngle = calculateAngle(incidentRay, normal);
        
        normal = [1 0 0];
        diffractionRay = receiverPosition - wallPosition;
        diffractionAngle = calculateAngle(diffractionRay, normal);
        
        probabilityDensity = 1/(1+(2*(0.2*(diffractionAngle + incidenceAngle))^2));
        energyResulting = ((initialEnergy - soundAttenuation)*probabilityDensity)*(1/(receiverDistance));
        
        if energyResulting > 0
%             if(ismember(receiverDistance, distanceArray))
%                 energyArray(find(distanceArray==receiverDistance)) = energyArray(find(distanceArray==receiverDistance)) + energyResulting;
%             else
                energyArray(index) = energyResulting;
                distanceArray(index) = receiverDistance;
                index = index + 1;
            %end
            %totalEnergy = totalEnergy + energyResulting;
        end
    end
end

aux_energyArray = energyArray;
aux_distanceArray = distanceArray;

distanceArray = sort(distanceArray);
index = 1;

while(index <= length(distanceArray))
    position = find(distanceArray(index)==aux_distanceArray);
    
    if (length(position) > 1)
       index_pos = 1;
       while(index_pos <= length(position))
           energyArray(index) = aux_energyArray(position(index_pos));
           index_pos = index_pos + 1;
           index = index + 1;
       end
    else
        energyArray(index) = aux_energyArray(position);
        index = index + 1;
    end
end

hist(energyArray, distanceArray);
scatter(distanceArray, energyArray);