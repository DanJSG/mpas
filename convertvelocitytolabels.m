function[labels, dynamicLabelIndices] = convertvelocitytolabels(velocities)
   
    velocityRanges = [36, 48, 64, 83, 97, 111];
    dynamicLabels = ["pp", "p", "mp", "mf", "f", "ff"]';
    
    dynamicLabelIndices = zeros(length(velocities), 1);
    
    for n=1:length(velocities)
       
        currentVelocity = velocities(n);
        
        dynamicLabelIndex = -1;
        
        for m=1:length(velocityRanges) - 1
           
            if currentVelocity >= velocityRanges(m) && currentVelocity < velocityRanges(m + 1)
                dynamicLabelIndex = m;
                break;
            end
            
            if currentVelocity < velocityRanges(1)
                dynamicLabelIndex = 1;
            elseif currentVelocity > velocityRanges(end)
                dynamicLabelIndex = length(velocityRanges);
            end
            
        end
        
        dynamicLabelIndices(n) = dynamicLabelIndex;
        
    end
       
    labels = dynamicLabels(dynamicLabelIndices);
    
end