<?php
if(isset($_GET['id'])){
	echo file_get_contents("http://vimeo.com/api/v2/video/".$_GET['id'].".json");	
}
?>