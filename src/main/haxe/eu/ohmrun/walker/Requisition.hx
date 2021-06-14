package eu.ohmrun.walker;

typedef RequisitionDef<T,K> = {
  final request : Request<T,K>;
  final source  : Id;
}
abstract Requisition<T,K>(RequisitionDef<T,K>) from RequisitionDef<T,K> to RequisitionDef<T,K>{
  public function new(self) this = self;
  static public function make<T,K>(request:Request<T,K>,source:Id){
    return lift({
      request : request,
      source  : source
    });
  }
  static public function lift<T,K>(self:RequisitionDef<T,K>):Requisition<T,K> return new Requisition(self);

  public function prj():RequisitionDef<T,K> return this;
  private var self(get,never):Requisition<T,K>;
  private function get_self():Requisition<T,K> return lift(this);

  public var message(get,never) : Option<Message<T,K>>;
  public function get_message():Option<Message<T,K>>{
    return this.request.message;
  }
}