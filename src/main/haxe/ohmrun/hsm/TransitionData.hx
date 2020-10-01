package ohmrun.hsm;

class TransitionData<T>{
  static public function make(self,path,from,into){
    return new TransitionData(self,path,from,into);
  }
  public function new(self:Tree<T>,path:Path,from:Tree<T>,into:Tree<T>){
    this.self   = self;
    this.path   = path;
    this.from   = from;
    this.into   = into;
  }
  public var self(default,null):Tree<T>;
  public var path(default,null):Path;
  public var from(default,null):Tree<T>;
  public var into(default,null):Tree<T>;

  public function toString(){
    return '\n(from: $from)\n(into: $into)';
  }
  
}