%--------------------------------------------------------------------------
% File     : ../ILLTP//KLE_37_MU.p
% Domain   : Intuitionistic Syntactic 
% Problem  : Kleene intuitionistic theorems
% Version  : 1.0
% English  :
% Source   : Introduction to Metamathematics
% Name     : Kleene intuitionistic theorems (Translation MU)
% Status   : False (Not a theorem) 
% Rating   : 
% Comments : 
%--------------------------------------------------------------------------
fof(ax1, axiom,  B ).
fof(conj, conjecture,  ((A -o B) -o B) * (B -o (A -o B))).