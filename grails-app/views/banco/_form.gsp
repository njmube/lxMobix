<%@ page import="com.luxsoft.lx.tesoreria.Banco" %>



<div class="fieldcontain ${hasErrors(bean: bancoInstance, field: 'nombre', 'error')} required">
	<label for="nombre">
		<g:message code="banco.nombre.label" default="Nombre" />
		<span class="required-indicator">*</span>
	</label>
	<g:textField name="nombre" maxlength="150" required="" value="${bancoInstance?.nombre}"/>

</div>

<div class="fieldcontain ${hasErrors(bean: bancoInstance, field: 'bancoSat', 'error')} required">
	<label for="bancoSat">
		<g:message code="banco.bancoSat.label" default="Banco Sat" />
		<span class="required-indicator">*</span>
	</label>
	<g:select id="bancoSat" name="bancoSat.id" from="${com.luxsoft.lx.sat.BancoSat.list()}" optionKey="id" required="" value="${bancoInstance?.bancoSat?.id}" class="many-to-one"/>

</div>

<div class="fieldcontain ${hasErrors(bean: bancoInstance, field: 'cuentas', 'error')} ">
	<label for="cuentas">
		<g:message code="banco.cuentas.label" default="Cuentas" />
		
	</label>
	
<ul class="one-to-many">
<g:each in="${bancoInstance?.cuentas?}" var="c">
    <li><g:link controller="cuentaBancaria" action="show" id="${c.id}">${c?.encodeAsHTML()}</g:link></li>
</g:each>
<li class="add">
<g:link controller="cuentaBancaria" action="create" params="['banco.id': bancoInstance?.id]">${message(code: 'default.add.label', args: [message(code: 'cuentaBancaria.label', default: 'CuentaBancaria')])}</g:link>
</li>
</ul>


</div>

<div class="fieldcontain ${hasErrors(bean: bancoInstance, field: 'empresa', 'error')} required">
	<label for="empresa">
		<g:message code="banco.empresa.label" default="Empresa" />
		<span class="required-indicator">*</span>
	</label>
	<g:select id="empresa" name="empresa.id" from="${com.luxsoft.lx.core.Empresa.list()}" optionKey="id" required="" value="${bancoInstance?.empresa?.id}" class="many-to-one"/>

</div>

