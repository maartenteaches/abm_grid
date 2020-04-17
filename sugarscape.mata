clear all

cd "c:\mijn documenten\projecten\stata\abm\"
run abm_grid\abm_grid.mata

mata

class grid extends abm_grid
{
    
}

class sugarscape 
{
	private:
		class grid scalar universe
		class AssociativeArray scalar agents
		class AssociativeArray scalar cells

		void landscape()
		
	public:
		transmorphic rdim()
		transmorphic cdim()
		transmorphic tdim()
		
		transmorphic Nagents()
		transmorphic wealth0()
		transmorphic metabolic()
		transmorphic vision()
		transmorphic maxage()
		
		transmorphic npeaks()
		transmorphic nrich()
		transmorphic gradient()
		transmorphic regrowth()

}


void sugarscape::landscape(){
	
}	
end
