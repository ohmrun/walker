package eu.ohmrun.walker;

class Spec{
  
}
typedef NodeSpecDef<T,G,K> = {
              public var id(default,null):Id;
  @:optional  public var type(default,null):Selectable;
  @:optional  public var call(default,null):Call<T,G,K>;
  @:optional  public var rest(default,null):ChildrenSpec<T,G,K>;
}
@:forward abstract NodeSpec<T,G,K>(NodeSpecDef<T,G,K>) from NodeSpecDef<T,G,K> to NodeSpecDef<T,G,K>{
  public function toString(){
    return __.that().exists().ok()(this.rest).if_else(
      () -> this.rest.is_defined().if_else(
        () -> '${this.id}(${this.rest})',
        ()  -> '${this.id}'
      ),
      () -> this.id.toString()
    );
  }
  public function toTree():Tree<T,G,K>{
    var node : Node<T,G,K> = new NodeCls(this.id,__.option(this.type).defv(One),this.call);
    
    var rest = __.option(this.rest).defv([]).rfold(
      (next:NodeSpec<T,G,K>,memo:LinkedList<KaryTree<Node<T,G,K>>>) -> memo.cons(next.toTree()),
      LinkedList.unit()
    );
    var head = rest.is_defined().if_else(() -> Branch(node,rest),() -> Branch(node));
    return Tree.lift(head);
  }
}
typedef ChildrenSpecDef<T,G,K> = Array<NodeSpec<T,G,K>>;

@:forward abstract ChildrenSpec<T,G,K>(ChildrenSpecDef<T,G,K>) from ChildrenSpecDef<T,G,K> to ChildrenSpecDef<T,G,K>{
  public function toString(){
    return this.map( _ -> _.toString() );
  }

}