function i = softmaxSel(arr, it)
%% Generate probability array
Ps = exp(arr*it);
Ps = Ps / sum(Ps);

%% Select
cPs = cumsum(Ps);
rn = rand(1);
i = find(cPs>=rn);
i = i(1);
end