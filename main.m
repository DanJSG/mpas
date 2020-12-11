% % Tempo of recorded MIDI file set (just for calculations)
% midiFileTempo = 80;
% 
% % Length of crotchet beats based on MIDI file tempo
% crotchetLength = 60 / midiFileTempo;
% 
% % MAYBE MAKE THIS TUNEABLE
% % Perceptual lenience for capturing notes with roughly the same onset due
% % to polyphony - currently 12ms
% lenienceMs = 0.012; % 12ms
% lenienceRatio = lenienceMs / crotchetLength;
% 
% % Read MIDI file using MIDI toolbox
% midiMatrix = readmidi("satie_intro.mid");
% 
% % Extract the MIDI note beat onsets
% midiNoteStarts = midiMatrix(:, 1);
% 
% % Number of notes in MIDI file
% noteCount = length(midiMatrix);
% 
% % Initialise array of -1s for the number of notes in MIDI file
% noteOnsets = -1 * ones(noteCount, 1);
% 
% currOnsetIndex = 1;
% prevNoteOnset = -1;
% 
% % Loop over notes and if the onset time is different to the previous note
% % then add it to the note onset variable
% for n=1:noteCount
%     noteOnset = midiNoteStarts(n);
%     if noteOnset < prevNoteOnset - lenienceRatio || noteOnset > prevNoteOnset + lenienceRatio
%         noteOnsets(currOnsetIndex) = noteOnset;
%         currOnsetIndex = currOnsetIndex + 1;
%     end
%     prevNoteOnset = noteOnset;
% end
% 
% % Trim any trailing -1s left in the array and subtract 1 to fix beat timing
% noteOnsets = noteOnsets(1:currOnsetIndex - 1) - 1;
% 
% % Multiply note onsets by crotchet timing to get actual onset time
% noteOnsets = noteOnsets .* crotchetLength;
% 
% % Number of note onsets
% onsetCount = length(noteOnsets);

[onsets, nOnsets] = extractmidionsets("satie_intro.mid", 80);

% Initialise matrix for calculating interbeat interval differences
differences = zeros(nOnsets - 1, 1);

% 
for n=1:nOnsets - 1
    differences(n) = onsets(n + 1) - onsets(n);
end

ibi = sum(differences) / length(differences);
bpm = 60 / ibi;

