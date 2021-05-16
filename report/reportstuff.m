[audio, Fs] = audioread("./Audio/DynamicRange.wav");
midiMatrix = readmidi("./Audio/DynamicRange.mid");

audio = monoconvert(audio);
audio = audio / max(abs(audio));
audio = cropsilence(audio, 2e-3);

AudioDuration = length(audio) / Fs;

MIDIRecordingBPM = 103;

[AudioGlobalBPM, AudioLocalBPMs] = getaudiobpms(audio, Fs, 4);

onsets = extractmidionsets(midiMatrix, MIDIRecordingBPM, 4);

tic
synthesizedMidi = nmat2snd(midiMatrix, 'fm', Fs)';
toc
synthesizedMidi = synthesizedMidi / max(abs(synthesizedMidi));
synthesizedMidi = cropsilence(synthesizedMidi, 2e-3);

[MIDIGlobalBPM, MIDILocalBPMs] = getaudiobpms(synthesizedMidi, Fs, 4);

MIDIGlobalBPM = MIDIGlobalBPM .* (MIDIRecordingBPM / 120);
MIDILocalBPMs = MIDILocalBPMs .* (MIDIRecordingBPM / 120);

MIDIVelocities = getlocalvelocities(midiMatrix, onsets, MIDIGlobalBPM, 4);
[MIDIDynamics, MIDIDynamicsIndices] = convertvelocitytolabels(MIDIVelocities);

MIDIDuration = (length(synthesizedMidi) / Fs) * (120 / MIDIRecordingBPM);

% Calculate the RMS values across the audio clip
audioRms = getrmsdynamics(audio, Fs, 500e-3);
% Take the average of the RMS values over each segment of audio
AudioRMSDynamics = getlocaldynamics(audioRms, length(audio), Fs, AudioGlobalBPM, 4);

% Match the audio dynamics segments to the BPM segments
AudioRMSDynamics = matchsegments(AudioRMSDynamics, length(MIDIDynamics), AudioDuration);

% Conver the RMS values to dynamics labels
[AudioDynamics, AudioDynamicsIndices] = convertrmstolabels(AudioRMSDynamics);

tDomain = linspace(0, MIDIDuration, length(MIDIDynamicsIndices));
tDomain2 = linspace(0, AudioDuration, length(AudioDynamicsIndices));
plot(tDomain, MIDIDynamicsIndices, tDomain2, AudioDynamicsIndices);
title("Dynamics Over Time");
xlabel("Time (s)");
ylabel("Dynamics");
ylim([0.5, 6.5]);
yticks([1, 2, 3, 4, 5, 6]);
yticklabels(["pp", "p", "mp", "mf", "f", "ff"]);
legend(["MIDI Dynamics", "Audio Dynamics"]);
grid on;
% nSegments = floor(length(audioLocalBPMs));
% segmentLength = floor(length(audio) / nSegments);
% 
% segmentedAudio = zeros(nSegments, segmentLength);
% for n=1:nSegments
%     
%     startSample = ((n - 1) * segmentLength) + 1;
%     endSample = startSample + segmentLength - 1;
%     
%     if endSample > length(audio)
%         endSample = length(audio);
%     end
%         
% %     segmentedAudio(n, :) = audio(startSample:endSample);
%     
%     audiowrite("./Result Gathering Files/SatieGymSegments/SatieGym" + n + ".wav", audio(startSample:endSample), Fs);
%     
% end

% Dynamics Plotting
% rms = getrmsdynamics(audio, Fs, 500e-3);
% 
% tDomain1 = linspace(0, length(audio) / Fs, length(audio));
% tDomain2 = linspace(0, length(audio) / Fs, length(rms));
% 
% plot(tDomain1, audio);
% hold on;
% plot(tDomain2, rms, 'LineWidth', 2);
% xlim([0, 25]);
% xlabel("Time (s)");
% ylabel("Amplitude");
% legend(["Audio", "RMS"]);
% hold off;