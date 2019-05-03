# abm_grid: A Mata class for managing a square grid for Agent Based Models

## Description

abm_grid is a [Mata](https://www.stata.com/features/overview/introduction-to-mata/)
class intended to help manage a grid for Agent Based models. An Agent Based Model 
is a simulation in which agents, that each follow simple rules, interact with one 
another and thus produce a often surprising outcome at the macro level. The purpose 
of an ABM is to explore mechanisms through which actions of the individual agents 
add up to a macro outcome, by varying the rules that agents have to follow or 
varying with whom the agent can interact (i.e. varying the network). 

Implementing a new ABM will always require that person developing the ABM does
some programming, but many tasks will be similar across ABMs. For example, in many 
ABMs the agents live on a square grid (like a chessboard), and can only interact 
with their neighbours. The abm_grid class contains a set of Mata functions that 
will do those task, and that someone can import in her or his own ABM. 

## Requirements and use

This requies [Stata](https://www.stata.com) version 15. The class itself is 
defined in the abm_grid.mata file. The class can be imported and used in an Agent
Based Model by adding the line `do abm_grid.mata` to the .do file that defines the
ABM. There is a complete example in the help files, start with `help abm_grid`.
