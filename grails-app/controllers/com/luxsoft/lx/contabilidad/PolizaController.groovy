package com.luxsoft.lx.contabilidad



import static org.springframework.http.HttpStatus.*
import grails.transaction.Transactional
import org.springframework.security.access.annotation.Secured
import grails.converters.JSON
import com.luxsoft.lx.bi.ReportCommand

@Secured(["hasAnyRole('CONTABILIDAD','ADMIN')"])
@Transactional(readOnly = true)
class PolizaController {

    static allowedMethods = [save: "POST", update: "PUT", delete: "GET"]

    def polizaService
    def cierreContableService
    def reportService
    

    def index(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        params.sort=params.sort?:'lastUpdated'
        params.order='desc'
        def empresa=session.empresa
        def ejercicio=session.periodoContable.ejercicio
        def mes=session.periodoContable.mes
        def polizas=Poliza.findAllByEmpresaAndEjercicioAndMes(empresa,ejercicio,mes,params)
        def polizasCount=Poliza.countByEmpresaAndEjercicioAndMes(empresa,ejercicio,mes)
        respond polizas,model:[polizaInstanceCount: polizasCount]
    }

    def show(Poliza polizaInstance) {
        respond polizaInstance
    }

    def create() {
        [polizaInstance:new PolizaCommand(mes:session.periodoContable.mes)]
    }

    @Transactional
    def save(PolizaCommand command) {
        if (command == null) {
            notFound()
            return
        }

        if (command.hasErrors()) {
            render view:'create',model:[polizaInstance:command]
            return
        }

        def polizaInstance=polizaService.save(command.toPoliza())
        flash.message="Poliza ${polizaInstance.id} generada"
        redirect action:'edit',id:polizaInstance.id
    }

    def edit(Poliza polizaInstance) {
        respond polizaInstance
    }

    @Transactional
    def update(Poliza polizaInstance) {

        if (polizaInstance == null) {
            notFound()
            return
        }
        
        if (polizaInstance.hasErrors()) {
            println 'Errores de validacion: '+polizaInstance.errors
            println 'Params: '+params
            respond polizaInstance.errors, view:'edit'
            return
        }

        polizaInstance=polizaService.update(polizaInstance)
        flash.message="Poliza ${polizaInstance.id} actualizada"
        redirect action:'edit',id:polizaInstance.id
        
    }

    @Transactional
    def delete(Poliza polizaInstance) {
        if (polizaInstance == null) {
            notFound()
            return
        }
        polizaService.delete(polizaInstance)
        flash.message="Poliza ${polizaInstance.id} eliminada"
        redirect action:'index'
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'poliza.label', default: 'Poliza'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }

    def actualizarPeriodo(PeriodoContable periodoContable){
        def origin=request.getHeader('referer')
        session.periodoContable=periodoContable
        log.info 'Periodo actualizado: '+periodoContable+' Origen: '+origin+ '  Target:'+request.getHeader('referer') 
        redirect(uri: request.getHeader('referer') )
    }

    def afterInterceptor = { model, modelAndView ->
        //println "Current view is ${modelAndView.viewName}"
        if (!model.periodo) 
            model.periodo=session.periodoContable
        //println "View is now ${modelAndView.viewName}"
    }

    def print(Poliza polizaInstance){
        def command=new ReportCommand()
        command.reportName="PolizaContable"
        command.empresa=session.empresa
        def stream=reportService.build(command,[ID:polizaInstance.id,EMPRESA:session.empresa.nombre])
        def file="Poliza_${polizaInstance.tipo}_${polizaInstance.folio}_${polizaInstance.ejercicio}${polizaInstance.mes}"+new Date().format('ss')+'.'+command.formato.toLowerCase()
        render(
            file: stream.toByteArray(), 
            contentType: 'application/pdf',
            fileName:file)
    }

    def cierreAnual(){
        [polizaInstanceList:Poliza.findByEmpresaAndTipo(session.empresa,'CIERRE_ANUAL')]
    }

    
    @Transactional
    def generarCierreAnual(){
        cierreContableService.generarPolizaDeCierre(session.empresa,session.periodoContable.ejercicio)
        redirect action:'index'

    }
}

import org.grails.databinding.BindingFormat
import com.luxsoft.lx.core.Empresa


class PolizaCommand{

    Empresa empresa
    Integer ejercicio
    Integer mes
    String tipo
    @BindingFormat('dd/MM/yyyy')
    Date fecha=new Date()
    String concepto
    String comentario


    // PolizaCommand(){}

    // PolizaCommand(PeriodoContable p){
    //     mes=p.mes
    //     ejercicio=p.ejercicio
    // }

    static constraints={
        importFrom Poliza
        //tipo(inList:['INGRESO','EGRESO','DIARIO','COMPRAS','GENERICA','CIERRE_ANUAL'])
    }

    Poliza toPoliza(){
        def poliza=new Poliza()
        poliza.properties=properties
        poliza.manual=true
        poliza.concepto=this.concepto.toUpperCase()
        return poliza
    }
    
    
}


