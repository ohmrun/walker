package ohmrun.hsm;

interface HandlerApi<T>{
  public function apply(v:Phase<T>):Phase<T>;
}
typedef HandlerDef<T> = {
  public function apply(v:Phase<T>):Phase<T>;
}
abstract Handler<T>(HandlerDef<T>) from HandlerDef<T> to HandlerDef<T>{
  @:from static public function Anon<T>(fn:Phase<T>->Phase<T>):Handler<T>{
    return new ohmrun.hsm.handler.term.Anon(fn);
  }
  @:noUsing static public function unit<T>():Handler<T>{
    return new ohmrun.hsm.handler.term.Unit();
  }
}