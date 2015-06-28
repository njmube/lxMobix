<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<title>Requisición ${requisicionInstance?.id}</title>
	<asset:stylesheet src="datatables/dataTables.css"/>
	<asset:javascript src="datatables/dataTables.js"/> 
	<asset:javascript src="forms/autoNumeric.js"/>
</head>
<body>

	<div class="container form-panel">


		<div class="row toolbar-panel">
			<div class="col-md-10 col-md-offset-1">
				<div class="btn-group">
				    <g:link action="index" class="btn btn-default ">
				        <i class="fa fa-step-backward"></i> Requisiciones
				    </g:link>

				    <g:link action="print" class="btn btn-default " id="${requisicionInstance.id}">
				        <i class="fa fa-print"></i> Imprimir
				    </g:link> 
				    <g:link action="edit" class="btn btn-default " id="${requisicionInstance.id}">
				        <i class="fa fa-pencil"></i> Editar
				    </g:link> 
				</div>
			</div>
		</div> 

		<div class="row ">
		    <div class="col-md-10 col-md-offset-1 ">
		    	
				<g:form name="updateForm" class="form-horizontal"   id="${requisicionInstance.id}">	

					<div class="panel panel-primary">
						<div class="panel-heading">Proveedor: ${requisicionInstance.proveedor} Id: ${requisicionInstance.id}</div>
				  		<div class="panel-body">
				    		<g:hasErrors bean="${requisicionInstance}">
				    			<div class="alert alert-danger">
				    				<ul class="errors" >
				    					<g:renderErrors bean="${requisicionInstance}" as="list" />
				    				</ul>
				    			</div>
				    		</g:hasErrors>

							<f:with bean="${requisicionInstance}">
								<div class="col-sm-6">
									<f:field property="pago" cols="col-sm-6" colsLabel="col-sm-3 col-sm-offset-1"/>
									<f:field property="tipo" widget-class="form-control" cols="col-sm-6" colsLabel="col-sm-3 col-sm-offset-1"/>
									<f:field property="comentario" widget-class="form-control" cols="col-sm-6" colsLabel="col-sm-3 col-sm-offset-1"/>

								</div>
								<div class="col-sm-6 " id="totalesPanel">
									<f:field property="total" cols="col-sm-4" colsLabel="col-sm-2 col-sm-offset-2"/>
								</div>
								
							</f:with>
				  		</div>

				  		<table id="grid" class="table table-striped table-bordered table-condensed">
				  			<thead>
				  				<tr>
				  					<th>CxP</th>
				  					<th>Fecha</th>
				  					<th>Vencimiento</th>
				  					<th>Total</th>
				  					<th>Requisitado</th>
				  					<th>Comentario</th>
				  					
				  				</tr>
				  			</thead>
				  			<tbody>
				  				<g:each in="${requisicionInstance.partidas}" var="row">
				  					<tr id="${row.id}">
				  						<td >
				  							<g:link  controller="gastoDet" action="show" id="${row.id}">
				  								${fieldValue(bean:row,field:"cuentaPorPagar.id")}
				  							</g:link>
				  						</td>
				  						<td>${fieldValue(bean:row,field:"unidad")}</td>
				  						<td><td><g:formatDate date="${row.cuentaPorPagar.fecha}" format="dd/MM/yyyy"/></td></td>
				  						<td><td><g:formatDate date="${row.cuentaPorPagar.vencimiento}" format="dd/MM/yyyy"/></td></td>
				  						<td>${formatNumber(number:row.cuentaPorPagar.total,format:'##.##')}</td>
				  						<td>${g.formatNumber(number:row.requisitado,type:'currency')}</td>
				  						<td>${fieldValue(bean:row,field:"comentario")}</td>
				  						
				  					</tr>
				  				</g:each>
				  			</tbody>
				  		</table>
				  		
				  		<div class="panel-footer">
				  			<g:if test="${flash.message}">
				  				<span class="label label-warning">${flash.message}</span>
				  			</g:if> 
				  			
				  			%{-- <div class="form-group">
				  				<div class="buttons col-md-4">
				  					<g:submitButton name="Salvar" class="btn btn-primary " />
				  					<g:link action="index" class="btn btn-default"> Cancelar</g:link>
				  				</div>
				  			</div> --}%
				  		</div>
					</div>
				</g:form>
				
			</div>
			
			

		</div><!-- end .row 2 -->
		
		<g:if test="${flash.error}">
			<div class="row">
				<div class="col-md-10 col-md-offset-1">
					<div class="alert alert-danger">
						${flash.error}
					</div>
				</div>
			</div>
		</g:if>
		
	
	</div>
<script type="text/javascript">
	$(function(){
		//$(".money").autoNumeric({wEmpty:'zero',aSep:""});
		
		$("#totalesPanel :input").each(function(){
		 	var input = $(this); // This is the jquery object of the input, do what you will
		 	input.removeAttr("type")
		 	.prop('type','text')
		 	.prop('disabled','disabled')
		 	.addClass('form-control')
		 	.addClass('text-right');
		});

		
		
	});
</script>
	
</body>
</html>