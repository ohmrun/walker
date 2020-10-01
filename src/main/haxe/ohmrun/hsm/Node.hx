package ohmrun.hsm;

class NodeCls<T>{
  public var id(default,null):Id;
  public var type(default,null):Selectable;
  public var call(default,null):Call<T>;

  public function new(id,type,?call){
    this.id       = id;
    this.type     = type;
    this.call     = __.option(call).defv(Call.unit());
  }

  public function toString(){ return '$type:$id'; }
}
@:using(ohmrun.hsm.Node.NodeLift)
@:forward abstract Node<T>(NodeCls<T>) from NodeCls<T> to NodeCls<T>{
  static public var _(default,never) = NodeLift;
  public function new(self) this = self;
}
class NodeLift{
  static public function eq<T>():Eq<Node<T>>{
    return Eq.Anon(
      (l:Node<T>,r:Node<T>) -> Id._.eq().applyII(l.id,r.id)
    );
  }
  static public function ord<T>():Ord<Node<T>>{
    return Ord.Anon(
      (l:Node<T>,r:Node<T>) -> Id._.lt().applyII(l.id,r.id)
    );
  }
  static public function equals<T>(self:Node<T>,that:Node<T>):Bool{
    return self.id.equals(that.id);
  }
}