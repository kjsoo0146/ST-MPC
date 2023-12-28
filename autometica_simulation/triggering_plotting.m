

for i = 1:30
    trg = find(triggering_time==i)
    if isempty(trg) == 0
        plot(i,1,'r*')
    end
end