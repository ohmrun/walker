package ohmrun.hsm;

enum NodeSpecifierSum<T>{
  //SpecifyId(id:Id);
  SpecifyDeclaration(node:NodeDeclaration<T>);
  SpecifyNode(node:Node<T>);
  SpecifyHole(hole:HsmConstructorHole<T>);
}
abstract NodeSpecifier<T>(NodeSpecifierSum<T>) from NodeSpecifierSum<T> to NodeSpecifierSum<T>{
  public function new(self) this = self;
  @:from static public function fromDeclaration<T>(self:NodeDeclaration<T>):NodeSpecifier<T>{
    return SpecifyDeclaration(self);
  }
  @:from static public function fromNode<T>(self:Node<T>):NodeSpecifier<T>{
    return SpecifyNode(self);
  }
  @:from static public function fromHole<T>(self:HsmConstructorHole<T>):NodeSpecifier<T>{
    return SpecifyHole(self);
  }
  public function fold(f_declaration,f_node,f_hole){
    return switch(this){  
      //case SpecifyId(id)                    : f_id(id);
      case SpecifyDeclaration(declaration)  : f_declaration(declaration);
      case SpecifyNode(node)                : f_node(node);
      case SpecifyHole(hole)                : f_hole(hole);
    }
  }
  public function toString(){
    return fold(
      //(id)          -> '#$id',
      (declaration) -> '\\$$declaration',
      (node)        -> '@$node',
      (hole)        -> '?'
    );
  }
}