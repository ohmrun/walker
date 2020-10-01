package ohmrun.hsm;

class Spec{
  
}
typedef NodeSpecDef<T> = {
              public var id(default,null):Id;
  @:optional  public var type(default,null):Selectable;
  @:optional  public var call(default,null):Call<T>;
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
  public function toTree():Tree<T>{
    var node : Node<T> = new NodeCls(this.id,__.option(this.type).defv(One),this.call);
    
    var rest = __.option(this.rest).defv([]).rfold(
      (next:NodeSpec<T>,memo:LinkedList<KaryTree<Node<T>>>) -> memo.cons(next.toTree()),
      LinkedList.unit()
    );
    var head = rest.is_defined().if_else(() -> Branch(node,rest),() -> Branch(node));
    return Tree.lift(head);
  }
}
typedef ChildrenSpecDef<T> = Array<NodeSpec<T>>;

@:forward abstract ChildrenSpec<T>(ChildrenSpecDef<T>) from ChildrenSpecDef<T> to ChildrenSpecDef<T>{
  public function toString(){
    return this.map( _ -> _.toString() );
  }

}