%--------------------------------------------------------------------------
% File     : ../ILLTP//KLE_28_01.p
% Domain   : Intuitionistic Syntactic 
% Problem  : Kleene intuitionistic theorems
% Version  : 1.0
% English  :
% Source   : Introduction to Metamathematics
% Name     : Kleene intuitionistic theorems (Translation 01)
% Status   : Theorem 
% Rating   : 
% Comments : 
%--------------------------------------------------------------------------
fof(ax1, axiom,  ! (! (! A -o ! B) & ! (! B -o ! A)) ).
fof(conj, conjecture,  ! (! (! (! A -o ! C) -o ! (! B -o C)) & ! (! (! B -o ! C) -o ! (! A -o C)))).