<?php
session_start();
if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_SESSION['allow_entrance']) && strip_tags($_SESSION['allow_entrance']) == 'Allowed' && isset($_SESSION['custom_nonce'])) {
    $post_data = file_get_contents("php://input");
    $data = json_decode($post_data);
    if($data && isset($data->desc) && isset($data->data) && isset($data->destination) && isset($data->nonce) && isset($_SESSION['custom_nonce'])) {
      if(strip_tags($data->nonce) == strip_tags($_SESSION['custom_nonce'])) {
        if(isset($data->create)) {
          $base64 = strip_tags($data->data);
          $desc = strip_tags($data->desc);
          $create = true;
          $uuid = strip_tags("Pavojinguju_atlieku_identifikavimo_e.irankis_".time().".pdf");
          $fileName = strip_tags("Pavojinguju_atlieku_identifikavimo_e.irankis_".time().".html");
          $destination = strip_tags($data->destination);
          share_content($base64, $uuid, $create, $desc, $fileName, $destination);
        } else {
          $base64 = strip_tags($data->data);
          $desc = strip_tags($data->desc);
          $create = false;
          $uuid = strip_tags("Pavojinguju_atlieku_identifikavimo_e.irankis_".time().".pdf");
          $fileName = strip_tags("Pavojinguju_atlieku_identifikavimo_e.irankis_".time().".html");
          $destination = strip_tags($data->destination);
          share_content($base64, $uuid, $create, $desc, $fileName, $destination);
        }
      } else {
        echo filter_var('Not allowed');
      }
    } else {
      echo filter_var('Missing required parameters');
    }
} else {
  echo filter_var('Not allowed');
}
  
  function share_content($base64, $uuid, $create, $desc, $fileName, $destination) {
      $pdf_decode = base64_decode($base64);
    
      $homeUrl = $_SERVER['PHP_SELF'];
    
      $exploded_string = explode("/", $homeUrl);
      $count = count($exploded_string) - 1;
    
      $realPath = $_SERVER['SERVER_NAME'];
    
      for($i = 0; $i < $count; $i++) {
        $realPath = "{$realPath}{$exploded_string[$i]}/";
      }
    
      file_put_contents($uuid, $pdf_decode);
    
      $dir = "$realPath$uuid";
    
      if($create == true) {
        $html = "$realPath$fileName";
  
        createHtml($uuid, $desc, $destination, $html, $fileName);
      } else {
        $newDir = '';
        if($destination == "linkedin") {
          $newDir = 'https://www.linkedin.com/sharing/share-offsite/?url=https://'.$dir.'';
        } else if ($destination == "email") {
          $newDir = 'mailto:?subject=Pavojingų%20atliekų%20įrankio%20rezultatas&body='.$dir.'';
        } else if ($destination == "print") {
          $newDir = 'https://'.$dir.'';
        }
        echo filter_var($newDir, FILTER_SANITIZE_URL);
      }
  }
  
  function createHtml($uuid, $desc, $destination, $fullPath, $fileName) {
    $link = '';
    if($destination == "facebook") {
      $link = 'https://www.facebook.com/sharer/sharer.php?u=https://'.$fullPath.'';
    } else if ($destination == "messenger") {
      $link = 'https://www.addtoany.com/add_to/facebook_messenger?linkurl='.$fullPath.'';
    }
    $html = '<!DOCTYPE html>
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
  
    file_put_contents($fileName, $html);
  
    echo filter_var($link, FILTER_SANITIZE_URL);
  }
?>