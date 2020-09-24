package ohmrun.hsm.call.term;

class Unit<T> implements CallApi<T>{
  public function new(){}
  public function apply(v:Phase<T>){
    return v;
  }
}