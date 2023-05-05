<?php
if ($_SERVER["REQUEST_METHOD"] == "POST") {
  // collect value of input field
  $base64 = $_POST['data'];
  $uuid = time().".pdf";
  $pdf_decode = base64_decode($base64);


  file_put_contents($uuid, $pdf_decode);

  $dir = "{$_SERVER['SERVER_NAME']}/wp-content/plugins/aplinkos-ministerijos-pluginas/sharables/".$uuid."";

  echo $dir;
}
?>