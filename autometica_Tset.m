function Tset = autometica_Tset(param)
    
    LL = param.tildeF - param.tildeG*param.tildeK;
    PHI = param.tildeA - param.tildeB*param.tildeK;

%==========================================================================
% optimproblem define M*NumOfConstr 개의 optimproblem (30)
    probT1 = optimproblem('ObjectiveSense', 'max' );
    probT2 = optimproblem('ObjectiveSense', 'max' );
    probT3 = optimproblem('ObjectiveSense', 'max' );
    probT4 = optimproblem('ObjectiveSense', 'max' );
    probT5 = optimproblem('ObjectiveSense', 'max' );
    probT6 = optimproblem('ObjectiveSense', 'max' );
    probT7 = optimproblem('ObjectiveSense', 'max' );
    probT8 = optimproblem('ObjectiveSense', 'max' );
    probT9 = optimproblem('ObjectiveSense', 'max' );
    probT10 = optimproblem('ObjectiveSense', 'max' );
    
    probT11 = optimproblem('ObjectiveSense', 'max' );
    probT12 = optimproblem('ObjectiveSense', 'max' );
    probT13 = optimproblem('ObjectiveSense', 'max' );
    probT14 = optimproblem('ObjectiveSense', 'max' );
    probT15 = optimproblem('ObjectiveSense', 'max' );
    probT16 = optimproblem('ObjectiveSense', 'max' );
    probT17 = optimproblem('ObjectiveSense', 'max' );
    probT18 = optimproblem('ObjectiveSense', 'max' );
    probT19 = optimproblem('ObjectiveSense', 'max' );
    probT20 = optimproblem('ObjectiveSense', 'max' );

    probT21 = optimproblem('ObjectiveSense', 'max' );
    probT22 = optimproblem('ObjectiveSense', 'max' );
    probT23 = optimproblem('ObjectiveSense', 'max' );
    probT24 = optimproblem('ObjectiveSense', 'max' );
    probT25 = optimproblem('ObjectiveSense', 'max' );
    probT26 = optimproblem('ObjectiveSense', 'max' );
    probT27 = optimproblem('ObjectiveSense', 'max' );
    probT28 = optimproblem('ObjectiveSense', 'max' );
    probT29 = optimproblem('ObjectiveSense', 'max' );
    probT30 = optimproblem('ObjectiveSense', 'max' );

%==========================================================================
% optimproblem setting
    z = optimvar('z', param.M*(param.nx + param.nu));

    resum1 = optimconstr(10, param.NumOfConstr*param.M);

    i=0;

    cost_function = optimexpr(param.NumOfConstr*param.M);

    while(1)
        ABC = LL*(PHI^(i+1));
        probT1.Objective = ABC(1,:)*z;
        probT2.Objective = ABC(2,:)*z;
        probT3.Objective = ABC(3,:)*z;
        probT4.Objective = ABC(4,:)*z;
        probT5.Objective = ABC(5,:)*z;
        probT6.Objective = ABC(6,:)*z;
        probT7.Objective = ABC(7,:)*z;
        probT8.Objective = ABC(8,:)*z;
        probT9.Objective = ABC(9,:)*z;
        probT10.Objective = ABC(10,:)*z;

        probT11.Objective = ABC(11,:)*z;
        probT12.Objective = ABC(12,:)*z;
        probT13.Objective = ABC(13,:)*z;
        probT14.Objective = ABC(14,:)*z;
        probT15.Objective = ABC(15,:)*z;
        probT16.Objective = ABC(16,:)*z;
        probT17.Objective = ABC(17,:)*z;
        probT18.Objective = ABC(18,:)*z;
        probT19.Objective = ABC(19,:)*z;
        probT10.Objective = ABC(20,:)*z;
        
        probT21.Objective = ABC(21,:)*z;
        probT22.Objective = ABC(22,:)*z;
        probT23.Objective = ABC(23,:)*z;
        probT24.Objective = ABC(24,:)*z;
        probT25.Objective = ABC(25,:)*z;
        probT26.Objective = ABC(26,:)*z;
        probT27.Objective = ABC(27,:)*z;
        probT28.Objective = ABC(28,:)*z;
        probT29.Objective = ABC(29,:)*z;
        probT30.Objective = ABC(30,:)*z;

        for aa = 0:i
            for bb = 1:30
                ABCD = LL*(PHI^(aa));
                resum1(aa+1,bb) = ABCD(bb,:)*z <= 1;
            end
        end
        
        probT1.Constraints.const = resum1;
        probT2.Constraints.const = resum1;
        probT3.Constraints.const = resum1;
        probT4.Constraints.const = resum1;
        probT5.Constraints.const = resum1;
        probT6.Constraints.const = resum1;
        probT7.Constraints.const = resum1;
        probT8.Constraints.const = resum1;
        probT9.Constraints.const = resum1;
        probT10.Constraints.const = resum1;

        probT11.Constraints.const = resum1;
        probT12.Constraints.const = resum1;
        probT13.Constraints.const = resum1;
        probT14.Constraints.const = resum1;
        probT15.Constraints.const = resum1;
        probT16.Constraints.const = resum1;
        probT17.Constraints.const = resum1;
        probT18.Constraints.const = resum1;
        probT19.Constraints.const = resum1;
        probT20.Constraints.const = resum1;

        probT21.Constraints.const = resum1;
        probT22.Constraints.const = resum1;
        probT23.Constraints.const = resum1;
        probT24.Constraints.const = resum1;
        probT25.Constraints.const = resum1;
        probT26.Constraints.const = resum1;
        probT27.Constraints.const = resum1;
        probT28.Constraints.const = resum1;
        probT29.Constraints.const = resum1;
        probT30.Constraints.const = resum1;

        [sol1, fval1]= solve(probT1);
        [sol2, fval2]= solve(probT2);
        [sol3, fval3]= solve(probT3);
        [sol4, fval4]= solve(probT4);
        [sol5, fval5]= solve(probT5);
        [sol6, fval6]= solve(probT6);
        [sol7, fval7]= solve(probT7);
        [sol8, fval8]= solve(probT8);
        [sol9, fval9]= solve(probT9);
        [sol10, fval10]= solve(probT10);
        
        [sol11, fval11]= solve(probT11);
        [sol12, fval12]= solve(probT12);
        [sol13, fval13]= solve(probT13);
        [sol14, fval14]= solve(probT14);
        [sol15, fval15]= solve(probT15);
        [sol16, fval16]= solve(probT16);
        [sol17, fval17]= solve(probT17);
        [sol18, fval18]= solve(probT18);
        [sol19, fval19]= solve(probT19);
        [sol20, fval20]= solve(probT20);

        
        [sol21, fval21]= solve(probT21);
        [sol22, fval22]= solve(probT22);
        [sol23, fval23]= solve(probT23);
        [sol24, fval24]= solve(probT24);
        [sol25, fval25]= solve(probT25);
        [sol26, fval26]= solve(probT26);
        [sol27, fval27]= solve(probT27);
        [sol28, fval28]= solve(probT28);
        [sol29, fval29]= solve(probT29);
        [sol30, fval30]= solve(probT30);
        result1 = [fval1, fval2, fval3, fval4, fval5, fval6, fval7, fval8, fval9, fval10];
        result2 = [fval11, fval12, fval13, fval14, fval15, fval16, fval17, fval18, fval19, fval20];
        result3 = [fval21, fval22, fval23, fval24, fval25, fval26, fval27, fval28, fval29, fval30];
        result = [result1, result2, result3];
        result = result < ones(1,30);

        aa = 1;

        SizeOfR = size(result);
        for k = 1:SizeOfR(2)
            aa = aa*result(k);
        end

        if(aa == 1)
            fprintf('i는 %d입니다', i)
            Tset = i;
            break;
        end
        i = i+1;
    end