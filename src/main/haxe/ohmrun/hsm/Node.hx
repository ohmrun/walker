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

  public function toString(){ return 'Node($id[$type])'; }
}

@:forward abstract Node<T>(NodeCls<T>) from NodeCls<T> to NodeCls<T>{
  public function new(self) this = self;
}