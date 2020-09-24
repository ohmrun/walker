package ohmrun.hsm.handler.term;

class Anon<T> implements HandlerApi<T>{
  public var delegate(default,null):Phase<T>->Phase<T>;
  public function new(delegate){
    this.delegate = delegate;
  }
  public function apply(v:Phase<T>){
    return delegate(v);
  }
}