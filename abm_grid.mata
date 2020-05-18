local id = 1

mata :
mata set matastrict on

class abm_grid
{
	protected:
		class AssociativeArray scalar universe 
		class AssociativeArray scalar baserings
		
		real scalar    rdim
		real scalar    cdim
		real scalar    tdim
		real scalar    idim
		real scalar    neumann
		real scalar    torus
		real scalar    randit 
		real matrix    basecoords 
		real scalar    size	
		real scalar    setup
		
		void           is_posint()
		void           is_bool()
		void           is_setup()
		void           baserings()
		real matrix    basering()
		real matrix    neumannring()
		real matrix    moorering()
		real colvector out_of_bounds()
		real matrix    torus_adj()
		void           basecoords() 
		real rowvector make_key()
		void           new()
		real rowvector agent_loc()
		real matrix    comp_line()
		real matrix    torus_closest()
		real rowvector lerp()		
		
	
	public:
		transmorphic   rdim()
		transmorphic   cdim()
		transmorphic   tdim()
		transmorphic   idim()
		real scalar    size()
		transmorphic   neumann()
		transmorphic   torus()
		transmorphic   randit() 
		void           setup()
		real matrix    find_ring()
		real matrix    find_spiral()
		real scalar    agent_id() 
		real rowvector agent_ids()
		real scalar    free_spot()
		real scalar    has_agent()
		void           copy_agent()  
		void           copy_agents() 
		void           copy_grid()
		void           move_agent()
		void           move_agents()
		void           delete_agent() 
		void           delete_agents()
		void           create_agent()
		real matrix    schedule() 
		real rowvector random_cell() 
		real scalar    dist()
		real matrix    find_line()
		real matrix    extract()
		
}

// -------------------------------------------------------------- error messages

void abm_grid::is_bool(real scalar val, string scalar name)
{
	string scalar errmsg
	
	if (val != 1 & val != 0) {
		errmsg = name + " can only be 0 or 1"
		_error(3300, errmsg)
	}
}

void abm_grid::is_posint(real scalar val, string scalar name, | string scalar zero_ok) 
{
	string scalar errmsg
	
	if (args() == 2) {
		if (val <= 0 | mod(val,1)!= 0 ){
			errmsg = name + " must be a positive integer"
			_error(3300, errmsg)
		}
	}
	else {
		if (val < 0 | mod(val,1)!= 0 ){
			errmsg = name + " must be zero or a positive integer"
			_error(3300, errmsg)
		}
	}
}

void abm_grid::is_setup() 
{
	if (setup == 0) {
		_error(3000, "running setup() before this function is required")
	}
}

// ------------------------------------------------------- set / return settings
transmorphic abm_grid::neumann(| real scalar newval) 
{
	if (args() == 1) {
		is_bool(newval,"newval")
		neumann = newval
		setup = 0
	}
	else {
		return(neumann)
	}
}

transmorphic abm_grid::torus(| real scalar newval) 
{
	if (args() == 1) {
		is_bool(newval,"newval")
		torus = newval
		setup = 0
	}
	else {
		return(torus)
	}
}

transmorphic abm_grid::randit(| real scalar newval) 
{
	if (args() == 1) {
		is_bool(newval,"newval")
		randit = newval
		setup = 0
	}
	else {
		return(randit)
	}
}

transmorphic abm_grid::idim(| real scalar dim) 
{
	if (args() == 1) {
		is_posint(dim, "dim", "zero_ok")
		idim = dim
		setup = 0
	}
	else {
		return(idim)
	}
}
transmorphic abm_grid::tdim(| real scalar dim) 
{
	if (args() == 1) {
		is_posint(dim, "dim", "zero_ok")
		tdim = dim
		setup = 0
	}
	else {
		return(tdim)
	}
}
transmorphic abm_grid::rdim(| real scalar dim) 
{
	if (args() == 1) {
		is_posint(dim, "dim")
		rdim = dim
		setup = 0
	}
	else {
		return(rdim)
	}
}
transmorphic abm_grid::cdim(| real scalar dim)
{
	if (args() == 1) {
		is_posint(dim, "dim")		
		cdim = dim
		setup = 0
	}
	else {
		return(cdim)
	}
}

real scalar abm_grid::size()
{
	is_setup() 

	return(size)
}

// --------------------------------------------------------------- neighbourhood
real matrix abm_grid::neumannring(real scalar radius) 
{
	real matrix basering
	real rowvector pos, change
	
	pos = (radius, 0)
	basering = pos
	change = (-1,1)
	while (pos[1] != 0) {
		pos = pos + change
		basering = basering \ pos
	}
	change = (-1,-1)
	while (pos[2] != 0) {
		pos = pos + change
		basering = basering \ pos
	}
	change = (1,-1)
	while (pos[1] != 0) {
		pos = pos + change
		basering = basering \ pos
	}
	change = (1,1)
	while (pos[2] != -1) {
		pos = pos + change
		basering = basering \ pos
	}
	return(basering)
}

real matrix abm_grid::moorering(real scalar radius)
{
	real matrix basering
	real rowvector pos, change
	
	pos = (radius, radius)
	basering = pos
	change = (-1,0)
	while (pos[1] != -radius) {
		pos = pos + change
		basering = basering \ pos
	}
	change = (0,-1)
	while (pos[2] != -radius) {
		pos = pos + change
		basering = basering \ pos
	}
	change = (1,0)
	while (pos[1] != radius) {
		pos = pos + change
		basering = basering \ pos
	}
	change = (0,1)
	while (pos[2] != radius-1) {
		pos = pos + change
		basering = basering \ pos
	}
	return(basering)
}

void abm_grid::baserings() 
{
	real scalar radius
	real matrix basering
	
	baserings.reinit("real")
	
	
	if (neumann == 0) { 
		for(radius = 1; radius <= max((rdim,cdim)); radius++) {
			basering = moorering(radius)
			baserings.put(radius, basering)
		}
	}
	else { 
		for(radius = 1; radius <= max((rdim,cdim)); radius++) {
			basering = neumannring(radius)
			baserings.put(radius, basering)
		}
	}
}

real matrix abm_grid::basering(real scalar radius) 
{
	is_setup()
	
	if ( radius > max((rdim,cdim)) ) {
	 _error(3300, "radius must be less than or equal to max(rdim,cdim)")
	}
	
	return(baserings.get(radius))
}

real matrix abm_grid::torus_adj(real matrix pos)
{
	is_setup() 
	if (any(mod(pos,1))) {
		_error("pos must contain integers")
	}
	if (cols(pos)!= 2) {
		_error("pos must contain two columns")
	}
	if (torus==0 & any(out_of_bounds(pos))) {
		_error("coordinates in pos are out of bounds")
	}
	return( mod( (pos:-1) , (rdim,cdim) ) :+ 1 )
}

real colvector abm_grid::out_of_bounds(real matrix pos) 
{
	is_setup() 
	if (any(mod(pos,1))) {
		_error("pos must contain integers")
	}
	if (cols(pos)!= 2) {
		_error("pos must contain two columns")
	}
	return(rowsum(pos :<= 0) :| rowsum(pos:>(rdim,cdim)))
}

real matrix abm_grid::find_ring(real scalar r, real scalar c, 
                                real scalar radius)
{
	real matrix res, base
	real scalar i
	real rowvector neigh_pos, pos
	
	is_setup() 
	
	pos = r, c
	
	res = J(0,2,.)

	base = basering(radius)

	for(i=1; i<= rows(base) ; i++) {
		neigh_pos = base[i,.] :+ pos
		if (torus) {
			neigh_pos = torus_adj(neigh_pos)
		}
		else if ( out_of_bounds(neigh_pos) ) {
			continue
		}
		res = res \ neigh_pos
	}
	return(res)	
}

real matrix abm_grid::find_spiral(real scalar r, real scalar c, real scalar radius)
{
	real matrix res
	real scalar i
	
	is_setup() 
	
	res = J(0,2,.)
	for(i = 1 ; i <= radius ; i++) {
		res = res \ find_ring(r,c,i)
	}
	return(res)
}

// ----------------------------------------------- relationship between 2 points

real rowvector abm_grid::lerp(real rowvector orig, real rowvector dest, real scalar t)
{
	is_setup()
	if (any(mod((orig,dest),1))) {
		_error("orig and dest must contain integers")
	}
	if (torus == 0 & (out_of_bounds(orig) | out_of_bounds(dest))) {
		_error("orig and/or dest contain coordinates outside the grid")
	}	
	
	return(round(orig :+ t:*(dest:-orig)))
}

real matrix abm_grid::torus_closest(real rowvector orig, real rowvector dest)
{
	real rowvector dist
	
	is_setup()
	if (any(mod((orig,dest),1))) {
		_error("orig and dest must contain integers")
	}
	if (torus == 0 & (out_of_bounds(orig) | out_of_bounds(dest))) {
		_error("orig and/or dest contain coordinates outside the grid")
	}	
	
	if (torus== 1) {
		dist = abs(dest:-orig)
		if (dist[1] > .5*cdim) {
			if (orig[1] < dest[1]) {
				orig[1] = orig[1] + cdim
			}
			else {
				dest[1] = dest[1] + cdim
			}
		}
		if (dist[2] > .5*rdim) {
			if (orig[2] < dest[2]) {
				orig[2] = orig[2] + rdim
			}
			else {
				dest[2] = dest[2] + rdim
			}
		}		
	}
	return(orig\dest)
}

real scalar abm_grid::dist(real rowvector orig, real rowvector dest, | string scalar what)
{
	real rowvector dist
	string scalar errmsg
	real matrix points

	is_setup()
	if (any(mod((orig,dest),1))) {
		_error("orig and dest must contain integers")
	}
	if (torus == 0 & (out_of_bounds(orig) | out_of_bounds(dest))) {
		_error("orig and/or dest contain coordinates outside the grid")
	}	
	
	points = torus_closest(orig, dest)
	orig = points[1,.]
	dest = points[2,.]
	dist = abs(dest :- orig)
	
	if ( (args()==2 & neumann == 0) | usubstr(what,1, 4) == "cheb" ) {
		return(max(dist))
	}
	else if ((args() == 2 & neumann == 1)| usubstr(what,1,3) == "man" ) {
		return(sum(dist))
	}
	else if (usubstr(what,1,4) == "eucl"){
		return(sqrt(sum(dist:^2)))
	}
	else {
		errmsg = "what can contain either chebyshev, manhattan, or eucledian"
		_error(errmsg)
	}
}

real matrix abm_grid::comp_line(real rowvector orig, real rowvector dest, string scalar what)
{
	string scalar    dist_type
	real   scalar    n, i, t, sign_x, sign_y, ix, iy
	real   rowvector dist
	real   matrix    res
	
	dist_type = (what == "inter" ? "chebyshev" : "manhattan")
	n = dist(orig, dest, dist_type)
	res = J(n+1,2,.)

	if (what == "ortho") {
		dist = dest :- orig
		sign_x = (dist[2]>=0 ? 1: -1)
		sign_y = (dist[1]>=0 ? 1: -1)
		dist = abs(dist)
		res[1, .] = orig
		
		ix = iy = 0
		
		for (i=1; i <= n ; i++) {
			res[i+1,.] = res[i,.]
			if ((0.5+ix) / dist[2] < (0.5+iy) / dist[1]) {
				res[i+1,2] = res[i+1,2] + sign_x
				ix = ix + 1
			}
			else {
				res[i+1,1] = res[i+1,1] + sign_y
				iy = iy + 1			
			}
		}
	}
	else {
		for(i=0 ; i <= n ; i++) {
			t = (i==0 ? 0 : i/n)
			res[i+1,.] = lerp(orig, dest, t)
		}
	}
	return(res)
}

real matrix abm_grid::find_line(real rowvector orig, real rowvector dest,| string scalar what)
{
	string scalar    errmsg
	real   matrix    res, points

	is_setup()
	if (any(mod((orig,dest),1))) {
		_error("orig and dest must contain integers")
	}
	if (torus == 0 & (out_of_bounds(orig) | out_of_bounds(dest))) {
		_error("orig and/or dest contain coordinates outside the grid")
	}
	
	if (args()<3) {
		if (neumann == 0) {
			what = "inter"
		}
		else {
			what = "ortho"
		}
	}
	else {
		what = usubstr(what,1,5)
	}
	
	if (what != "inter" & what != "ortho") {
		errmsg = "what can contain either interpolate or orthogonal"
		_error(errmsg)
	}

	points = torus_closest(orig, dest)
	orig = points[1,.]
	dest = points[2,.]
	
	res = single_line(orig, dest, what)

	return(torus_adj(res))
}

// ------------------------------------------------------------------ scheduling
void abm_grid::basecoords()
{	
	real scalar k, r, c
	
	basecoords =J(rdim*cdim,2,.)

	k=1
	for(r=1; r<=rdim; r++) {
		for(c=1 ; c<=cdim; c++) {
			basecoords[k,.] = r, c
			k = k + 1
		}
	}
}

real rowvector abm_grid::random_cell(real scalar k) {
	is_setup() 
	
	return(ceil(runiform(k,2):*(rdim,cdim)))
}

real matrix abm_grid::schedule()
{
	is_setup() 
	
	if (randit) {
		_jumble(basecoords)
	}
	return(basecoords)
}

// ---------------------------------------------------------------------- agents

real rowvector abm_grid::make_key(real scalar r, real scalar c, real scalar t, real scalar i)
{
	string scalar errmsg

	is_setup() 
	
	if (r <= 0 | r > rdim | mod(r,1) != 0 ) {
		errmsg = "r must be an integer larger than 0, less than or equal to " + 
		          strofreal(rdim)
		_error(3300, errmsg)
	}
	if (c <= 0 | c > cdim | mod(c,1) != 0 ) {
		errmsg = "c must be an integer larger than 0, less than or equal to " + 
		          strofreal(cdim)
		_error(3300, errmsg)
	}	
	if (idim == 1 ) {
		if (i != . & i != 1 & i != 0) {
			_error(3001, "you specified i, but set idim to 1")
		}
		else if ( i != 0 ) {
			i = 1
		}
	}
	else {
		if (i < 0 | (i > idim & idim != 0) | mod(i,1) != 0 ) {
			errmsg = "i must be an integer larger than or equal 0" + 
			( idim == 0 ?  "" : "and less than or equal to " + strofreal(idim)) 
			_error(3300, errmsg)
		}
	}
	if (tdim == 0 ) {
		if (t != . & t != 0) {
			_error(3001, "you specified t, but set tdim to 0")
		}
		else {
			t = 0
		}
	}
	else {
		if (t < 0 | t > tdim | mod(t,1) != 0 ) {
			errmsg = "t must be an integer larger than or equal to 0, less than or equal to " + 
					strofreal(tdim)
			_error(3300, errmsg)
		}	
	}
	return((r,c,t,i))
}

void abm_grid::create_agent(real scalar r, real scalar c , 
                          real scalar agent_id, | real scalar t, real scalar i )
{
	real rowvector key
	
	is_setup() 
	
	if (i == 0) {
		_error(3000, "location 0 is reserved")
	}
	key = make_key(r, c, t, i)
	universe.put(key,agent_id)
	
	key = make_key(r,c,t,0)
	universe.put(key,(universe.get(key), i))
}

real scalar abm_grid::free_spot(real scalar r, real scalar c, real scalar t)
{
	real rowvector key, taken
	real scalar    attempt , done
	
	is_setup()
	
	key = make_key(r,c,t,0)
	taken = universe.get(key)
	
	done = 0
	attempt = length(taken) 
	while (!done) {
		attempt = attempt + 1
		if (!anyof(taken,attempt)) done = 1
	}
	return(attempt)
}

real scalar abm_grid::agent_id( real scalar r, real scalar c , | real scalar t, 
                                real scalar i)
{
	real rowvector key
	
	is_setup() 
	
	if (i == 0) {
		_error(3000, "location 0 is reserved")
	}
	
	key = make_key(r, c, t, i)
	return(universe.get(key))
}

real rowvector abm_grid::agent_ids( real scalar r, real scalar c , | real scalar t)
{
	real rowvector key, loc, res
	real scalar i
	
	is_setup() 
	
	loc = agent_loc(r,c,t)
	res = J(1,cols(loc),.)
	for (i = 1 ; i <= cols(loc); i++) {
		key = make_key(r,c,t,loc[i])
		res[i] = universe.get(key)
	}
	return(res)
}

real rowvector abm_grid::agent_loc(real scalar r, real scalar c, real scalar t)
{
	real rowvector key
	
	key = make_key(r, c, t, 0)
	
	return(universe.get(key))
}

real scalar abm_grid::has_agent(real scalar r, real scalar c, | real scalar t)
{
	real rowvector key
	
	is_setup() 
		
	key = make_key(r, c, t, 0)
	
	return(universe.exists(key))
}


void abm_grid::delete_agent(real scalar r, real scalar c, | real scalar t, 
                            real scalar i)
{
	real rowvector key, key_loc, loc
	
	is_setup() 
	
	if (i == 0) {
		_error(3000, "location 0 is reserved")
	}
	
	key = make_key(r, c, t, i)
	
	if (universe.exists(key) == 0) {
		_error(3499, "no agent in cell")
	}

	loc = agent_loc(r,c,t)
	if (!anyof(loc,i)) {
		_error(3499, "location not found in i = 0")
	}
	universe.remove(key)
	loc =  select(loc,loc :!= i)
	
	key_loc = make_key(r,c,t,0)
	if (cols(loc) == 0) {
		universe.remove(key_loc)
	}
	else {
		universe.put(key_loc,loc)
	}
}

void abm_grid::delete_agents(real scalar r, real scalar c, 
                            | real scalar t)
{

	real rowvector locs
	real scalar    i
	
	locs = agent_loc(r, c, t)
	for (i = 1 ; i <= cols(locs); i++) {
		delete_agent(r, c, t, locs[i])
	}

}

void abm_grid::copy_agent(
                   real scalar ro, real scalar co ,
                   real scalar rd, real scalar cd, 
				   | real scalar to, real scalar td,
				   real scalar io, real scalar id)
{
	real rowvector keyo, keyd, toreplace, locs
	
	is_setup() 
	
	if (to != . & td == .) {
		td = to
	}
	if (io != . & id == .) {
		id = io
	}
	
	if (io == 0 | id == 0) {
		_error(3000, "location 0 is reserved")
	}
	
	keyo = make_key(ro,co,to,io)
	keyd = make_key(rd,cd,td,id)
	
	locs =  agent_loc(rd,cd,td)
	if (anyof(locs,id)) {
		_error(3000, "location " + strofreal(id) + " already populated")
	}
	
	toreplace = universe.get(keyo)
	
	universe.put(keyd, toreplace)
	
	keyd = make_key(rd,cd,td,0)
	universe.put(keyd, (locs, id))
}

void abm_grid::copy_agents(real scalar ro, real scalar co, 
                           real scalar rd, real scalar cd,
						   | real scalar to, real scalar td)
{

	real rowvector locs
	real scalar i
	
	locs = agent_loc(ro, co, to)
	for (i = 1 ; i <= cols(locs); i++) {
		copy_agent(ro, co, rd, cd, to, td, locs[i],locs[i])
	}

}


void abm_grid::copy_grid(real scalar to, real scalar td) 
{
	real scalar r, c
	
	is_setup() 
	
	for(r=1 ; r<=rdim ; r++) {
		for (c=1; c<=cdim ; c++) {
			if (has_agent(r,c, to)) {
				copy_agents(r,c, r,c, to, td)
			}
		}
	}
}

void abm_grid::move_agent(
                   real scalar ro, real scalar co,
                   real scalar rd, real scalar cd, 
				   | real scalar to, real scalar td,
				   real scalar io, real scalar id)
{
	is_setup() 

	copy_agent(ro, co, rd, cd, to, td, io, id)
	delete_agent(ro,co, to, io)
}

void abm_grid::move_agents(
                   real scalar ro, real scalar co,
                   real scalar rd, real scalar cd, 
				   | real scalar to, real scalar td)
{
	is_setup() 

	copy_agents(ro, co, rd, cd, to, td)
	delete_agents(ro,co, to)
}

// ----------------------------------------------------------------------- setup
void abm_grid::setup()
{
	if (cdim==.) {
		_error(3351, "cdim() must be specified first")
	}
	if (rdim==.) {
		_error(3351, "rdim() must be specified first")
	}
	if (tdim==.) {
		tdim = 0
	}
	if (idim==.) {
		idim = 1
	}
	if (neumann==.) {
		neumann = 0
	}
	if (torus==.) {
		torus = 0
	}
	if (randit==.) {
		randit = 0
	}
	baserings()
	basecoords()
	universe.reinit("real", 4)
	universe.notfound(J(1,0,.))
	size = rdim*cdim
	setup = 1
}

void abm_grid::new()
{
	setup = 0
}

// ---------------------------------------------------------------------- export
real matrix abm_grid::extract()
{

	real matrix res
	real scalar i
	
	is_setup() 
	
	res = universe.keys()
	res = select(res, res[.,4]:!=0)
	res = sort(res,(1,2,3,4))
	res = res, J(rows(res),1,.)
	for(i = 1; i <= rows(res); i++){
		res[i,5] = universe.get(res[i,1..4]) 
	}
	return(res)
	
}

end
