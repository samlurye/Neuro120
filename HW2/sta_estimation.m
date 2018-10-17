clear all

% Load DMR stimulus specrogram and spiking responses from one neuron
load dmr_experiment

% Plot spectrogram of stimulus
plot_spectrogram(stim_spectrogram, stim_time, stim_freq)

%% Generate STA
t_past = 125; % in ms
t_future = 125; % in ms
sampling_rate = mean(median(diff(stim_time)));
sta_time = (-t_past/1000):sampling_rate:(t_future/1000);
sta_freq = stim_freq;

sta = zeros(length(sta_freq), length(sta_time) - 1);
for i = 1:length(spikes)
    temp = stim_spectrogram(:, stim_time >= spikes(i) - t_past / 1000 & stim_time <= spikes(i) + t_future / 1000);
    sta = sta + temp;
end

sta = sta / length(spikes);

% Plot results
figure(2)
plot_spectrogram(sta, sta_time, sta_freq);
xlabel('Time relative to spike (ms)')
colorbar

% get frequency with highest avg intensity in the 25 ms before spike
[val, idx] = max(mean(sta(:, 21:25), 2));
disp(sta_freq(idx));

% intensities for the above frequency before the spike
disp(sta(idx, 1:25));

figure(3);
heatmap(corrcov(cov(stim_spectrogram')));


