<?php
	$matches = [];
	$url = $_SERVER['REQUEST_URI'];
	$url_limpia = str_replace("/ws_comida/route.php","",$url);
	//if( preg_match('/\/([^\/]+)\/?/',$url_limpia,$matches ) ){
	if( preg_match('/\/([^\/]+)\/([^\/]+)/',$url_limpia,$matches ) ){
		//print_r(explode("/",$url_limpia));
		//$matches = explode("/",$url_limpia);
		//print_r($matches);
		$_GET['resource_type'] = $matches[1];
		$_GET['resource_id'] = $matches[2];
		require 'server.php';
	}elseif( preg_match('/\/([^\/]+)\/?/',$url_limpia,$matches ) ){
		$_GET['resource_type'] = $matches[1];
		require 'server.php';
	}else{
		error_log("no anda");
		http_response_code(400);
	}
?>