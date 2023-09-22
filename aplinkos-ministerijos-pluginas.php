<?php
/*
Plugin Name: Aplinkos Ministerijos - Norway Grants
Description: A plugin that helps users learn about waste management and disposal. Insert shortcode [aplinkos-ministerija] into website body.
Version: 1.0
Author: UAB THINKBIG LT
*/

if ( ! defined( 'ABSPATH' ) ) exit;

function amp_js_handler() {
    wp_enqueue_script('handler', plugin_dir_url(__FILE__) . 'js/handler.js', array('jquery'), '1.0', true);
    wp_localize_script('handler', 'handler_params', array(
        'ajax_url' => admin_url('admin-ajax.php')
    ));
}
add_action('wp_enqueue_scripts', 'amp_js_handler');

function amp_sharable_function() {
    $base64 = sanitize_text_field($_POST['data']);
    $desc = sanitize_text_field($_POST['desc']);
    $create = sanitize_text_field($_POST['create']);
    $destination = sanitize_text_field($_POST['destination']);
    $uuid = sanitize_text_field("Pavojinguju_atlieku_identifikavimo_e.irankis_".time().".pdf");
    $fileName = sanitize_text_field("Pavojinguju_atlieku_identifikavimo_e.irankis_".time().".html");
    if($create == "true") {
        amp_share_content($base64, $uuid, true, $desc, $fileName, $destination);
    } else {
        amp_share_content($base64, $uuid, false, $desc, $fileName, $destination);
    }
    die();
}
add_action('wp_ajax_amp_sharable_function', 'amp_sharable_function');
add_action('wp_ajax_nopriv_amp_sharable_function', 'amp_sharable_function');

function amp_share_content($base64, $uuid, $create, $desc, $fileName, $destination) {
    $pdf_decode = base64_decode($base64);
    $plugin_dir = plugin_dir_path(__FILE__);
    $pdf_path = sanitize_text_field($plugin_dir . 'sharables/' . $uuid);
    file_put_contents($pdf_path, $pdf_decode);
    
    //File location to pass
    $homeUrl = plugins_url('aplinkos-ministerijos-pluginas.php', __FILE__);
    $exploded_string = explode("/", $homeUrl);
    $count = count($exploded_string) - 1;
    $realPath = '';
    for($i = 0; $i < $count; $i++) {
        $realPath = "{$realPath}{$exploded_string[$i]}/";
    }
    //File location to pass end

    if($create === true) {
        $realPath = $realPath . 'sharables/' . $fileName;
        amp_create_html($uuid, $desc, $destination, $realPath, $fileName);
    } else {
        $realPath = $realPath . 'sharables/' . $uuid;
        $newDir = sanitize_text_field('');
        if(sanitize_text_field($destination) === sanitize_text_field('linkedin')) {
            $newDir = sanitize_url('https://www.linkedin.com/sharing/share-offsite/?url='.$realPath.'');
        } else if (sanitize_text_field($destination) === sanitize_text_field('email')) {
            $newDir = sanitize_url('mailto:?subject=Pavojingų%20atliekų%20įrankio%20rezultatas&body='.$realPath.'');
        } else if (sanitize_text_field($destination) === sanitize_text_field('print')) {
            $newDir = sanitize_url(''.$realPath.'');
        }
        echo esc_url($newDir);
    }
}

function amp_create_html($uuid, $desc, $destination, $fullPath, $fileName) {
    $link = sanitize_text_field('');
    if(sanitize_text_field($destination) === sanitize_text_field('facebook')) {
        $link = 'https://www.facebook.com/sharer/sharer.php?u='.$fullPath.'';
    } else if (sanitize_text_field($destination) === sanitize_text_field('messenger')) {
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

    $plugin_dir = plugin_dir_path(__FILE__);
    $html_path = sanitize_text_field($plugin_dir . 'sharables/' . $fileName);
    file_put_contents($html_path, $html);

    echo esc_url($link);
}

function amp_waste_management_shortcode() {
    // Define the waste categories and subcategories
    $homeUrl = plugins_url('rusiuok/index.html', __FILE__);

    // Generate the HTML for the waste management tool
    $html = '
        <div id="iframe-holder"></div><div id="container"><iframe title="Rušiavimo įrankis" scrolling="no" id="my-iframe" class="responsive-iframe" src="'.$homeUrl.'?t='.time().'" width="100%" frameborder="0" style="overflow: none"></iframe></div>
        <iframe title="Rušiavimo įrankis" id="static-iframe" src="'.$homeUrl.'" width="100%" height="10px" frameborder="0" style="overflow: none"></iframe>
    ';

        $html .= '<script>
        const another = document.getElementById("static-iframe");
        const childWindow = document.getElementById("my-iframe").contentWindow;
        var iframe = document.getElementById("my-iframe");
        if(another.contentWindow.document.body.scrollHeight != 10) {
          iframe.remove();

                            window.addEventListener("message", message => {
                              if (message.target[0] !== childWindow) {
                                  return; // Skip message in this event listener
                              }

                            if(message.data.goUp) {
                                window.scrollTo(0, 0);
                            }

                          });

        } else {
        another.remove();
        setTimeout(function() {
            iframe.contentWindow.postMessage("notStatic", "*");
        }, 5000);

        document.addEventListener("touchmove", function(e) {
            var iframe = document.querySelector("iframe");
            var iframeRect = iframe.getBoundingClientRect();
            var touch = e.touches[0];

        if (touch.clientX > iframeRect.left && touch.clientX < iframeRect.right &&
            touch.clientY > iframeRect.top && touch.clientY < iframeRect.bottom) {
                }
                    });
        window.setInterval(function(){
            var el = document.activeElement;
        }, 1000);

            window.addEventListener("message", message => {
                              if (message.target[0] !== childWindow) {
                                  return; // Skip message in this event listener
                              }

                            if(message.data.goUp) {
                                window.scrollTo(0, 0);
                            }

                              iframe.style.height = event.data.height + "px";

                          });

        }

                          </script>';
    // Return the HTML
    return $html;
}
add_shortcode('aplinkos-ministerija', 'amp_waste_management_shortcode');