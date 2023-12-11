%% terminal set
function mu = Tset_CMPC(param)
    aa = (param.F_CMPC - param.G_CMPC * param.K_CMPC);
    bb = (param.A_CMPC - param.B_CMPC * param.K_CMPC);

    probT1 = optimproblem('ObjectiveSense', 'max' );
    probT2 = optimproblem('ObjectiveSense', 'max' );
    probT3 = optimproblem('ObjectiveSense', 'max' );
    probT4 = optimproblem('ObjectiveSense', 'max' );
    probT5 = optimproblem('ObjectiveSense', 'max' );
    probT6 = optimproblem('ObjectiveSense', 'max' );

    x = optimvar('x',2,'LowerBound', param.xmin ,'UpperBound', param.xmax);
    resum1 = optimconstr(30,6);
    const_xv1 =  optimconstr(15,1);
    const_xv2 =  optimconstr(15,1);
    N=0;
    while(1)
        %%입력 상태변수 바운더리
        ABC = aa*bb^(N);
        probT1.Objective = [ABC(1,:)]*x;
        probT2.Objective = [ABC(2,:)]*x;
        probT3.Objective = [ABC(3,:)]*x;
        probT4.Objective = [ABC(4,:)]*x;
        probT5.Objective = [ABC(5,:)]*x;
        probT6.Objective = [ABC(6,:)]*x;
        
        for ii = 0:N-1 
            for jj = 1: param.nc
                ABCD = aa*(bb^(ii));
                resum1(ii+1,jj) = [ABCD(jj,:)]*x <= 1;
            end
        end
        probT1.Constraints.cons1 = resum1;
        probT2.Constraints.cons1 = resum1;
        probT3.Constraints.cons1 = resum1;
        probT4.Constraints.cons1 = resum1;
        probT5.Constraints.cons1 = resum1;
        probT6.Constraints.cons1 = resum1;
        
        fval = zeros(param.nc,1);
        [sol1, fval(1)]= solve(probT1);
        [sol2, fval(2)]= solve(probT2);
        [sol3, fval(3)]= solve(probT3);
        [sol4, fval(4)]= solve(probT4);
        [sol5, fval(5)]= solve(probT5);
        [sol6, fval(6)]= solve(probT6);
        
        result = 1;
        for i=1:param.nc
            temp = (fval(i)<1);
            result = result * temp;
        end
        if(result == 1)
            fprintf('i는 %d입니다', N)
            break;
        end
        N = N+1;
    end
    mu = N;
end