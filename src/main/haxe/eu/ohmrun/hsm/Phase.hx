package eu.ohmrun.hsm;

enum PhaseSum{
  Enter;
  Leave;
}
abstract Phase(PhaseSum) from PhaseSum to PhaseSum{
  
}