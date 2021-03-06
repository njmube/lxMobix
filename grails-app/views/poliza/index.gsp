<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<title>Polizas</title>
	<asset:stylesheet src="datatables/dataTables.css"/>
	<asset:javascript src="datatables/dataTables.js"/> 
</head>
<body>

	<div class="container">
		
		<div class="row">

			<div class="col-md-12">
				<div class="alert alert-info">
					<h4>
						<p class="text-center"> Registro de Polizas <a href="#cambiarPeriodo">${periodo?.mes} - ${periodo?.ejercicio} </a> </p>
						<p class="text-center">
							<small>
								${session.empresa.nombre} 
								
							</small>
						</p>
							
					</h4>
					<g:if test="${flash.message}">
						<span class="label label-warning">${flash.message}</span>
					</g:if> 
				</div>
			</div>
		</div><!-- end .row -->

		<div class="row toolbar-panel">
		    <div class="col-md-4">
		    	<input type='text' id="filtro" placeholder="Filtrar" class="form-control" autofocus="on">
		      </div>

		    <div class="btn-group">
		        
		        <g:link action="index" class="btn btn-default ">
		            <span class="glyphicon glyphicon-repeat"></span> Refrescar
		        </g:link>
		        <a href="#periodoDialog" data-toggle="modal" class="btn btn-default " >
		        	<i class="fa fa-calendar"></i>  Periodo: ${session.periodoContable.mes} / ${session.periodoContable.ejercicio}
		        </a>
		        <g:link action="create" class="btn btn-default "><i class="fa fa-plus"></i> Nuevo</g:link>
		        <g:if test="${session.periodoContable.mes==13}">
		        	<g:link action="generarCierreAnual" class="btn btn-default "><i class="fa fa-cog"></i> Cierre anual</g:link>
		        	
		        </g:if>
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

		<div class="row">
			<div class="col-md-12">
				<table id="grid" class="table table-striped table-bordered table-condensed">

					<thead>
						<tr>
							<th>Ejercicio</th>
							<th>Mes</th>
							<th>Tipo</th>
							<th>Folio</th>
							<th>Fecha</th>
							<th>Concepto</th>
							<th>Debe</th>
							<th>Haber</th>
							<th>Cuadre</th>
							<th>Modificado</th>
							<th>M</th>
							<th>Cierre</th>
						</tr>
					</thead>
					<tbody>
						<g:each in="${polizaInstanceList}" var="row">
							<tr id="${row.id}" class="${row.cuadre?'danger':''}">
								<td >
									<g:link  action="show" id="${row.id}">
										${formatNumber(number:row.ejercicio,format:'####')}
									</g:link>
								</td>
								<td >
									<g:link  action="show" id="${row.id}">
										${formatNumber(number:row.mes,format:'####')}
									</g:link>
								</td>
								<td>${fieldValue(bean:row,field:"tipo")}</td>
								<td>${formatNumber(number:row.folio,format:'####')}</td>
								<td><g:formatDate date="${row.fecha}" format="dd/MM/yyyy"/></td>
								<td>${fieldValue(bean:row,field:"concepto")}</td>
								<td>${formatNumber(number:row.debe,type:'currency')}</td>
								<td>${formatNumber(number:row.haber,type:'currency')}</td>
								<td>${formatNumber(number:row.cuadre,type:'currency')}</td>
								<td><g:formatDate date="${row.lastUpdated}" format="dd/MM/yyyy HH:mm"/></td>
								<td><g:checkBox name="myCheckbox" value="${row.manual}" disabled="disabled"/></td>
								<td><g:formatDate date="${row.cierre}" format="dd/MM/yyyy HH:mm"/></td>
							</tr>
						</g:each>
					</tbody>
				</table>
				<div class="pagination">
					<g:paginate total="${polizaInstanceCount ?: 0}"/>
				</div>
			</div>
		</div> <!-- end .row 2 -->
		<g:render template="/common/cambioDePeriodo" bean="${session.periodoContable}"/>

	</div>


	<script type="text/javascript">
		$(document).ready(function(){
			
			$('#grid').dataTable( {
	        	"paging":   false,
	        	"ordering": false,
	        	"info":     false
	        	,"dom": '<"toolbar col-md-4">rt<"bottom"lp>'
	    	} );
	    	
	    	$("#filtro").on('keyup',function(e){
	    		var term=$(this).val();
	    		$('#grid').DataTable().search(
					$(this).val()
	    		        
	    		).draw();
	    	});

		});
	</script>
</body>
</html>