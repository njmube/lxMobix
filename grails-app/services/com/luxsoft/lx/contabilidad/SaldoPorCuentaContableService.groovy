package com.luxsoft.lx.contabilidad

import grails.transaction.Transactional
import java.text.SimpleDateFormat
import com.luxsoft.lx.core.Empresa


@Transactional
class SaldoPorCuentaContableService {

	def generar(Empresa empresa,Integer ejercicio,Integer mes){
		def cuentas=CuentaContable.findAllByEmpresa(empresa)
		cuentas.each{ cuenta->
			def found=SaldoPorCuentaContable.findByEmpresaAndCuentaAndEjercicioAndMes(empresa,cuenta,ejercicio,mes)
			if(!found){
				found=new SaldoPorCuentaContable(empresa:empresa,cuenta:cuenta,ejercicio:ejercicio,mes:mes)
				found.save failOnError:true
			}
		}
	}


	def buscarSaldosDeSubCuentas(SaldoPorCuentaContable saldo){
		def saldos=[]
		def empresa=saldo.empresa
		def ejercicio=saldo.ejercicio
		def mes=saldo.mes
		saldo.cuenta.subCuentas.each{ cuenta->
			def found=SaldoPorCuentaContable.findByEmpresaAndCuentaAndEjercicioAndMes(empresa,cuenta,ejercicio,mes)
			if(found)
				saldos.add(found)
		}
		return saldos
	}

	def buscarCuentaDeMayor(CuentaContable cuenta){
		if(cuenta.padre==null){
			return cuenta
		}else{
			return buscarCuentaDeMayor(cuenta.padre)
		}
	}

	def actualizarSaldo(SaldoPorCuentaContable saldo){
		def periodo=new PeriodoContable(ejercicio:saldo.ejercicio,mes:saldo.mes)
		actualizarSaldo(saldo.cuenta,periodo)
	}

	def actualizarSaldo(CuentaContable cuenta,PeriodoContable periodo){
		def cuentaDeMayor=buscarCuentaDeMayor(cuenta)
		cuentaDeMayor.subCuentas.each{ c->
			actualizarMovimientos(c,periodo)
		}
		mayorizar(cuentaDeMayor,periodo)

	}

	def actualizarMovimientos(CuentaContable cuenta,PeriodoContable periodo){
		if(cuenta.detalle){

			def saldoInicial=0
			if(periodo.mes==1){
				def cierreAnual=SaldoPorCuentaContable.findByCuentaAndEjercicioAndMes(cuenta,periodo.ejercicio-1,13)

				log.info 'SaldoInicial obtenido: '+cierreAnual
				saldoInicial=cierreAnual.saldoFinal
			}else{
				saldoInicial=SaldoPorCuentaContable.findByCuentaAndEjercicioAndMes(cuenta,periodo.ejercicio,periodo.mes-1)?.saldoFinal?:0.0
			}
			def row=PolizaDet
				.executeQuery("select sum(d.debe),sum(d.haber) from PolizaDet d where d.cuenta=? and d.poliza.ejercicio=? and d.poliza.mes=? and d.poliza.tipo!=?"
				,[cuenta,periodo.ejercicio,periodo.mes,'CIERRE_ANUAL'])
				
			def debe=row.get(0)[0]?:0.0
			def haber=row.get(0)[1]?:0.0
			def saldo=SaldoPorCuentaContable.findOrCreateWhere(empresa:cuenta.empresa,cuenta:cuenta,ejercicio:periodo.ejercicio,mes:periodo.mes)
			log.info "Cuenta $cuenta.clave Saldo inicial:$saldoInicial Debe:$debe Haber:$haber"
			saldo.saldoInicial=saldoInicial
			saldo.debe=debe
			saldo.haber=haber
			saldo.saldoFinal=saldo.saldoInicial+debe-haber
			def res=saldo.save(failOnError:true)
			return res
		}else{
			cuenta.subCuentas.each{c->
				actualizarMovimientos(c,periodo)
			}
		}
	}

	def mayorizar(CuentaContable cuenta,PeriodoContable periodo){

		if(!cuenta.detalle){
			log.info 'Mayorizando en cuenta:'+cuenta
			def row=SaldoPorCuentaContable
					.executeQuery("select sum(d.saldoInicial),sum(d.debe),sum(d.haber) from SaldoPorCuentaContable d where d.cuenta.padre=? and d.ejercicio=? and d.mes=?"
					,[cuenta,periodo.ejercicio,periodo.mes])
			log.info 'Saldos relacionados: '+row
			def saldo=SaldoPorCuentaContable.findOrCreateWhere(empresa:cuenta.empresa,cuenta:cuenta,ejercicio:periodo.ejercicio,mes:periodo.mes)
			
			def saldoInicial=row.get(0)[0]?:0.0
			def debe=row.get(0)[1]?:0.0
			def haber=row.get(0)[2]?:0.0
			saldo.saldoInicial=saldoInicial
			saldo.debe=debe
			saldo.haber=haber
			saldo.saldoFinal=saldo.saldoInicial+debe-haber
			def res=saldo.save(failOnError:true)
			
			cuenta.subCuentas.each{ subCuenta ->
				
				mayorizar(subCuenta,periodo)
			}
		}
	}

	def buscarMovimientos(SaldoPorCuentaContable saldo){

		def params=[saldo.cuenta,saldo.ejercicio,saldo.mes]
		String hql="from PolizaDet d where d.cuenta=? and d.poliza.ejercicio=? and d.poliza.mes=?"
		return PolizaDet.findAll(hql,params)
	}
	
	
	
}



