package eu.ohmrun.walker;

class Spec{
  
}
interface NodeSpecApi<T,G,K,E>{
  public final id:Id;
  @:optional  public final type:Selectable;
  @:optional  public final call:Call<T,G,K,E>;
  @:optional  public final rest:ChildrenSpec<T,G,K,E>;
  //public function asNodeSpecDef():NodeSpecDef<T,G,K,E>;
}
typedef NodeSpecDef<T,G,K,E> = {
              public final id:Id;
  @:optional  public final type:Selectable;
  @:optional  public final call:Call<T,G,K,E>;
  @:optional  public final rest:ChildrenSpec<T,G,K,E>;

  //public function asNodeSpecDef():NodeSpecDef<T,G,K,E>;
}
@:forward abstract NodeSpec<T,G,K,E>(NodeSpecDef<T,G,K,E>) from NodeSpecDef<T,G,K,E> to NodeSpecDef<T,G,K,E>{
  static public function lift<T,G,K,E>(self:NodeSpecDef<T,G,K,E>):NodeSpec<T,G,K,E>{
    return self;
  }
  public function toString(){
    return __.that().exists().apply(this.rest).is_ok().if_else(
      () -> this.rest.is_defined().if_else(
        () -> '${this.id}(${this.rest})',
        ()  -> '${this.id}'
      ),
      () -> this.id.toString()
    );
  }
  public function toTree():Tree<T,G,K,E>{
    var node : Node<T,G,K,E> = new NodeCls(this.id,__.option(this.type).defv(One),this.call);
    
    var rest = __.option(this.rest).defv(Cluster.unit()).rfold(
      (next:NodeSpec<T,G,K,E>,memo:LinkedList<KaryTree<Node<T,G,K,E>>>) -> memo.cons(next.toTree()),
      LinkedList.unit()
    );
    var head = rest.is_defined().if_else(
      () -> Branch(node,rest),() -> Branch(node,LinkedList.unit())
    );
    return Tree.lift(head);
  }
  public function asNodeSpecDef():NodeSpecDef<T,G,K,E>{
    return this;
  }
}
typedef ChildrenSpecDef<T,G,K,E> = Cluster<NodeSpec<T,G,K,E>>;

@:forward abstract ChildrenSpec<T,G,K,E>(ChildrenSpecDef<T,G,K,E>) from ChildrenSpecDef<T,G,K,E> to ChildrenSpecDef<T,G,K,E>{
  public function toString(){
    return this.map( _ -> _.toString() );
  }

}