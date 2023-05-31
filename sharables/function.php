<?php
if ($_SERVER["REQUEST_METHOD"] == "POST") {
  // collect value of input field
  $base64 = $_POST['data'];
  $create = $_POST['create'];
  $desc = $_POST['desc'];
  $uuid = "Pavojingųjų atliekų identifikavimo e. įrankis_".time().".pdf";
  $fileName = "Pavojingųjų atliekų identifikavimo e. įrankis_".time().".html";
  $pdf_decode = base64_decode($base64);

  file_put_contents($uuid, $pdf_decode);

  $dir = "{$_SERVER['SERVER_NAME']}/wp-content/plugins/aplinkos-ministerijos-pluginas/sharables/".$uuid."";

  if($create == true) {
    $htmlMarkup = '<!DOCTYPE html>
        <html lang="en">
        <head>
        <meta charset="UTF-8" />
        <title>'.$uuid.'</title>
        <meta name="viewport" content="width=device-width,initial-scale=1" />
        <meta name="description" content="'.$desc.'" />
        <meta property="og:image" content="logo.jpg" />
        <meta property="og:image:width" content="10" />
        <meta property="og:image:height" content="10" />
        <script type="text/javascript">
        function load()
        {
        window.open("'.$uuid.'","_self");
        }
        </script>
        </head>
        <body onload="load()">
        </body>
        </html>
        ';

    file_put_contents($fileName, $htmlMarkup);

    $html = "{$_SERVER['SERVER_NAME']}/wp-content/plugins/aplinkos-ministerijos-pluginas/sharables/".$fileName."";

    echo $html;
  } else {
    echo $dir;
  }
}
?>