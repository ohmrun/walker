package ohmrun.hsm;

class NodeDeclarationCls<T>{
  public var type(default,null):Selectable;
  public var id(default,null):Id;
  public var children(default,null):ChildrenSpecifier<T>;
  public var parent(default,null):NodeSpecifier<T>;
  public var handler(default,null):Handler<T>;

  public function new(type:Selectable,id:Id,children:ChildrenSpecifier<T>,parent:NodeSpecifier<T>,handler:Handler<T>){
    this.type     = type;
    this.id       = id;
    this.children = children;
    this.parent   = parent;
    this.handler  = __.option(handler).def(Handler.unit);
  }
  public function toString(){
    return '$type:"$id" $children $parent';
  }
}
typedef NodeDeclarationDef<T> = {
  public var type(default,null):Selectable;
  public var id(default,null):Id;
  public var children(default,null):ChildrenSpecifier<T>;
  public var parent(default,null):NodeSpecifier<T>;
  public var handler(default,null):Handler<T>;
}
abstract NodeDeclaration<T>(NodeDeclarationDef<T>) from NodeDeclarationDef<T> to NodeDeclarationDef<T>{
  public function new(self) this = self;
  static public function lift<T>(self:NodeDeclarationDef<T>):NodeDeclaration<T> return new NodeDeclaration(self);
  

  static public function make<T>(type:Selectable,id:Id,children:ChildrenSpecifier<T>,parent:NodeSpecifier<T>,handler:Handler<T>):NodeDeclaration<T>{
    return new NodeDeclarationCls(type,id,children,parent,handler);
  }

  public function prj():NodeDeclarationDef<T> return this;
  private var self(get,never):NodeDeclaration<T>;
  private function get_self():NodeDeclaration<T> return lift(this);

  public function fetch_root(){
    
  }
}