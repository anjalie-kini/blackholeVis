% method and calculations adapted froms schwarzschild web app cited in research bib 
function schwarzschildModel()
    function m = muprime(u)
        m = -.5*(2*u - 3*u^2);
    end    
    
    function a = limit(u,t)
        if (u(1)>1) || (u(1) < 0.0001)
            a = [0 0];
        else
            a = [u(1) muprime(u(1))];
        end
    end    

    function g = gradient(u,t)
        g = [[0 1] [1-3*u(0) 0]];
    end

    %(single init)
    function d = geod(r0, r0prime, options)
        u0 = [1/r0  -r0prime/(r0*r0)];
        
        if(strcmp(options(1), "step") == 1)
            index = strfind(options(1), "step");
            timestep = options(2, index);
        else
            timestep = .005;
        end
        
        if(strcmp(options(1), "maxangle") == 1)
            index2 = strfind(options, "maxangle");
            maxangle = options(2,index2);
        else
            maxangle = 6.28;
        end
        
        phi = linspace(0, maxangle, timestep);
        l = phi;
        u = ode45(limit, u0, l);
        d = [l u];
    end   

    %(calls geod over multiple inits)
    function o = geodqueue(sci, options)
        s = size(sci);
        temp = 1:s(2);
        out = zeroes(2, s(2));
        for i = temp
            tempSci = sci(i);
            res = geod(tempSci(2,1), tempSci(2,2), options);
            idd = tempSci(1);
            out(1,i) = idd;
            out(2,i) = res;
        end
        o = out;
    end

    %(calling initSolver and saving outputs gives raw light paths)
    function result = initSolver(sc, options)
        s2 = size(sc);
        sci = zeroes(2, s2(2));
        temp2 = 1: s2(2);
        for j = temp2
            sci(1, j) = j;
            sci(2, j) = sc(:, j);
        end
        result = geodqueue(sci, options);
    end  

end