using ohmrun.Hsm;

class Main {
	static function main() {
		var log_facade = stx.log.Facade.unit();
				log_facade.includes.push("ohmrun.hsm");
				log_facade.format = [INCLUDE_LOCATION,INCLUDE_DETAIL];
				log_facade.logic	= 
					stx.log.Logic.constructor(
						(_) -> 
							log_facade.logic 
							&& 
							_.tag('x')		
					);
					
		ohmrun.hsm.Test.main();
	}
}