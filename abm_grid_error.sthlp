{smcl}
{* *! version 0.1.0 29Mar2019 MLB}{...}
{vieweralsosee "help abm_grid" "help abm_grid"}{...}
{vieweralsosee "help abm_grid_protected" "help abm_grid_protected"}{...}
{p2colset 1 39 41 2}{...}
{p2col:{bf:is_posint()}, {bf:is_bool()}, {bf:is_setup()} {hline 2}}aborts with 
an error if arguments don't meet requirements{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:void} 
{cmd:is_posint(}{it:real scalar val}, {it:string scalar name}{cmd:)}

{p 8 12 2}
{it:void} 
{cmd:is_posint(}{it:real scalar val}, {it:string scalar name}, {it:string scalar zero_ok}{cmd:)}

{p 8 12 2}
{it:void} 
{cmd:is_bool(}{it:real scalar val}, {it:string scalar name}{cmd:)}

{p 8 12 2}
{it:void} 
{cmd:is_setup()}


{marker description}{...}
{title:Description}

{p 4 4 2}
These functions test whether common requirements are met, and aborts with an 
error message when that is not the case.

{pmore}
{cmd:is_posint()} test whether {it:val} is a positive integer, and aborts with 
return code 3300 and the message "{it:name} must be a positive integer". If the
{it:zero_ok} argument is also specified the value 0 is also allowed, otherwise
the value 0 will also results in an error.

{pmore}
{cmd:is_bool()} tests whether {it:val} is either 0 or 1, and aborts with 
return code 3300 and the message "{it:name} can only be 0 or 1".

{pmore}
{cmd:is_setup()} aborts with an error if setup()} has not run or when settings 
have been changed after {cmd:setup()} has been run. 


{marker conformability}{...}
{title:Conformability}

    {cmd:is_posint(}{it:val}, {it:name}{cmd:)}:
           {it:result}:   {it:void}
           {it:val}:      1 {it:x} 1
           {it:name}:     1 {it:x} 1

    {cmd:is_posint(}{it:val}, {it:name}, {it:zero_ok}{cmd:)}:
           {it:result}:   {it:void}
           {it:val}:      1 {it:x} 1
           {it:name}:     1 {it:x} 1           
           {it:zero_ok}:  1 {it:x} 1

    {cmd:is_bool(}{it:val}, {it:name}{cmd:)}:
           {it:result}:   {it:void}
           {it:val}:      1 {it:x} 1
           {it:name}:     1 {it:x} 1
           
    {cmd:is_setup()}:
           {it:result}:   {it:void}
		   
		   
{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:is_posint()} aborts with an error if {it:val} is not a positive integer.
the value 0 will result in an error if the {it:zero_ok} argument has not been
specified. 

{p 4 4 2}
{cmd:is_bool()} aborts with an error if {it:val} is not 0 or 1

{p 4 4 2}
{cmd:is_setup()} aborts with an error if setup()} has not run or when settings 
have been changed after {cmd:setup()} has been run.
