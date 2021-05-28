package eu.ohmrun.walker;

class NodeCls<T,G>{
  public var id(default,null):Id;
  public var type(default,null):Selectable;
  public var call(default,null):Call<T,G>;

  public function new(id,type,?call){
    this.id       = id;
    this.type     = type;
    this.call     = __.option(call).defv(Call.debug(id));
  }

  public function toString(){ return '$type:$id'; }
}
@:using(eu.ohmrun.walker.Node.NodeLift)
@:forward abstract Node<T,G>(NodeCls<T,G>) from NodeCls<T,G> to NodeCls<T,G>{
  static public var _(default,never) = NodeLift;
  public function new(self) this = self;
}
class NodeLift{
  static public function eq<T,G>():Eq<Node<T,G>>{
    return Eq.Anon(
      (l:Node<T,G>,r:Node<T,G>) -> Id._.eq().applyII(l.id,r.id)
    );
  }
  static public function ord<T,G>():Ord<Node<T,G>>{
    return Ord.Anon(
      (l:Node<T,G>,r:Node<T,G>) -> Id._.lt().applyII(l.id,r.id)
    );
  }
  static public function equals<T,G>(self:Node<T,G>,that:Node<T,G>):Bool{
    return self.id.equals(that.id);
  }
}