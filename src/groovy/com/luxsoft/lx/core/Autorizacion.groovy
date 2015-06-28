package com.luxsoft.lx.core

import grails.validation.Validateable
import groovy.transform.ToString


@ToString(includeNames=true,includePackage=false)
@Validateable(nullable=true)
class Autorizacion implements Serializable{
	
	String usuario
	String comentario
	Date fechaHora

	
    static constraints = {
		usuario nullable:true
		comentario nullable:true
		fechaHora nullable:true
    }
	
}