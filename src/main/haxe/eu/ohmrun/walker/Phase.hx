package eu.ohmrun.walker;

enum PhaseSum{
  Enter;
  Leave;
}
abstract Phase(PhaseSum) from PhaseSum to PhaseSum{
  
}