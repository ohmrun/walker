package ohmrun;

typedef NodeSpec<T>       = ohmrun.hsm.Spec.NodeSpec<T>;
typedef ChildrenSpec<T>   = ohmrun.hsm.Spec.ChildrenSpec<T>;

class Hsm{
  static public function id(wildcard:Wildcard,name:String,?uuid:String):Id{
    return Id.make(name,__.option(uuid));
  }
  static public function root<T>():Node<T>{
    return new NodeCls(Id.make("root"),One,Call.unit());
  }
  static public function one<T>(id:Id,?call:Call<T>,?rest:ChildrenSpec<T>):NodeSpec<T>{
    return {
      id    : id,
      type  : One,
      call  : __.option(call).defv(Call.unit()),
      rest  : __.option(rest).defv([])
    };
  }
  static public function all<T>(id:Id,?call:Call<T>,?rest:ChildrenSpec<T>):NodeSpec<T>{
    return {
      id    : id,
      type  : All,
      call  : __.option(call).defv(Call.unit()),
      rest  : __.option(rest).defv([])
    }
  }
}
typedef Spec                          = ohmrun.hsm.Spec;
typedef IdDef                         = ohmrun.hsm.Id.IdDef;
typedef Id                            = ohmrun.hsm.Id;

typedef NodeCls<T>                    = ohmrun.hsm.Node.NodeCls<T>;
typedef Node<T>                       = ohmrun.hsm.Node<T>;

typedef TransitionData<T>             = ohmrun.hsm.TransitionData<T>;

typedef PhaseSum<T>                   = ohmrun.hsm.Phase.PhaseSum<T>;
typedef Phase<T>                      = ohmrun.hsm.Phase<T>;

typedef State<T>                      = ohmrun.hsm.State<T>;

typedef CallApi<T>                 = ohmrun.hsm.Call.CallApi<T>;
typedef CallDef<T>                 = ohmrun.hsm.Call.CallDef<T>;
typedef Call<T>                    = ohmrun.hsm.Call<T>;

typedef Selector                      = ohmrun.hsm.Selector;

enum Selectable{
  One;
  All;
}
abstract ArrayOfNode<T>(Array<Node<T>>) from Array<Node<T>> to Array<Node<T>>{}
class Transition{

}
class StateDeclaration{

}
typedef CallsDef<T> = stx.ds.RedBlackMap<String,Selector>;

@:forward abstract Calls<T>(CallsDef<T>) from CallsDef<T> to CallsDef<T>{
  public function new(){
    this = RedBlackMap.make(
      Comparable.String()
    );
  }
}

class Machine<T>{
  public var state(default,null):State<T>;
}


class NodeDeclarationResolution{
  public function new(){}  
}