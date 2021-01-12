[audio, Fs] = audioread("./audio/dynamics-analysis/combined.wav");

audio = monoconvert(audio);
audio = audio / max(abs(audio));

rmsDynamics = getrmsdynamics(audio, Fs, 50e-3);
% rmsDynamics = rmsDynamics / max(abs(rmsDynamics));

[pks, pkLocs] = findpeaks(rmsDynamics, 'NPeaks', 8);

tDomain1 = linspace(0, length(audio) / Fs, length(audio));
tDomain2 = linspace(0, length(audio) / Fs, length(rmsDynamics));
% plot(tDomain1, audio, tDomain2, rmsDynamics);
plot(tDomain2, rmsDynamics);
hold on;
plot(tDomain2(pkLocs), pks, 'x');
hold off;