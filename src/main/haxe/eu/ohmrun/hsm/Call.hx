package eu.ohmrun.hsm;

typedef CallDef<T,G> = FletcherDef<Context<T,G>,Res<G,HsmFailure>,Noise>;

@:using(eu.ohmrun.fletcher.Attempt.AttemptLift)
@:using(eu.ohmrun.hsm.Call.CallLift)
@:forward abstract Call<T,G>(CallDef<T,G>) from CallDef<T,G> to CallDef<T,G>{
  public function new(self:CallDef<T,G>) this = self;
  @:noUsing static public function lift<T,G>(self:CallDef<T,G>):Call<T,G>{
    return new Call(self);
  }
  @:noUsing static public function debug<T,G>(id:Id){
    return lift(
      Fletcher.Sync(
        (context:Context<T,G>) -> {
          trace('id: $id@${context.phase}');
          return __.accept(context.global);
        }
      )
    );
  }
  @:noUsing static public function unit<T,G>(){
    return lift(
      Fletcher.Sync(
        (context:Context<T,G>) -> {
          //trace('Call.unit');
          return __.accept(context.global);
        }
      )
    );
  }
  @:to public function toFletcher():Fletcher<Context<T,G>,Res<G,HsmFailure>,Noise>{
    return Fletcher.lift(this);
  }
  @:from static public function fromFContextVoid<T,G>(fn:Context<T,G>->Void){
    return lift(Fletcher.Sync(__.passthrough(fn).fn().then(_ -> _.global).then(__.accept)));
  }
  @:to public function toAttempt():Attempt<Context<T,G>,G,HsmFailure>{
    return Attempt.lift(this);
  }
  public function symmetric():Attempt<Context<T,G>,Context<T,G>,HsmFailure>{
    return Attempt.lift(
      Attempt.lift(this).broach().convert(
        Fletcher.Sync(
          (couple:Couple<Context<T,G>,G>) -> Context.make(couple.fst().event,couple.snd())
        )
      )
    );
  }
  public function seq(that:Call<T,G>):Call<T,G>{
    return lift(symmetric().attempt(that));
  }
}
class CallLift{
  static public function environment<T,G>(self:Call<T,G>,ctx:Context<T,G>,success:G->Void,?failure:Err<HsmFailure>->Void){
    return Fletcher._.environment(
      self,
      ctx,
      (res:Res<G,HsmFailure>) -> {
        trace(res);
        res.fold(success,__.option(failure).defv(__.crack));
      },
      __.crack
    );
  }
}