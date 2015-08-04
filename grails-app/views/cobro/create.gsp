<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<title>Registro de cobro</title>
	<asset:javascript src="forms/autoNumeric.js"/>
</head>
<body>

	<div class="container">
		
		<div class="row">

			<div class="col-md-12">

				<div class="page-header">
				  <h3>Alta de cobro  <small> (${session.empresa})</small>
				  	<g:if test="${flash.message}">
				  		<small><span class="label label-warning ">${flash.message}</span></small>
				  	</g:if> 
				  	<g:if test="${flash.error}">
				  		<small><span class="label label-danger ">${flash.error}</span></small>
				  	</g:if> 
				  </h3>
				</div>
			</div>
		</div><!-- end .row -->

		<div class="row ">
			
			<div class="col-md-8 col-md-offset-2">
				
				<g:form class="form-horizontal" action="save" >	

					<div class="panel panel-primary">
						<div class="panel-heading">Datos generales</div>
					  	<div class="panel-body">
						    <g:hasErrors bean="${cobroInstance}">
						    	<div class="alert alert-danger">
						    		<ul class="errors" >
						    			<g:renderErrors bean="${cobroInstance}" as="list" />
						    		</ul>
						    	</div>
						    </g:hasErrors>
						    <g:hiddenField name="empresa.id" value="${session.empresa.id}"/>
							<f:with bean="${cobroInstance}">
								<div class="col-sm-12">
									<f:field property="cliente" wrapper="bootstrap3" widget-class="form-control"/>
									<f:field property="fecha" wrapper="bootstrap3"/>
									<f:field property="formaDePago" wrapper="bootstrap3" widget-class="form-control"/>
									<f:field property="banco" wrapper="bootstrap3" widget-class="form-control"/>
									<f:field property="referencia" wrapper="bootstrap3" widget-class="form-control"/>
									<f:field property="importe" widget="money" wrapper="bootstrap3"/>
									<f:field property="cuentaDestino" wrapper="bootstrap3" widget-class="form-control"/>
									<f:field property="comentario" wrapper="bootstrap3" widget-class="form-control"/>
								</div>
								
							</f:with>
					  	</div>
					 
						<div class="panel-footer">
						  	<div class="form-group">
						  		<div class="buttons col-md-offset-4 col-md-4">
						  			<g:submitButton name="Salvar" class="btn btn-primary " />
						  			<g:link action="index" class="btn btn-default"> Cancelar</g:link>
						  		</div>
						  	</div>
						</div>

					</div>

				</g:form>
				
			</div>
		</div> <!-- end .row 2 -->
	</div>

	<script type="text/javascript">
		$(function(){
			$(".money").autoNumeric({wEmpty:'zero',aSep:"",lZero: 'deny'});
		});
	</script>
	
</body>
</html>