function [onsets, nOnsets] = extractmidionsets(midiMatrix, midiBpm, timeSigNumerator)
%EXTRACTMIDIONSETS Extract note onsets from a MIDI file.
%   Extracts note onsets from a MIDI file and saves them into a 1 by N
%   matrix. The onsets in this matrix are in seconds. This is returned,
%   along with the number of onsets present in the file.
    
    % Length of crotchet beats based on MIDI file tempo
    crotchetLength = (60 / midiBpm) * (timeSigNumerator / 4);
        
    % MAYBE MAKE THIS TUNEABLE
    % Perceptual lenience for capturing notes with roughly the same onset due
    % to polyphony - currently 12ms
    lenienceMs = 0.012; % 12ms
    lenienceRatio = lenienceMs / crotchetLength;
   
    % Extract the MIDI note beat onsets
    midiNoteStarts = midiMatrix(:, 1);
    
%     midiNoteStarts = midiNoteStarts - 1;

    % Number of notes in MIDI file
    noteCount = length(midiMatrix);

    % Initialise array of -1s for the number of notes in MIDI file
    onsets = -1 * ones(noteCount, 1);
    
    % Initialise onset count variable
    currOnsetIndex = 1;
    
    % Initialise previous note onset value variable
    prevNoteOnset = -1;

    % Loop over notes and if the onset time is different to the previous note
    % then add it to the note onset variable
    for n=1:noteCount
        noteOnset = midiNoteStarts(n);
        if noteOnset < prevNoteOnset - lenienceRatio ...
                || noteOnset > prevNoteOnset + lenienceRatio
            onsets(currOnsetIndex) = noteOnset;
            currOnsetIndex = currOnsetIndex + 1;
        end
        prevNoteOnset = noteOnset;
    end

    % Trim any trailing -1s left in the array and subtract 1 to fix beat timing
    onsets = onsets(1:currOnsetIndex - 1) - 1;

    % Multiply note onsets by crotchet timing to get actual onset time
    onsets = onsets .* crotchetLength;

    % Number of note onsets
    nOnsets = length(onsets);

end

