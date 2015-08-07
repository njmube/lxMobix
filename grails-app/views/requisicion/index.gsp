<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<title>Requisiciones</title>
</head>
<body>

	<div class="container">
		
		<div class="row">

			<div class="col-md-12">
				<div class="alert alert-info">
					<h4>
						<p class="text-center"> Registro de Requisiciones  </p>
						<p class="text-center"><small>${session.empresa.nombre}</small></p>
							
					</h4>
					<g:if test="${flash.message}">
						<span class="label label-warning">${flash.message}</span>
					</g:if> 
				</div>
			</div>
		</div><!-- end .row -->

		<div class="row toolbar-panel">
		    <div class="col-md-6">
		    	<input type='text' id="filtro" placeholder="Filtrar" class="form-control" autofocus="on">
		      </div>

		    <div class="btn-group">
		        
		        <g:link action="index" class="btn btn-default ">
		            <span class="glyphicon glyphicon-repeat"></span> Refrescar
		        </g:link>
		    </div>
		    <div class="btn-group">
		        <button type="button" name="operaciones"
		                class="btn btn-default dropdown-toggle" data-toggle="dropdown"
		                role="menu">
		                Operaciones <span class="caret"></span>
		        </button>
		        <ul class="dropdown-menu">
		            <li>
		                <g:link action="create" ><i class="fa fa-plus"></i> Nuevo</g:link>
		            </li>
		        </ul>
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
							<th>Folio</th>
							<th>Proveedor</th>
							<th>Pago</th>
							<th>Total</th>
							<th>Comentario</th>
							<th>Modificado</th>
						</tr>
					</thead>
					<tbody>
						<g:each in="${requisicionInstanceList}" var="row">
							<tr id="${row.id}">
								<td >
									<g:link  action="show" id="${row.id}">
										${row.folio}
									</g:link>
								</td>
								<td >
									<g:link  action="show" id="${row.id}">
										${fieldValue(bean:row,field:"proveedor")}
									</g:link>
								</td>
								<td><g:formatDate date="${row.pago}" format="dd/MM/yyyy"/></td>
								<td>${formatNumber(number:row.total,type:'currency')}</td>
								<td>${fieldValue(bean:row,field:"comentario")}</td>
								<td><g:formatDate date="${row.lastUpdated}" format="dd/MM/yyyy HH:mm"/></td>
							</tr>
						</g:each>
					</tbody>
				</table>
				<div class="pagination">
					<g:paginate total="${requisicionInstanceCount ?: 0}"/>
				</div>
			</div>
		</div> <!-- end .row 2 -->
		%{-- <g:render template="uploadXmlFile"/> --}%

	</div>


	<script type="text/javascript">
		$(document).ready(function(){
			
			$('#grid').dataTable( {
				"responsive": true,
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