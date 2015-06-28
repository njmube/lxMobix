<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<title>${bancoInstance.nombre}</title>
	<asset:stylesheet src="datatables/dataTables.css"/>
	<asset:javascript src="datatables/dataTables.js"/> 
</head>
<body>

	<div class="container">
		
		<div class="row">

			<div class="col-md-12">
				<div class="well well-sm">
					<h2> 
						${bancoInstance.nombre} <small>(${bancoInstance.bancoSat.razonSocial})</small>
					</h2>
					<g:if test="${flash.message}">
						<span class="label label-warning">${flash.message}</span>
					</g:if> 
				</div>
			</div>
		</div><!-- end .row -->


		<div class="row toolbar-panel">
			<div class="col-md-6 col-md-offset-3">
				<div class="btn-group">
				    <g:link action="index" class="btn btn-default ">
				        <i class="fa fa-step-backward"></i> Bancos
				    </g:link>
				    <g:link action="index" class="btn btn-default ">
				        <i class="fa fa-plus"></i> Nuevo
				    </g:link>
				    <%-- Acciones de administrador --%>
				    <sec:ifAllGranted roles="TESORERIA">
				    	<g:link action="delete" class="btn btn-danger " id="${bancoInstance.id}">
				    	    <i class="fa fa-trash"></i> Eliminar
				    	</g:link>
				    </sec:ifAllGranted>
				    <sec:ifAllGranted roles="TESORERIA">
				    	<g:link action="edit" class="btn btn-default " id="${bancoInstance.id}">
				    	    <i class="fa fa-pencil"></i> Editar
				    	</g:link>
				    </sec:ifAllGranted>
				    
				</div>
				
				<div class="btn-group">
				    <button type="button" name="reportes"
				            class="btn btn-default dropdown-toggle" data-toggle="dropdown"
				            role="menu">
				            Reportes <span class="caret"></span>
				    </button>
				    <ul class="dropdown-menu">
				        
				    </ul>
				</div>
			</div>
		</div> 

		<div class="row ">
		    <div class="col-md-6 col-md-offset-3">
		    	<fieldset disabled>
				<g:form class="form-horizontal"  >	
					<div class="panel panel-primary">
						<div class="panel-heading">Folio ${bancoInstance.id}</div>
					  <div class="panel-body">
					    <g:hasErrors bean="${bancoInstance}">
					    	<div class="alert alert-danger">
					    		<ul class="errors" >
					    			<g:renderErrors bean="${bancoInstance}" as="list" />
					    		</ul>
					    	</div>
					    	
					    </g:hasErrors>
						<f:with bean="${bancoInstance}">
							<f:field property="nombre" widget-class="form-control uppercase-field" />
							<f:field property="bancoSat" widget-class="form-control"/>
						</f:with>
					  </div>

					</div>
				</g:form>
				</fieldset>

		    </div>
		</div>

		<!-- end .row 2 -->

	</div>

	
</body>
</html>