package ohmrun.hsm;

class Spec{
  
}
typedef NodeSpecDef<T> = {
              public var id(default,null):Id;
  @:optional  public var type(default,null):Selectable;
  @:optional  public var call(default,null):Handler<T>;
  @:optional  public var rest(default,null):ChildrenSpec<T>;
}
@:forward abstract NodeSpec<T>(NodeSpecDef<T>) from NodeSpecDef<T> to NodeSpecDef<T>{
  public function toString(){
    return __.that().exists().ok()(this.rest).if_else(
      () -> this.rest.is_defined().if_else(
        () -> '${this.id}(${this.rest})',
        ()  -> '${this.id}'
      ),
      () -> this.id.toString()
    );
  }
}
typedef ChildrenSpecDef<T> = Array<NodeSpec<T>>;

abstract ChildrenSpec<T>(ChildrenSpecDef<T>) from ChildrenSpecDef<T> to ChildrenSpecDef<T>{
  public function toString(){
    return this.map( _ -> _.toString() );
  }
}