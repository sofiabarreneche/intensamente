/** First Wollok example */
object riley {
	var property felicidad= 1000
	var property emocionDominante = alegria
	const recuerdosDia = []
	const property pensamientosCentrales = #{}
	const memoriaALargoPlazo = []
	const procesosMentales = []
	const fechaNacimiento = new Date(day= 3, month = 6, year= 1997)
	var edad
	
	method calcularEdad(){
		const fechaActual = new Date()
		edad = fechaActual.year() - fechaNacimiento.year()
	}
	method vivir(descr){
		const recu = new Recuerdo(descripcion=descr, fecha= new Date(), emocion=emocionDominante)
		recuerdosDia.add(recu)
	}
	
	method agregarPensamientoCentral(recuerdo){
		pensamientosCentrales.add(recuerdo)
	}
	
	method disminuirFelicidad(porcentaje){
		felicidad-=felicidad*porcentaje/100
		if(felicidad<1)
			self.error("La felicidad no puede ser menor a 1")
	}
	
	method recuerdosRecientes()=recuerdosDia.reverse().take(5)
	
	method pensamientosCentralesDificiles() = pensamientosCentrales.filter({pen=>pen.dificilDeExplicar()})
		
	method asentamiento() = self.asentarRecuerdos(recuerdosDia)
	
	method asentamientoSelectivo(palabra){
		const recuerdosFiltrados = recuerdosDia.filter({recu=>recu.contiene(palabra)})
		return self.asentarRecuerdos(recuerdosFiltrados)
		}

	method asentarRecuerdos(recuerdos) = recuerdos.forEach({recu=>recu.asentar()})
	
	method profundizacion() {
		const recuerdosFiltrados = recuerdosDia.filter({recu=>recu.noEsCentral()
														recu.noNegacion()})
		memoriaALargoPlazo.addAll(recuerdosFiltrados)
}
	method controlHormonal(){
		if(self.algunPensamientoEnMemoria() or self.recuerdosConMismaEmocion())
			self.desequilibrioHormonal()
	}
	
	method desequilibrioHormonal(){
			self.disminuirFelicidad(15)
			pensamientosCentrales.asList().drop(3)
	}
	
	method algunPensamientoEnMemoria() = pensamientosCentrales.any({pens=>memoriaALargoPlazo.contains(pens)})
	method recuerdosConMismaEmocion() = recuerdosDia.all({recu=>recu.emocion()==emocionDominante})
	method restauracionCognitiva(){
		felicidad=(felicidad+100).min(1000)
	}
	method liberacionDeRecuerdos() {
		recuerdosDia.clear()
	}
	
	method irAMimir(){
		procesosMentales.forEach({proceso=>proceso.aplicar()})
	}

	method rememorar(){
		const rec = memoriaALargoPlazo.anyOne()
		if(rec.anios()>edad/2)
			recuerdosDia.add(rec)
	}
	
	method repeticionesEnMemoria(recuerdo) = memoriaALargoPlazo.occurrencesOf(recuerdo)
	
	method dejaVu(){
		recuerdosDia.any({rec=>rec.repetidoEnMemoria()})
	}
}

object asentamiento{
	method aplicar() = riley.asentamiento()
} 
class AsentamientoSelectivo{
	var palabraClave
	method aplicar() = riley.asentamientoSelectivo(palabraClave)
} 
object profundizacion{
	method aplicar() {
		riley.profundizacion()
} 
}
object controlHormonal{
	method aplicar() {
		riley.controlHormonal()
}
} 
object restauracionCognitiva{
	method aplicar() {
		riley.restauracionCognitiva()
}
} 
object liberacion{
	method aplicar(){
		riley.liberacionDeRecuerdos()
	}
} 
class Recuerdo{
	var property descripcion = ""
	var property fecha
	var property emocion
	
	method dificilDeExplicar()=	descripcion.words().size()>10
	method asentar(){
		emocion.consecuencia(self)
	}
	method contiene(palabra) = descripcion.words().contains(palabra)
	
	method noEsCentral() = !riley.pensamientosCentrales().contains(self)
	
	method noNegacion() = !emocion.negar(self)
	
	method anios(){
		const fechaActual = new Date()
		return (fechaActual.year()-fecha.year())
	}
	method repetidoEnMemoria() = riley.repeticionesEnMemoria(self)>1
}


class Emocion{
	method consecuencia(recuerdo){}
	method negar(recuerdo) = false
}

object alegria inherits Emocion{
	
	override method consecuencia(recuerdo){
		if(riley.felicidad()>500)
			riley.agregarPensamientoCentral(recuerdo)
	}
	override method negar(recuerdo)= recuerdo.emocion() != self
}

object tristeza inherits Emocion{
	override method consecuencia(recuerdo){
			riley.agregarPensamientoCentral(recuerdo)
			riley.disminuirFelicidad(10)
	}
	override method negar(recuerdo)= recuerdo.emocion() == alegria
}

object disgusto inherits Emocion{
}

object temor inherits Emocion{
	
}

object furia inherits Emocion{
	
}

object compuesta inherits Emocion{
	const emociones = []
	
	override method negar(recuerdo) = emociones.all({emo=>emo.negar(recuerdo)})
	
	method esAlegre() = emociones.contains(alegria)
	
	override method consecuencia(recuerdo){
		emociones.forEach({emo=>emo.consecuencia(recuerdo)})
	}
}
