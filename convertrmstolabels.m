function[dynamics] = convertrmstolabels(rmsDynamics)
    
    rmsDynamicRanges = [0.0549, 0.0718, 0.1026, 0.1524, 0.2184, 0.2997];
    dynamicLabels = ["pp", "p", "mp", "mf", "f", "ff"]';
    
    dynamicLabelIndices = zeros(length(rmsDynamics), 1);
    for n=1:length(rmsDynamics)

        currentRmsValue = rmsDynamics(n);

        dynamicLabelIndex = -1;

        for m=1:length(rmsDynamicRanges) -  1

            if currentRmsValue >= rmsDynamicRanges(m) && currentRmsValue < rmsDynamicRanges(m + 1)
                dynamicLabelIndex = m;
                break;
            end

            if currentRmsValue < rmsDynamicRanges(1)
                dynamicLabelIndex = 1;
            elseif currentRmsValue > rmsDynamicRanges(end)
                dynamicLabelIndex = length(rmsDynamicRanges);
            end

        end

        dynamicLabelIndices(n) = dynamicLabelIndex;

    end
    
    dynamics = dynamicLabels(dynamicLabelIndices);
    
end