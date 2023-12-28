A = [1 -1; 1 1];
B = [0.05; 0.1];
nx = size(A,1);
nu = size(B,2);
C = eye(nx);


M = 4 ;
AT = [A zeros(nx, nu); zeros(nu,nx) zeros(nu, nu)];
ANT = [A B; zeros(nu, nx) eye(nu)];
BT = [B;eye(nu)];
tildeA =[];
tildeB =[];
tildeC =[];
for i = 1:M
    tildeA = [tildeA; [zeros((nx + nu),(nx + nu)*(M-1)) ANT^(i-1)*AT]];
    tildeB = [tildeB; ANT^(i-1)*BT];
    tildeC = blkdiag(tildeC, eye(nx+nu));
end

stack_sys = ss(tildeA, tildeB, tildeC, zeros(size(tildeA,1), size(tildeB,2)),5);
[G1 G2] = stabsep(stack_sys);
eig(G1.A)
size(ctrb(G2.A, G2.B))
rank(ctrb(G2.A, G2.B))