function Tset = Tset_d(param)
%% terminal set
A = param.A;
B = param.B;
C = param.C;
Q = param.Q;
R = param.R;
F = param.F;
G = param.G;
[P K L] = idare(A,B,Q,R);
probT1 = optimproblem('ObjectiveSense', 'max' );
probT2 = optimproblem('ObjectiveSense', 'max' );
probT3 = optimproblem('ObjectiveSense', 'max' );
probT4 = optimproblem('ObjectiveSense', 'max' );
probT5 = optimproblem('ObjectiveSense', 'max' );
probT6 = optimproblem('ObjectiveSense', 'max' );

LL = F - G*K;
PHI = A-B*K;
x = optimvar('x',2);
resum1 = optimconstr(30,6);
N=0;
while(1)
    %%입력 상태변수 바운더리
     ABC = LL*(PHI^(N+1));
     probT1.Objective = [ABC(1,1), ABC(1,2)]*x;
     probT2.Objective = [ABC(2,1), ABC(2,2)]*x;
     probT3.Objective = [ABC(3,1), ABC(3,2)]*x;
     probT4.Objective = [ABC(4,1), ABC(4,2)]*x;
     probT5.Objective = [ABC(5,1), ABC(5,2)]*x;
     probT6.Objective = [ABC(6,1), ABC(6,2)]*x;
     
    for aa = 0:N 
        for bb = 1:6
            ABCD = LL*(PHI^(aa));
            resum1(aa+1,bb) = [ABCD(bb,1), ABCD(bb,2)]*x <= 1;
        end
    end
    probT1.Constraints.cons1 = resum1;
    probT2.Constraints.cons1 = resum1;
    probT3.Constraints.cons1 = resum1;
    probT4.Constraints.cons1 = resum1;
    probT5.Constraints.cons1 = resum1;
    probT6.Constraints.cons1 = resum1;
    
    [sol1, fval1]= solve(probT1);
    [sol2, fval2]= solve(probT2);
    [sol3, fval3]= solve(probT3);
    [sol4, fval4]= solve(probT4);
    [sol5, fval5]= solve(probT5);
    [sol6, fval6]= solve(probT6);
    result1 = [fval1, fval2, fval3, fval4, fval5, fval6];
    
    aaaaa = [result1<=[1 1 1 1 1 1]];
    aaa = 1;
    for i = 1:6
        aaa = aaa * aaaaa(i);
    end

    if(aaa == 1)
        fprintf('i는 %d입니다', N)
        Tset = N;
        break;
    end
    N = N+1;
end
end

