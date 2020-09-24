package ohmrun.hsm.call.term;

class Anon<T> implements CallApi<T>{
  public var delegate(default,null):Phase<T>->Phase<T>;
  public function new(delegate){
    this.delegate = delegate;
  }
  public function apply(v:Phase<T>){
    return delegate(v);
  }
}