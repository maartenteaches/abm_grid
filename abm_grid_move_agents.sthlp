{smcl}
{* *! version 0.1.0 29Mar2019 MLB}{...}
{vieweralsosee "help abm_grid" "help abm_grid"}{...}
{vieweralsosee "help abm_grid_move_agent" "help abm_grid_move_agent"}{...}
{p2colset 1 18 20 2}{...}
{p2col:{bf:move_agents()} {hline 2}}move all agents from one location to another.
{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:void} 
{cmd:move_agents(}{it:real scalar ro}, {it:real scalar co}, 
{it:real scalar rd}, {it:real scalar cd}{cmd:)}

{p 8 12 2}
{it:void} 
{cmd:move_agents(}{it:real scalar ro}, {it:real scalar co}, 
{it:real scalar rd}, {it:real scalar cd}, {it:real scalar t}{cmd:)}

{p 8 12 2}
{it:void} 
{cmd:move_agents(}{it:real scalar ro}, {it:real scalar co}, 
{it:real scalar rd}, {it:real scalar cd}, {it:real scalar to}, 
{it:real scalar td}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:move_agents()} moves all agents from one coordinate to another coordinate. 
Moving an agent means that the {it:agent_id} is copied to the other coordinate 
and is removed from the original coordinate. The coordinate depends on how the 
grid has been set up:

{pmore}
The coordinates consists of the row ({it:ro}) and column number ({it:co}) for the
origin and the row ({it:rd}) and column number ({it:cd}) for the destination if 
{cmd:tdim} has been set to 0, or not set at all and {cmd:idim} has been set to 1
or not set at all. 

{pmore}
The coordinates consists of the row ({it:ro}), column ({it:co}), and iteration 
({it:to}) number for the origin and the row ({it:rd}), column ({it:cd}), and 
iteration ({it:td}) number for the destination if {cmd:tdim} has been set to a 
number larger than 0 and {cmd:idim} has been set to 1 or not set at all. If only
one iteration number is specified, then that iteration number will be used for
both the origin and the destination.


{title:Remarks}

{p 4 4 2}
{help abm_grid_move_agent:move_agent()} will be slightly faster if only one 
agent per cell is allowed, that is {help abm_grid_rdim:idim()} has been set to
1 or not set at all.


{marker conformability}{...}
{title:Conformability}

    {cmd:move_agents(}{it:ro}, {it:co}, {it:rd}, {it:cd}{cmd:)}:
           {it:result}:   {it:void}
           {it:ro}:        1 {it:x} 1
           {it:co}:        1 {it:x} 1
           {it:rd}:        1 {it:x} 1
           {it:cd}:        1 {it:x} 1

    {cmd:move_agents(}{it:ro}, {it:co}, {it:rd}, {it:cd}, {it:t}{cmd:)}:
           {it:result}:   {it:void}
           {it:ro}:        1 {it:x} 1
           {it:co}:        1 {it:x} 1
           {it:rd}:        1 {it:x} 1
           {it:cd}:        1 {it:x} 1
           {it:t}:         1 {it:x} 1
		   
    {cmd:move_agents(}{it:ro}, {it:co}, {it:rd}, {it:cd}, {it:to}, {it:td}{cmd:)}:
           {it:result}:   {it:void}
           {it:ro}:        1 {it:x} 1
           {it:co}:        1 {it:x} 1
           {it:rd}:        1 {it:x} 1
           {it:cd}:        1 {it:x} 1
           {it:to}:        1 {it:x} 1
           {it:td}:        1 {it:x} 1

		   
{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:move_agents()} aborts with an error if {help abm_grid_setup:setup()} has not 
been run first.

{p 4 4 2}
{cmd:move_agents()} aborts with an error if the destination already contains an 
agent.

{p 4 4 2}
{cmd:move_agents()} aborts with an error if {it:ro}, {it:rd}, {it:co} or 
{it:cd} is not an integer, or is less than or equal to 0, or is more than 
{help abm_grid_rdim:rdim}, and {help abm_grid_rdim:cdim} respectively.

{p 4 4 2}
{cmd:move_agents()} aborts with an error if {it:t}, {it:to}, or {it:td} is not an 
integer, or is less 0, or is more than {help abm_grid_rdim:tdim}.

{p 4 4 2}
{cmd:move_agents()} aborts with an error if {it:t}, {it:to}, or {it:td} has been 
specified while {help abm_grid_rdim:tdim} has been set to 0.


