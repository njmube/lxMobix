package com.luxsoft.lx.tesoreria


import org.grails.databinding.BindingFormat
import org.apache.commons.lang.builder.EqualsBuilder
import org.apache.commons.lang.builder.HashCodeBuilder

import com.luxsoft.lx.contabilidad.CuentaContable
import com.luxsoft.lx.core.Empresa

class MovimientoDeCuenta {
	
	Empresa empresa

	CuentaBancaria cuenta

	Long folio

	@BindingFormat('dd/MM/yyyy')
	Date fecha
	
	BigDecimal importe
	
	String referencia

	String comentario
	
	
	Date dateCreated
	Date lastUpdated
	String creadoPor
	String modificadoPor

    static constraints = {
		importe(scale:4)
		referencia(nullable:true)
		comentario(nullable:true)
    }
	
	static mapping ={
		fecha type:'date'
		cuenta fetch:'join'
	}
	
	String toString(){
		return "Folio:$folio ${cuenta}  (${fecha.format('dd/MM/yyyy')}) ${importe}"
	}
	
	boolean equals(Object obj){
		if(!obj.instanceOf(MovimientoDeCuenta))
			return false
		if(this.is(obj))
			return true
		def eb=new EqualsBuilder()
		eb.append(id, obj.id)
		eb.append(cuenta, obj.cuenta)
		eb.append(folio, obj.folio)
		return eb.isEquals()
	}
	
	int hashCode(){
		def hb=new HashCodeBuilder(17,35)
		hb.append(id)
		hb.append(cuenta)
		hb.append(folio)
		return hb.toHashCode()
	}
}

