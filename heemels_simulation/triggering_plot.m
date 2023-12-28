triggering = out.triggering.Data

figure()
hold on

for t = 1:30
    if triggering(t,1) == 1
        plot(t,2,'b*')
    end
end