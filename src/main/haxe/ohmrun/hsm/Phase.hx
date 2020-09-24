package ohmrun.hsm;

enum PhaseSum<T>{
  Enter;
  Update(v:T);
  Leave;
}
abstract Phase<T>(PhaseSum<T>) from PhaseSum<T> to PhaseSum<T>{
  
}