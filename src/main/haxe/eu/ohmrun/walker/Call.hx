package eu.ohmrun.walker;

typedef CallDef<T,G,K> = FletcherDef<Context<T,G,K>,Res<Plan<T,G,K>,WalkerFailure>,Noise>;

@:using(eu.ohmrun.fletcher.Attempt.AttemptLift)
@:using(eu.ohmrun.walker.Call.CallLift)
@:forward abstract Call<T,G,K>(CallDef<T,G,K>) from CallDef<T,G,K> to CallDef<T,G,K>{
  public function new(self:CallDef<T,G,K>) this = self;
  @:noUsing static public function lift<T,G,K>(self:CallDef<T,G,K>):Call<T,G,K>{
    return new Call(self);
  }
  @:noUsing static public function debug<T,G,K>(id:Id):Call<T,G,K>{
    return lift(
      Fletcher.Sync(
        (context:Context<T,G,K>) -> {
          trace('id: $id@${context.phase}');
          return __.accept(Plan.pure(context.global));
        }
      )
    );
  }
  @:noUsing static public function unit<T,G,K>(){
    return lift(
      Fletcher.Sync(
        (context:Context<T,G,K>) -> {
          //trace('Call.unit');
          return __.accept(Plan.pure(context.global));
        }
      )
    );
  }
  @:to public function toFletcher():Fletcher<Context<T,G,K>,Res<Plan<T,G,K>,WalkerFailure>,Noise>{
    return Fletcher.lift(this);
  }
  @:from static public function fromFContextVoid<T,G,K>(fn:Context<T,G,K>->Void){
    return lift(
      Fletcher.Sync(
        (ctx:Context<T,G,K>) -> {
          fn(ctx);
          return __.accept(Plan.pure(ctx.global));
        }
      )  
    );
  }
  @:to public function toAttempt():Attempt<Context<T,G,K>,Plan<T,G,K>,WalkerFailure>{
    return Attempt.lift(this);
  }
  public function symmetric():Attempt<Context<T,G,K>,Context<T,G,K>,WalkerFailure>{
    return Attempt.lift(
      Attempt.lift(this).broach().convert(
        Fletcher.Sync(
          (couple:Couple<Context<T,G,K>,Plan<T,G,K>>) -> {
            var ctx           = couple.fst();
            var buffer        = ctx.buffer.concat(couple.snd().buffer);
            return ctx.copy(null,null,null,null,null,buffer);
          }
        )
      )
    );
  }
  public function seq(that:Call<T,G,K>):Call<T,G,K>{
    return lift(symmetric().attempt(that));
  }
}
class CallLift{
  static public function environment<T,G,K>(self:Call<T,G,K>,ctx:Context<T,G,K>,success:Plan<T,G,K>->Void,?failure:Err<WalkerFailure>->Void){
    return Fletcher._.environment(
      self,
      ctx,
      (res:Res<Plan<T,G,K>,WalkerFailure>) -> {
        trace(res);
        res.fold(success,__.option(failure).defv(__.crack));
      },
      __.crack
    );
  }
}