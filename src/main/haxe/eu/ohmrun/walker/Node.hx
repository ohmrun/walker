package eu.ohmrun.walker;

class NodeCls<T,G,K,E>{
  public final id:Id;
  public final type:Selectable;
  public final call:Call<T,G,K,E>;

  public function new(id,type,?call){
    this.id       = id;
    this.type     = type;
    this.call     = __.option(call).defv(Call.debug(id));
  }

  public function toString(){ return '$type:$id'; }
}
@:using(eu.ohmrun.walker.Node.NodeLift)
@:forward abstract Node<T,G,K,E>(NodeCls<T,G,K,E>) from NodeCls<T,G,K,E> to NodeCls<T,G,K,E>{
  static public var _(default,never) = NodeLift;
  public function new(self) this = self;
}
class NodeLift{
  static public function eq<T,G,K,E>():Eq<Node<T,G,K,E>>{
    return Eq.Anon(
      (l:Node<T,G,K,E>,r:Node<T,G,K,E>) -> Id._.eq().comply(l.id,r.id)
    );
  }
  static public function ord<T,G,K,E>():Ord<Node<T,G,K,E>>{
    return Ord.Anon(
      (l:Node<T,G,K,E>,r:Node<T,G,K,E>) -> Id._.lt().comply(l.id,r.id)
    );
  }
  static public function equals<T,G,K,E>(self:Node<T,G,K,E>,that:Node<T,G,K,E>):Bool{
    return self.id.equals(that.id);
  }
}