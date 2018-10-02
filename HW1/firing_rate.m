
function[fr] = firing_rate(t, theta)
    vthresh = 20; % Consider a spike to have occured when voltage crosses this threshold (mV)
    t_thresh = 100; % Only compute firing rate using spikes occuring after this time (in ms)
    v = theta(:,1);
    tspike = t(v(1:end-1) <= vthresh & v(2:end) > vthresh);
    tspike(tspike < t_thresh) = []; % Throw away spikes occuring before t_thresh ms
    if isempty(tspike) % Handle zero firing rate
       tspike = [0 inf]; 
    end
    for ts = tspike
        vline(ts) 
    end

    fr = 1000/median(diff(tspike));
end