package com.luxsoft.cfdi

import java.text.SimpleDateFormat

import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.exception.ExceptionUtils

import com.edicom.ediwinws.cfdi.client.CfdiClient
import com.edicom.ediwinws.cfdi.utils.ZipUtils

import org.apache.commons.logging.LogFactory
import com.luxsoft.lx.core.Empresa

class CfdiTimbrador {
	
	ZipUtils zipUtils=new ZipUtils()
	CfdiClient cfdiClient=new CfdiClient()
	SimpleDateFormat df=new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss")
	
	private static final log=LogFactory.getLog(this)
	
	Cfdi timbrar(Cfdi cfdi,Empresa empresa){
		assert empresa.usuarioPac,"Debe registrar un usuario para el servicio del PAC "
		assert empresa.passwordPac,"Debe registrar un password para el servicio del PAC "
		try {
			String user=empresa.usuarioPac
			String password=empresa.passwordPac
			log.info 'Timbrando: '+cfdi
			String nombre=cfdi.xmlName
			byte[] xml=cfdi.xml
			assert xml,'El cfdi esta mal generado no contiene datos xml'
			assert nombre,"El cfdi esta mal generado no define nombre de archivo xmlName"
			byte[] zipFile=zipUtils.comprimeArchivo(nombre, xml)
			//byte[] res=cfdiClient.getCfdiTest(user, password, zipFile)
			byte[] res
			if(empresa.timbradoDePrueba){
				log.info 'Timbrando de prueba: '+cfdi
				res=cfdiClient.getCfdiTest(user, password, zipFile)
			}else{
				log.debug 'Timbrando real de: '+cfdi
				res=cfdiClient.getCfdi(user, password, zipFile)
			}
			Map<String, byte[]> map =zipUtils.descomprimeArchivo(res)
			Map.Entry<String, byte[]> entry=map.entrySet().iterator().next()
			
			cfdi.xmlName=entry.getKey()
			cfdi.xml=entry.getValue()
			cfdi.loadComprobante()
			cfdi.timbreFiscal=new TimbreFiscal(cfdi.getComprobante())
			cfdi.uuid=cfdi.timbreFiscal.UUID
			cfdi.timbrado=df.parse(cfdi.timbreFiscal.fechaTimbrado)
			//cfdi.save(failOnError:true)
			return cfdi
		} catch (Exception e) {
			//e.printStackTrace()
			log.error e
			String msg="Imposible timbrar cfdi $cfdi.id Error: "+ExceptionUtils.getMessage(e)
			throw new CfdiException(message:msg,cfdi:cfdi)
		}
	}

}
