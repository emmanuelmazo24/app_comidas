<?php
include 'includes/conexion.php';
header('Content-Type: application/json');
$allowdResourceTypes = ['comidas'];
//print_r($_GET);
//var_dump(allowdResourceTypes);
$resourceType = $_GET['resource_type'];
if( !in_array($resourceType, $allowdResourceTypes)){
	http_response_code(400);
	echo json_encode(
		[
			'error' => "$resourceType recurso desconocido"
		]
	);
	die;//corta la ejecucion del script
}
//base de datos simulada
/*$libro = [
	1 => [
		"titulo" => "Lo que el viento se llevo",
		"id_autor" => 1,
		"id_genero" => 1,
	],
	2 => [
		"titulo" => "Aprendo php",
		"id_autor" => 2,
		"id_genero" => 2,
	],
	3 => [
		"titulo" => "Lo que el viento se llevo",
		"id_autor" => 3,
		"id_genero" => 3,
	],
];*/

$resourceId = array_key_exists('resource_id', $_GET) ? $_GET['resource_id']:'';
$method = $_SERVER['REQUEST_METHOD'];
switch( strtoupper($method) ){
	case 'GET':
		if( !empty($resourceId)){
			/*if ( array_key_exists( $resourceId, $libro)){
				echo json_encode(
					$libro[$resourceId]
				);
			}else{
				http_response_code(404);
				echo json_encode(
					[
						'error' => "Identificar de libro $resourceId no se encuentra"
					]
				);
				die;
			}*/
			$query = "select * from comida where id_comida = $resourceId ";
			$resul = mysqli_query($conexion, $query);
			$datos = [];
			if ($resul){
				while($reg = mysqli_fetch_array($resul)){
					$datos_aux['id_comida'] = $reg['id_comida'];
					$datos_aux['nombre_comida'] = $reg['nombre_comida'];
					$datos_aux['autor'] = $reg['autor'];
					$datos_aux['costo_comida'] = $reg['costo_comida'];
					array_push($datos,$datos_aux);
				}
			}
			if (!empty($datos)){
				echo json_encode($datos);
				die;
			}else{
				http_response_code(404);
				echo json_encode([
					'error' => 'No se encontraron recursos'
				]);
			}
			mysqli_close($conexion);
		}else{			
			/*echo json_encode(
					$libro
				);*/
			$query = "select * from comida";
			$resul = mysqli_query($conexion, $query);
			$datos = [];
			if ($resul){
				while($reg = mysqli_fetch_array($resul)){
					$datos_aux['id_comida'] = $reg['id_comida'];
					$datos_aux['nombre_comida'] = $reg['nombre_comida'];
					$datos_aux['autor'] = $reg['autor'];
					$datos_aux['costo_comida'] = $reg['costo_comida'];
					array_push($datos,$datos_aux);
				}
			}
			if (!empty($datos)){
				echo json_encode($datos);
				die;
			}else{
				http_response_code(404);
				echo json_encode([
					'error' => 'No se encontraron recursos'
				]);
			}	
			mysqli_close($conexion);
		}
	die;
	break;
	case 'POST':
		$json = file_get_contents('php://input');
		$libro [] = json_decode($json);
		$data = $libro[0];
		$nombre_comida = $data->nombre_comida;
		$autor = $data->autor;
		$costo_comida = $data->costo_comida;
		
		if(!$conexion){
			echo 'Error en la conexion';
			exit;
		}
		$query_insert = "insert into comida(nombre_comida, autor, costo_comida)
					values('$nombre_comida','$autor','$costo_comida')";
		$resul = mysqli_query($conexion, $query_insert);
		if ($resul){
			$respuesta['status'] = true;
			$respuesta['mensaje'] = 'Registro insertado correctamente';
			echo json_encode($respuesta);
		}else{
			echo 'Error al insertar le registro';
		}
		mysqli_close($conexion);
	break;
	case 'DELETE':
		if( !empty($resourceId)){	
			if(!$conexion){
				echo 'Error en la conexion';
				exit;
			}	
			
			$query = "delete from comida where id_comida = $resourceId ";
			$resul = mysqli_query($conexion, $query);
			$datos = [];
			if ($resul){
				$respuesta['status'] = true;
				$respuesta['mensaje'] = 'Registro eliminado correctamente';
				echo json_encode($respuesta);
			}else{
				echo 'Error al eliminar le registro';
			}			
			mysqli_close($conexion);
		}else{
			http_response_code(404);
			echo json_encode([
				'error' => 'No se encontraron recursos'
			]);
		}
	break;
		
	case 'PUT':
		$json = file_get_contents('php://input');
		$libro [] = json_decode($json);
		$data = $libro[0];
		$nombre_comida = $data->nombre_comida;
		$autor = $data->autor;
		$costo_comida = $data->costo_comida;
		
		if(!$conexion){
			echo 'Error en la conexion';
			exit;
		}
		$query_update = "update comida set nombre_comida = '$nombre_comida', autor = '$autor', costo_comida = '$costo_comida'
					where id_comida = $resourceId ";
		$resul = mysqli_query($conexion, $query_update);
		if ($resul){
			$respuesta['status'] = true;
			$respuesta['mensaje'] = 'Registro actualizado correctamente';
			echo json_encode($respuesta);
		}else{
			echo 'Error al insertar le registro';
		}
		mysqli_close($conexion);
	break;
	
	default:
		echo 'MEOTODO NO IMPLEMENTADO';
	break;
}
?>