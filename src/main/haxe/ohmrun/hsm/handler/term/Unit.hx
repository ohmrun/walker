package ohmrun.hsm.handler.term;

class Unit<T> implements HandlerApi<T>{
  public function new(){}
  public function apply(v:Phase<T>){
    return v;
  }
}