x1 = -8:0.3:8;
x2 = -8:0.3:8;
[X1, X2]= meshgrid(x1, x2);
sizeOfMesh = size(X1);
cond = zeros(sizeOfMesh(1), sizeOfMesh(2));
for i = 1: sizeOfMesh(1)
    for j = 1: sizeOfMesh(2)
        x0 = [X1(i,j);X2(i,j)]
        result = mmpc_feasible(x0);
        if result == 1
            cond(i,j) =1;
        end
    end
end
contour(X1 ,X2, cond,[1 1],'c')