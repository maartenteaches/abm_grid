clear all
cd h:\abm\abm_grid

do abm_grid.mata

mata
foo = abm_grid()
foo.rdim(10)
foo.cdim(10)
foo.torus(1)
foo.setup()

foo.dist((2,3), (7,5), "man")
line = foo.find_line((2,3), (7,5), "ortho")
res = J(foo.rdim(),foo.cdim(),0)
for(i=1; i <= rows(line); i++) {
	res[line[i,1], line[i,2]] = 1
}
res
end