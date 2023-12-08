F1 = openfig('State.fig');
L1 = findobj(gca,'Type','line');
for k = 1:numel(L1)
    X1(k) = L1(k).XData;
    Y1(k) = L1(k).YData;
    C1{k} = L1(k).Color;
    M1{k} = L1(k).Marker;
end
F2 = openfig('State_heemels.fig');
L2 = findobj(gca,'Type','line');
for k = 1:numel(L2)
    X2(k) = L2(k).XData;
    Y2(k) = L2(k).YData;
    C2{k} = L2(k).Color;
    M2{k} = L2(k).Marker;
end
figure
hold on
for k = 1:numel(L1)
    plot(X1(k), Y1(k), 'Color',C1{k}, 'Marker',M1{k})
end
for k = 1:numel(L2)
    plot(X2(k), Y2(k), 'Color',C2{k}, 'Marker',M2{k})
end
hold off
xlabel('Time')
ylabel('Out_1')
title('Combined')
axl = axis;
axis([-100  axl(2)    -1E-11  axl(4)])
Pos = get(gcf,'Position')
set(gcf,'Position',Pos+[0 0 750 250])