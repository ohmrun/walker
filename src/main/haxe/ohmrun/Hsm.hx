package ohmrun;

typedef NodeSpec<T>       = ohmrun.hsm.Spec.NodeSpec<T>;
typedef ChildrenSpec<T>   = ohmrun.hsm.Spec.ChildrenSpec<T>;

class Hsm{
  static public function id(wildcard:Wildcard,name:String,?uuid:String):Id{
    return Id.make(name,__.option(uuid));
  }
  static public function root<T>():Node<T>{
    return new NodeCls(Id.make("root"),One,Handler.unit());
  }
  static public function one<T>(id:Id,?call:Handler<T>,?rest:ChildrenSpec<T>):NodeSpec<T>{
    return {
      id    : id,
      type  : One,
      call  : __.option(call).defv(Handler.unit()),
      rest  : __.option(rest).defv([])
    };
  }
  static public function all<T>(id:Id,?call:Handler<T>,?rest:ChildrenSpec<T>):NodeSpec<T>{
    return {
      id    : id,
      type  : All,
      call  : __.option(call).defv(Handler.unit()),
      rest  : __.option(rest).defv([])
    }
  }
}
typedef HsmConstructorHole<T> = NodeSpecifier<T> -> NodeDeclaration<T>;

typedef HsmConstructorDef<T> = ContinuationDef<NodeDeclaration<T>,NodeSpecifier<T>>;
@:using(stx.fp.Continuation.ContinuationLift)
@:forward abstract HsmConstructor<T>(HsmConstructorDef<T>) from HsmConstructorDef<T> to HsmConstructorDef<T>{
  public function new(self) this = self;
  @:noUsing static public function lift<T>(self:HsmConstructorDef<T>):HsmConstructor<T>{
    return new HsmConstructor(self);
  }
  //@:noUsing static public function make<T>()
}

abstract ChildrenSpecifier<T>(Array<NodeSpecifier<T>>) from Array<NodeSpecifier<T>> to Array<NodeSpecifier<T>>{
  public function toString(){
    return '[' + this.map(x -> '$x').join(",") + ']';
  }
}
typedef Spec                          = ohmrun.hsm.Spec;
typedef NodeSpecifierSum<T>           = ohmrun.hsm.NodeSpecifier.NodeSpecifierSum<T>;
typedef NodeSpecifier<T>              = ohmrun.hsm.NodeSpecifier<T>; 
typedef IdDef                         = ohmrun.hsm.Id.IdDef;
typedef Id                            = ohmrun.hsm.Id;

typedef NodeCls<T>                    = ohmrun.hsm.Node.NodeCls<T>;
typedef Node<T>                       = ohmrun.hsm.Node<T>;

typedef NodeDeclarationDef<T>         = ohmrun.hsm.NodeDeclaration.NodeDeclarationDef<T>;
typedef NodeDeclarationCls<T>         = ohmrun.hsm.NodeDeclaration.NodeDeclarationCls<T>;
typedef NodeDeclaration<T>            = ohmrun.hsm.NodeDeclaration<T>;

typedef TransitionData<T>             = ohmrun.hsm.TransitionData<T>;

typedef PhaseSum<T>                   = ohmrun.hsm.Phase.PhaseSum<T>;
typedef Phase<T>                      = ohmrun.hsm.Phase<T>;

typedef State<T>                      = ohmrun.hsm.State<T>;

typedef HandlerApi<T>                 = ohmrun.hsm.Handler.HandlerApi<T>;
typedef HandlerDef<T>                 = ohmrun.hsm.Handler.HandlerDef<T>;
typedef Handler<T>                    = ohmrun.hsm.Handler<T>;

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
typedef HandlersDef<T> = stx.ds.RedBlackMap<String,Selector>;

@:forward abstract Handlers<T>(HandlersDef<T>) from HandlersDef<T> to HandlersDef<T>{
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