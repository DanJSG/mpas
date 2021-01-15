%CONVERTVELOCITYTOLABELS Function to convert MIDI velocity values to
%                        dynamics labels ranging from pp to ff.
% Maps MIDI velocities according to the following mapping:
%        Velocity <  36 = "pp"
%   35 < Velocity <  48 = "p"
%   47 < Velocity <  64 = "mp"
%   63 < Velocity <  83 = "mf"
%   82 < Velocity <  97 = "f"
%   96 < Velocity < 111 = "ff"
% Input arguments:
%   velocities - the MIDI velocities to map to dynamics
function[labels, dynamicLabelIndices] = convertvelocitytolabels(velocities)
   
    % Sets the velocity range values and the dynamics labels
    velocityRanges = [36, 48, 64, 83, 97, 111];
    dynamicLabels = ["pp", "p", "mp", "mf", "f", "ff"]';
    
    % Initialises variable for the indices of the dynamics labels
    dynamicLabelIndices = zeros(length(velocities), 1);
    
    % Loops over each MIDI velocity
    for n=1:length(velocities)
       
        % Gets the current velocity
        currentVelocity = velocities(n);
        
        % Initialises index for dynamics label to -1 for error checking
        dynamicLabelIndex = -1;
        
        % Loop through the velocity ranges
        for m=1:length(velocityRanges) - 1
            
            % Check if the current velocity falls within the current
            % velocity ranges
            if currentVelocity >= velocityRanges(m) && currentVelocity < velocityRanges(m + 1)
                % If it does store the index and break out of the for loop
                dynamicLabelIndex = m;
                break;
            end
            
            % If the current velocity is less than the bottom range, set
            % the index to 1
            if currentVelocity < velocityRanges(1)
                dynamicLabelIndex = 1;
            % If the current velocity is greater than the top range, set
            % the index to the last dynamic
            elseif currentVelocity > velocityRanges(end)
                dynamicLabelIndex = length(velocityRanges);
            end
            
        end
        
        % Update the indices list with the current dynamic index
        dynamicLabelIndices(n) = dynamicLabelIndex;
        
    end

    % Extract the dynamic labels based on the extracted indices
    labels = dynamicLabels(dynamicLabelIndices);
    
end
