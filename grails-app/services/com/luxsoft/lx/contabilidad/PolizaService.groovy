package com.luxsoft.lx.contabilidad

import grails.transaction.Transactional

@Transactional
class PolizaService {

    def springSecurityService
    

    def saldoPorCuentaContableService

    def save(Poliza poliza) {
        poliza.with{
            def user=currentUser()
            creadoPor=user
            modificadoPor=user
            if(folio==null)
                folio=nextFolio(poliza)

        }
    	poliza.save flush:true,failOnError:true
    	return poliza
    }

    def update(Poliza poliza){
        println 'Actualizando poliza: '+poliza
        poliza.modificadoPor=currentUser()
        poliza.save flush:true,failOnError:true
        saldoPorCuentaContableService.actualizarSaldos(poliza)
        log.debug('Poliza actualizada: '+poliza.id)
        event('modificacionDePoliza',poliza)
        return poliza
    }

    def agregarConcepto(Poliza poliza,PolizaDet det){
        poliza.addToPartidas(det)
        poliza.modificadoPor=currentUser()
        poliza.actualizar()
        poliza.save flush:true,failOnError:true
        event('modificacionDePoliza',poliza)
        saldoPorCuentaContableService.actualizarSaldos(poliza)
    }

    def eleiminarPartida(PolizaDet det){
        Poliza poliza=det.poliza
        
        def ejercicio=poliza.ejercicio
        def mes=poliza.mes
        def cuenta=det.cuenta

        poliza.modificadoPor=currentUser()
        poliza.removeFromPartidas(det)
        poliza.actualizar()
        poliza.save flush:true,failOnError:true
        event('bajaDePolizaDet',poliza)
        saldoPorCuentaContableService.actualizarSaldo(cuenta,ejercicio,mes)
        return poliza
    }

    def delete(Poliza poliza){
        log.debug 'Eliminando poliza: '+poliza.id
        poliza.delete flush:true
        saldoPorCuentaContableService.actualizarSaldos(poliza)
        event('bajaDePoliza',poliza)
    }


    def actualizarPartida(PolizaDet det){
        Poliza poliza=det.poliza
        poliza.modificadoPor=currentUser()
        poliza.actualizar()
        poliza.save flush:true,failOnError:true
        event('modificacionDePolizaDet',poliza)
        saldoPorCuentaContableService.actualizarSaldo(det)
        return det;
    }



    private Long nextFolio(Poliza poliza){
        def folio=PolizaFolio.findByEmpresaAndEjercicioAndMesAndTipo(poliza.empresa,poliza.ejercicio,poliza.mes,poliza.tipo)
        if(folio==null){
            folio=new PolizaFolio(empresa:poliza.empresa,ejercicio:poliza.ejercicio,mes:poliza.mes,tipo:poliza.tipo,folio:0l)
        }
        def res=folio.next()
        folio.save()
        return res
    }

    def currentUser(){
        return springSecurityService.getCurrentUser().username
    }

    
}
