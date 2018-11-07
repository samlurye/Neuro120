clear all

load exposure_stimulus_experiment.mat

stimulus_start_times = 0:1/6:(60-1/6); % In seconds
clear all

load exposure_stimulus_experiment.mat

stimulus_start_times = 0:1/6:(60-1/6); % In seconds
stim_assignments = discretize(spikes_single_unit, 0:1/6:60);
responses = [];
for i = 1:360
    temp = transpose(spikes_single_unit(stim_assignments == i));
    responses(i, 1:length(temp)) = temp - stimulus_start_times(i);
end

% never used matlab before this class so had to consult
% http://www.neural-code.com/index.php/tutorials/brain/spike/59-spike-raster-plot
% for how to make a raster plot

for i = 1:length(responses)
    for j = 1:length(responses(i, :))
        if responses(i, j) ~= 0
            line([responses(i, j) responses(i, j)], [i - 1 i + 1], 'Color', 'k', 'LineWidth', 4);
        end
    end
end

figure();

gauss = @(dt, sigma) 1 / sqrt(2 * pi * sigma ^ 2) * exp(-(dt .^ 2) / (2 * sigma ^ 2));

avg_firing_rates = zeros(3, length(0:0.001:1/6));
sigmas = [0.005 0.05 0.0005];
spikes = reshape(responses, 1, []);
spikes = spikes(spikes ~= 0);
for j = 1:length(sigmas)
    avg_firing_rates(j, :) = avg_firing_rates(j, :) + firing_rates(spikes, gauss, sigmas(j));
end

avg_firing_rates = avg_firing_rates / 360;

subplot(311);
plot(0:0.001:1/6, avg_firing_rates(1, :));
xlabel("Time (s)");
ylabel("Firing Rate (Hz, \sigma=5ms)");
subplot(312);
plot(0:0.001:1/6, avg_firing_rates(2, :));
xlabel("Time (s)");
ylabel("Firing Rate (Hz, \sigma=50ms)");
subplot(313);
plot(0:0.001:1/6, avg_firing_rates(3, :));
xlabel("Time (s)");
ylabel("Firing Rate (Hz, \sigma=0.5ms)");

spike_times = spikes_exp;
bin_width = 0.005;
bin_times = 0:bin_width:1/6;
stim_assignments = discretize(spike_times, 0:1/6:60);
dts = zeros(1, length(spike_times));
idx = 1;
for i = 1:360
    temp = transpose(spike_times(stim_assignments == i)) - stimulus_start_times(i);
    dts(idx:idx + length(temp) - 1) = temp;
    idx = idx + length(temp);
end

bins = histcounts(dts, bin_times);

if length(spike_times) == length(spikes_exp)
    bins = bins / (bin_width * 360 * N_exp);
else
    bins = bins / (bin_width * 360 * N_control);
end

figure();
h = histogram('BinEdges', bin_times, 'BinCounts', bins, 'DisplayStyle', 'stairs');
xlabel("Time (s)");
ylabel("Frequency (Hz)");

function y = firing_rates(spikes, gauss, sigma)

ts = 0:0.001:1/6;
y = zeros(1, length(ts));
for i = 1:length(spikes)
    y = y + gauss(ts - spikes(i), sigma);
end

end
