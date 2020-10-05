package ohmrun.hsm;

class Spec{
  
}
typedef NodeSpecDef<T,G> = {
              public var id(default,null):Id;
  @:optional  public var type(default,null):Selectable;
  @:optional  public var call(default,null):Call<T,G>;
  @:optional  public var rest(default,null):ChildrenSpec<T,G>;
}
@:forward abstract NodeSpec<T,G>(NodeSpecDef<T,G>) from NodeSpecDef<T,G> to NodeSpecDef<T,G>{
  public function toString(){
    return __.that().exists().ok()(this.rest).if_else(
      () -> this.rest.is_defined().if_else(
        () -> '${this.id}(${this.rest})',
        ()  -> '${this.id}'
      ),
      () -> this.id.toString()
    );
  }
  public function toTree():Tree<T,G>{
    var node : Node<T,G> = new NodeCls(this.id,__.option(this.type).defv(One),this.call);
    
    var rest = __.option(this.rest).defv([]).rfold(
      (next:NodeSpec<T,G>,memo:LinkedList<KaryTree<Node<T,G>>>) -> memo.cons(next.toTree()),
      LinkedList.unit()
    );
    var head = rest.is_defined().if_else(() -> Branch(node,rest),() -> Branch(node));
    return Tree.lift(head);
  }
}
typedef ChildrenSpecDef<T,G> = Array<NodeSpec<T,G>>;

@:forward abstract ChildrenSpec<T,G>(ChildrenSpecDef<T,G>) from ChildrenSpecDef<T,G> to ChildrenSpecDef<T,G>{
  public function toString(){
    return this.map( _ -> _.toString() );
  }

}