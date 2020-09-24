package ohmrun.hsm;

interface CallApi<T>{
  public function apply(v:Phase<T>):Phase<T>;
}
typedef CallDef<T> = {
  public function apply(v:Phase<T>):Phase<T>;
}
abstract Call<T>(CallDef<T>) from CallDef<T> to CallDef<T>{
  @:from static public function Anon<T>(fn:Phase<T>->Phase<T>):Call<T>{
    return new ohmrun.hsm.call.term.Anon(fn);
  }
  @:noUsing static public function unit<T>():Call<T>{
    return new ohmrun.hsm.call.term.Unit();
  }
}