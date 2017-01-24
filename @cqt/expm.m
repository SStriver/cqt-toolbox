function eT = expm(T, method)
nrm = norm(T,'cqt');
h = ceil(log2(nrm)) + 1;
T = T/2^h;
if ~exist('method','var')
	method = 'taylor';
end
if strcmp(method,'taylor') 
	maxit = 100;  debug = 0;
	eT = cqt(1,1,[],[],T.sz(1),T.sz(2));
	tempT = eT;
	for i=1:maxit
		tempT = tempT * T/i;
		eT = eT + tempT;
        	if norm(tempT,'cqt') < eps
        		break
        	end
	end
elseif strcmp(method,'pade')

	c = 1 / 2;
	eTn = cqt(1, 1, [], [], T.sz(1), T.sz(2)) + c*T;
	eTd = cqt(1, 1, [], [], T.sz(1), T.sz(2)) - c*T;

	q = 6;
	p = 1;
	X = T;	
	for k = 2 : q
		c = c * (q-k+1) / (k*(2*q-k+1));
		X = T * X;
   		cX = c*X;
		eTn = eTn + cX;
		if p
		     eTd = eTd + cX;
		else
		     eTd = eTd - cX;
		end
		p = ~p;
	end
	[length(eTd.n),length(eTd.p)]
	size(eTd.U)
	size(eTd.V)
	size(eTd.W)
	size(eTd.Z)
	
	eT =  eTn * inv(eTd);
else
	error('Invalid parameter method in EXPM');
end
eT = eT^(2^h);
