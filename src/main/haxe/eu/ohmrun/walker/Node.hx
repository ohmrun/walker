package eu.ohmrun.walker;

class NodeCls<T,G,K>{
  public var id(default,null):Id;
  public var type(default,null):Selectable;
  public var call(default,null):Call<T,G,K>;

  public function new(id,type,?call){
    this.id       = id;
    this.type     = type;
    this.call     = __.option(call).defv(Call.debug(id));
  }

  public function toString(){ return '$type:$id'; }
}
@:using(eu.ohmrun.walker.Node.NodeLift)
@:forward abstract Node<T,G,K>(NodeCls<T,G,K>) from NodeCls<T,G,K> to NodeCls<T,G,K>{
  static public var _(default,never) = NodeLift;
  public function new(self) this = self;
}
class NodeLift{
  static public function eq<T,G,K>():Eq<Node<T,G,K>>{
    return Eq.Anon(
      (l:Node<T,G,K>,r:Node<T,G,K>) -> Id._.eq().applyII(l.id,r.id)
    );
  }
  static public function ord<T,G,K>():Ord<Node<T,G,K>>{
    return Ord.Anon(
      (l:Node<T,G,K>,r:Node<T,G,K>) -> Id._.lt().applyII(l.id,r.id)
    );
  }
  static public function equals<T,G,K>(self:Node<T,G,K>,that:Node<T,G,K>):Bool{
    return self.id.equals(that.id);
  }
}