using eu.ohmrun.Hsm;

class Main {
	static function main() {
		var log_facade = stx.log.Facade.unit();
				//log_facade.includes.push("eu.ohmrun.hsm");
				log_facade.includes.push("eu.ohmrun.hsm.test");
				//log_facade.includes.push("stx.async");
				//log_facade.format = [INCLUDE_LOCATION,INCLUDE_DETAIL];
				log_facade.logic	= 
					stx.log.Logic.constructor(
						(_) -> 
							log_facade.logic 
							&& _.always()
							//_.tag('x')		
					);
					
		eu.ohmrun.hsm.Test.main();
	}
}